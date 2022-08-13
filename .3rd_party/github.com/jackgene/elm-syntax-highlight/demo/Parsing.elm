module Parsing exposing (main)


import Html.Styled as Html exposing (Attribute, Html, input, text, textarea)
import Html.Styled.Attributes exposing (type_)
import Html.Styled.Events exposing (onInput)
import Parser
import SyntaxHighlight.Language.TypeScript as TypeScript
import SyntaxHighlight.Model exposing (Block, Theme, Token)


-- Common
type alias Model =
  { rawText : String
  , tokens : Result Parser.Error (List Token)
  }


parseToken : String -> Result Parser.Error (List Token)
parseToken =
  Result.map List.reverse << TypeScript.parseTokensReversed


-- Init
init : (Model, Cmd Msg)
init =
  ( { rawText = ""
    , tokens = parseToken ""
    }
  , Cmd.none
  )


-- Update
type Msg = RawText String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    RawText text ->
      ( { model
        | rawText = text
        , tokens = parseToken text
        }
      , Cmd.none
      )


-- View
view : Model -> Html Msg
view _ = textarea [ onInput RawText ] []


main : Program Never Model Msg
main =
  Html.program
  { init = init
  , update = update
  , subscriptions = always Sub.none
  , view = view
  }
