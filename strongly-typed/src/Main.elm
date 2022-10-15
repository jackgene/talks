module Deck exposing (main)

import AnimationFrame
import Array exposing (Array)
import Deck.Common exposing
  ( Model, Msg(..), Navigation, Slide(Slide), SlideModel, typingSpeedMultiplier )
import Deck.Slide exposing
  ( activeNavigationOf, slideFromLocationHash, slideView, firstQuestionIndex )
import Dict exposing (Dict)
import Html.Styled exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Keyboard
import Navigation exposing (Location)
import Task
import Time exposing (Time)
import WebSocket


-- Init
webSocketBaseUrl : Location -> Maybe String
webSocketBaseUrl location =
  if location.protocol /= "http:" || location.hostname /= "localhost" then Nothing
  else Just ("ws" ++ (String.dropLeft 4 location.protocol) ++ "//" ++ location.host)


updateModelWithLocationHash : String -> Model -> Model
updateModelWithLocationHash hash model =
  let
    newSlide : Slide
    newSlide = slideFromLocationHash hash

    newModel : Model
    newModel = { model | currentSlide = newSlide }
  in
  { newModel
  | animationFramesRemaining =
    case newSlide of
      Slide slideModel -> slideModel.animationFrames newModel
  }


init : Location -> (Model, Cmd Msg)
init location =
  ( let
      incompleteModel : Model
      incompleteModel =
        updateModelWithLocationHash location.hash
        { eventsWsUrl =
          ( Maybe.map
            ( \baseUrl -> baseUrl ++ "/event" )
            ( webSocketBaseUrl location )
          )
        , activeNavigation = Array.empty
        , currentSlide = slideFromLocationHash "#"
        , animationFramesRemaining = 0
        , languagesAndCounts = []
        , typeScriptVsJavaScript =
          { typeScriptFraction = 0.0
          , lastVoteTypeScript = False
          }
        , questions = Array.empty
        , transcription = { text = "", updated = 0 }
        }

      activeNavigation : Array Navigation
      activeNavigation = activeNavigationOf incompleteModel
    in
    { incompleteModel
    | activeNavigation = activeNavigation
    }
  , Cmd.none
  )


-- Update
type EventBody
  = TokensByCount (List (Int, (List String)))
  | Questions (List String)


eventBodyDecoder : Decoder EventBody
eventBodyDecoder =
  Decode.oneOf
  [ Decode.map Questions
    ( Decode.field "chatText"
      (Decode.list Decode.string)
    )
  , Decode.map TokensByCount
    ( Decode.field "tokensByCount"
      ( Decode.list
        ( Decode.map2 (\l r -> (l, r))
          (Decode.index 0 Decode.int)
          (Decode.index 1 (Decode.list Decode.string))
        )
      )
    )
  ]


transcriptionDecoder : Decoder String
transcriptionDecoder =
  Decode.field "transcriptionText" Decode.string


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Next ->
      ( model
      , let
          curSlideIdx : Int
          curSlideIdx =
            case model.currentSlide of
              Slide slideModel -> slideModel.index

          newSlideIdx : Int
          newSlideIdx =
            Maybe.withDefault curSlideIdx
            ( Maybe.map
              .nextSlideIndex
              ( Array.get curSlideIdx model.activeNavigation )
            )
        in
          if newSlideIdx == curSlideIdx then Cmd.none
          else Navigation.newUrl ("#slide-" ++ toString newSlideIdx)
      )

    Last ->
      ( model
      , let
          curSlideIdx : Int
          curSlideIdx =
            case model.currentSlide of
              Slide slideModel -> slideModel.index

          newSlideIdx : Int
          newSlideIdx =
            Maybe.withDefault curSlideIdx
            ( Maybe.map
              .lastSlideIndex
              ( Array.get curSlideIdx model.activeNavigation )
            )
        in
          if newSlideIdx == curSlideIdx then Cmd.none
          else
            Navigation.newUrl
            ( if newSlideIdx == 0 then "#"
              else "#slide-" ++ toString newSlideIdx
            )
      )

    NewLocation location ->
      ( let
          newSlide : Slide
          newSlide = slideFromLocationHash location.hash

          newModel : Model
          newModel = { model | currentSlide = newSlide }
        in
        { newModel
        | animationFramesRemaining =
          case newSlide of
            Slide slideModel -> slideModel.animationFrames newModel
        }
      , Cmd.none
      )

    Event body ->
      case Decode.decodeString eventBodyDecoder body of
        Ok (TokensByCount langsByCount) ->
          let
            langsAndCounts : List (String, Int)
            langsAndCounts =
              Dict.foldr
              ( \count langs accum ->
                accum ++ (
                  List.map
                  ( \lang -> (lang, count) )
                  langs
                )
              )
              []
              ( Dict.fromList langsByCount ) -- Sorts by count

            (jsCount, tsCount) =
              List.foldl
              ( \(lang, count) (jsCountAcc, tsCountAcc) ->
                case lang of
                  "JavaScript" -> (toFloat count, tsCountAcc)
                  "TypeScript" -> (jsCountAcc, toFloat count)
                  _ -> (jsCountAcc, tsCountAcc)
              )
              (0.0, 0.0)
              langsAndCounts

            tsFrac : Float
            tsFrac = tsCount / (tsCount + jsCount)

            statsUpdatedModel : Model
            statsUpdatedModel =
              { model
              | languagesAndCounts = langsAndCounts
              , typeScriptVsJavaScript =
                { typeScriptFraction = tsFrac
                , lastVoteTypeScript =
                  tsFrac > model.typeScriptVsJavaScript.typeScriptFraction
                }
              }

            activeNavigation : Array Navigation
            activeNavigation = activeNavigationOf statsUpdatedModel
          in
          ( { statsUpdatedModel | activeNavigation = activeNavigation }
          , Cmd.none
          )

        Ok (Questions questions) ->
          let
            -- Event updates slide being displayed
            isCurrentQuestion : Bool
            isCurrentQuestion =
              case model.currentSlide of
                Slide slideModel ->
                  (slideModel.index - firstQuestionIndex + 1) == List.length questions

            questionUpdatedModel : Model
            questionUpdatedModel =
              { model
              | animationFramesRemaining =
                if isCurrentQuestion then
                  typingSpeedMultiplier *
                  ( Maybe.withDefault 0
                    ( Maybe.map String.length
                      ( List.head (List.reverse questions) )
                    )
                  )
                else 0
              , questions = Array.fromList questions
              }

            activeNavigation : Array Navigation
            activeNavigation = activeNavigationOf questionUpdatedModel
          in
          ( { questionUpdatedModel | activeNavigation = activeNavigation }
          , Cmd.none
          )

        Err jsonErr ->
          let
            _ = Debug.log ("Error parsing JSON: " ++ jsonErr ++ " for event") body
          in (model, Cmd.none)

    TranscriptionText body ->
      case Decode.decodeString transcriptionDecoder body of
        Ok text ->
          let
            transcription : { text : String, updated : Time }
            transcription = model.transcription
          in
          ( { model
            | transcription = { transcription | text = text }
            }
          , Task.perform TranscriptionUpdated Time.now
          )

        Err jsonErr ->
          let
            _ = Debug.log ("Error parsing JSON: " ++ jsonErr ++ " for transcription") body
          in (model, Cmd.none)

    TranscriptionUpdated updated ->
      let
        transcription : { text : String, updated : Time }
        transcription = model.transcription
      in
      ( { model
        | transcription = { transcription | updated = updated }
        }
      , Cmd.none
      )

    TranscriptionClearingTick time ->
      ( if (time - model.transcription.updated) < (5 * Time.second) then model
        else
          let
            transcription : { text : String, updated : Time }
            transcription = model.transcription

            charsToDrop : Int
            charsToDrop =
              case String.indices " " transcription.text of
                index :: _ -> index + 1
                _ -> String.length transcription.text
          in
          { model
          | transcription =
            { transcription
            | text = String.dropLeft charsToDrop transcription.text
            }
          }
      , Cmd.none
      )

    AnimationTick ->
      ( { model | animationFramesRemaining = model.animationFramesRemaining - 1 }
      , Cmd.none
      )

    NoOp -> (model, Cmd.none)


-- View
view : Model -> Html Msg
view model =
  case model.currentSlide of
    Slide slideModel -> slideView model slideModel


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ if model.transcription.text == "" then Sub.none
    else Time.every (80 * Time.millisecond) TranscriptionClearingTick
  , case model.eventsWsUrl of
      Just url ->
        Sub.batch
        [ WebSocket.listen (url ++ "/transcription") TranscriptionText
        , let
            eventsWsPath : Maybe String
            eventsWsPath =
              case model.currentSlide of
                Slide slideModel -> slideModel.eventsWsPath
          in
          case eventsWsPath of
            Just path ->
              WebSocket.listen (url ++ "/" ++ path) Event
            _ -> Sub.none
        ]
      _ -> Sub.none
  , if model.animationFramesRemaining <= 0 then Sub.none
    else AnimationFrame.times (always AnimationTick)
  , Keyboard.ups
    ( \keyCode ->
      case keyCode of
        13 -> Next -- Enter
        32 -> Next -- Space
        37 -> Last -- Left
        38 -> Last -- Up
        39 -> Next -- Right
        40 -> Next -- Down
        _ -> NoOp
    )
  ]


main : Program Never Model Msg
main =
  Navigation.program NewLocation
  { init = init
  , update = update
  , view = Html.Styled.toUnstyled << view
  , subscriptions = subscriptions
  }
