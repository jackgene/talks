module Deck.Slide.TypeSystemProperties exposing
  ( heading, tableOfContent, methodology, languageReport, errorPreventionReport )

import Css exposing
  ( Color, Style, property
  -- Container
  , borderBottom3, borderCollapse, borderLeft3, display, displayFlex
  , flexDirection, flexWrap, height, margin2, position, right, top
  , transform, width
  -- Content
  , backgroundColor, color, fontSize, opacity, textAlign, verticalAlign
  -- Units
  , em, deg, pct, rgb, vw, zero
  -- Alignments & Positions
  , absolute, center, middle, relative
  -- Transforms
  , rotate
  -- Other values
  , auto, collapse, column, inlineBlock, left, num, solid, wrap
  )
import Css.Transitions exposing (easeInOut, transition)
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (logosByLanguage, numberedDisc)
import Deck.Slide.Template exposing (standardSlideView)
import Dict exposing (Dict)
import Html.Styled exposing (Html, text, div, p, table, td, th, tr)
import Html.Styled.Attributes exposing (css)
import Set
import Svg.Styled.Attributes as SvgAttributes


-- Type
type alias Score =
  { upper : Float
  , range : Float
  , rank : Int
  }


type alias CumulativeScore =
  { previous : Score
  , current : Score
  }

type alias TypeSystemProperty =
  { name : String
  , problem : String
  , individualScores: Dict String Score
  , cumulativeScores : Dict String CumulativeScore
  }


-- Constants
heading : String
heading = "Type System Properties"


-- 1.0 - 1.0
scoreRequired : Score
scoreRequired = { range = 0.0, upper = 1.0, rank = -1 }


-- 0.5 - 1.0
scoreDefeatable : Score
scoreDefeatable = { range = 0.5, upper = 1.0, rank = -1 }


-- 0.0 - 1.0
scoreOptional : Score
scoreOptional = { range = 1.0, upper = 1.0, rank = -1 }


-- 0.0 - 0.5 - also "implementable"
scorePartialAndOptional : Score
scorePartialAndOptional = { range = 0.5, upper = 0.5, rank = -1 }


-- 0.0 - 0.0
scoreUnsupported : Score
scoreUnsupported = { range = 0.0, upper = 0.0, rank = -1 }


typeSystemProperties : List TypeSystemProperty
typeSystemProperties =
  let
    nameProblemAndScores : List (String, String, Dict String Score)
    nameProblemAndScores =
      List.map
      ( \(name, description, scores) ->
        ( name
        , description
        , Dict.filter ( \lang _ -> Set.member lang languages ) scores
        )
      )
      --[ ( "Memory Safety", "Memory Leaks, Buffer Overlow"
      --  , Dict.fromList
      --    [ ( "Go", scoreDefeatable )
      --    , ( "Python", scoreRequired )
      --    , ( "TypeScript", scoreRequired )
      --    , ( "Kotlin", scoreRequired )
      --    , ( "Swift", scoreDefeatable )
      --    , ( "Elm", scoreRequired )
      --    ]
      --  )
      [ ( "Type Safety", "Type Mismatch"
        , Dict.fromList
          [ ( "Go", scoreRequired )
          , ( "Python", scoreOptional )
          , ( "TypeScript", scorePartialAndOptional )
          , ( "Scala", scoreRequired )
          , ( "Kotlin", scoreRequired )
          , ( "Swift", scoreRequired )
          , ( "Elm", scoreRequired )
          ]
        )
      , ( "Null Safety", "Null Pointer Dereference"
        , Dict.fromList
          [ ( "Go", scoreUnsupported )
          , ( "Python", scoreOptional )
          , ( "TypeScript", scoreOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreDefeatable )
          , ( "Swift", scoreDefeatable )
          , ( "Elm", scoreRequired )
          ]
        )
      , ( "Safe Array Access", "Out Of Bounds Array Access"
        , Dict.fromList
          [ ( "Go", scoreUnsupported )
          , ( "Python", scorePartialAndOptional )
          , ( "TypeScript", scoreOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreOptional )
          , ( "Swift", scorePartialAndOptional )
          , ( "Elm", scoreRequired )
          ]
        )
      , ( "Safe Type Conversion", "Type Conversion Failure"
        , Dict.fromList
          [ ( "Go", scorePartialAndOptional )
          , ( "Python", scorePartialAndOptional )
          , ( "TypeScript", scorePartialAndOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreDefeatable )
          , ( "Swift", scoreDefeatable )
          , ( "Elm", scoreRequired )
          ]
        )
      , ( "Exception Safety", "Unhandled Recoverable Error"
        , Dict.fromList
          [ ( "Go", scoreUnsupported )
          , ( "Python", scorePartialAndOptional )
          , ( "TypeScript", scorePartialAndOptional )
          , ( "Scala", scorePartialAndOptional )
          , ( "Kotlin", scorePartialAndOptional )
          , ( "Swift", scoreDefeatable )
          , ( "Elm", scoreRequired )
          ]
        )
      , ( "Exhaustiveness Checking", "Inexhaustive Match"
        , Dict.fromList
          [ ( "Go", scoreUnsupported )
          , ( "Python", scoreOptional )
          , ( "TypeScript", scoreOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreOptional )
          , ( "Swift", scoreOptional )
          , ( "Elm", scoreOptional )
          ]
        )
      , ( "Encapsulation", "State Data Corruption"
        , Dict.fromList
          [ ( "Go", scoreOptional )
          , ( "Python", scoreOptional )
          , ( "TypeScript", scoreOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreOptional )
          , ( "Swift", scoreOptional )
          , ( "Elm", scoreOptional )
          ]
        )
      , ( "Immutability", "Unintended State Mutation"
        , Dict.fromList
          [ ( "Go", scorePartialAndOptional )
          , ( "Python", scorePartialAndOptional  )
          , ( "TypeScript", scoreOptional )
          , ( "Scala", scoreOptional )
          , ( "Kotlin", scoreOptional )
          , ( "Swift", scoreOptional )
          , ( "Elm", scoreRequired )
          ]
        )
      --, ( "Data Race Freedom", "Data Race"
      --  , Dict.fromList
      --    [ ( "Go", scoreUnsupported )
      --    , ( "Python", scoreUnsupported )
      --    , ( "TypeScript", scoreRequired )
      --    , ( "Kotlin", scoreUnsupported )
      --    , ( "Swift", scoreUnsupported )
      --    , ( "Elm", scoreRequired )
      --    ]
      --  )
      ]

    initialCumulativeScores : Dict String Score -> Dict String CumulativeScore
    initialCumulativeScores scores =
      let
        rankedScores : Dict String Score
        rankedScores =
          Dict.fromList
          ( List.indexedMap
            ( \rank (langKey, score) ->
              ( langKey
              , { score | rank = rank }
              )
            )
            ( List.sortBy
              ( \(_, score) -> (-score.upper, score.range) )
              ( Dict.toList scores )
            )
          )
      in
      Dict.map
      ( \_ score ->
        { current = score
        , previous = { scoreUnsupported | rank = score.rank }
        }
      )
      rankedScores

    propertiesAndCumulativeScores : List (String, String, (Dict String Score, Dict String CumulativeScore))
    propertiesAndCumulativeScores =
      List.foldl
      ( \(name, problem, scores) accum ->
        case accum of
          [] -> [ (name, problem, (scores, initialCumulativeScores scores)) ]

          (_, _, (_, prevCumScores)) :: _ ->
            let
              curCumScoresUnranked : Dict String CumulativeScore
              curCumScoresUnranked =
                Dict.merge
                ( \_ _ scoresAccum -> scoresAccum )
                ( \langKey curScore prevCumScore scoresAccum ->
                  Dict.insert langKey
                  { current =
                    { upper = curScore.upper + prevCumScore.current.upper
                    , range = curScore.range + prevCumScore.current.range
                    , rank = -1
                    }
                  , previous = prevCumScore.current
                  }
                  scoresAccum
                )
                Dict.insert
                scores prevCumScores Dict.empty

              curCumScores : Dict String CumulativeScore
              curCumScores =
                Dict.fromList
                ( List.indexedMap
                  ( \rank (langKey, cumScore) ->
                    ( langKey
                    , { cumScore
                      | current =
                        let
                          curCumScoreUnranked : Score
                          curCumScoreUnranked = cumScore.current
                        in
                        { curCumScoreUnranked | rank = rank }
                      }
                    )
                  )
                  ( List.sortBy
                    ( \(_, cumScore) ->
                      (-cumScore.current.upper, cumScore.current.range, cumScore.previous.rank)
                    )
                    ( Dict.toList curCumScoresUnranked)
                  )
                )
            in
            (name, problem, (scores, curCumScores)) :: accum
      )
      []
      nameProblemAndScores
  in
  List.reverse
  ( List.map
    ( \(name, problem, (scores, cumulativeScores)) ->
      { name = name
      , problem = problem
      , individualScores = scores
      , cumulativeScores = cumulativeScores
      }
    )
    propertiesAndCumulativeScores
  )


numTypeSystemProperties : Int
numTypeSystemProperties = List.length typeSystemProperties


-- Slides
tableOfContent : Maybe Int -> UnindexedSlideModel
tableOfContent maybePropertyIndex =
  { baseSlideModel
  | view =
    let
      maybeTypeSystemProperty : Maybe TypeSystemProperty
      maybeTypeSystemProperty =
        Maybe.andThen
        ( \propertyIndex ->
          List.head ( List.drop propertyIndex typeSystemProperties )
        )
        maybePropertyIndex

      slideTitle : String
      slideTitle =
        case maybeTypeSystemProperty of
          Just property -> heading ++ ": " ++ property.name
          Nothing -> heading
    in
    ( \page _ ->
      standardSlideView page slideTitle
      "Characteristics of a Type System That Make It Strong"
      ( div
        [ css
          [ displayFlex, flexDirection column, flexWrap wrap, height (vw 32)
          , margin2 zero (em 1)
          ]
        ]
        ( List.indexedMap
          ( \idx { name } ->
            div
            [ css
              [ display inlineBlock, width (vw 40), margin2 (em 0.125) zero
              , opacity
                ( num
                  ( case maybePropertyIndex of
                    Just hlIdx -> if idx == hlIdx then 1.0 else 0.2
                    Nothing -> 1.0
                  )
                )
              ]
            ]
            [ numberedDisc (toString (idx + 1)) 64
              [ SvgAttributes.css [ width (vw 5), margin2 (em 0.2) (em 0.5), verticalAlign middle ] ]
            , text name
            ]
          )
          typeSystemProperties
        )
      )
    )
  }


scoreNumberView : String -> Html msg
scoreNumberView score =
  numberedDisc score 48 [ SvgAttributes.css [ width (vw 4), margin2 (em 0.2) (em 0.5), verticalAlign middle ] ]


methodology : UnindexedSlideModel
methodology =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Analysis of Some Popular Languages"
      ( div []
        [ p []
          [ text "We will go through each type system property "
          , text "and evaluates how they apply to a number of popular languages. "
          ]
        , p []
          [ text "For each language & property, a lower and upper-bound score is assigned:"
          ]
        , table [ css [ width (pct 96), margin2 zero auto, borderCollapse collapse ] ]
          [ tr [ css [ subHeaderStyle ] ]
            [ th [ css [ width (pct 12), borderBottom3 (vw 0.1) solid black ] ] [ text "Score" ]
            , th
              [ css [ width (pct 44), borderBottom3 (vw 0.1) solid black, textAlign left ] ]
              [ text "Upper" ]
            , th
              [ css [ width (pct 44), borderBottom3 (vw 0.1) solid black, textAlign left ] ]
              [ text "Lower" ]
            ]
          , tr []
            [ th [] [ scoreNumberView "1.0" ]
            , td [] [ text "Built-in" ]
            , td [] [ text "Impossible or Difficult to Defeat" ]
            ]
          , tr []
            [ th [] [ scoreNumberView "0.5" ]
            , td [] [ text "Can Be Implemented" ]
            , td [] [ text "Some Effort to Defeat" ]
            ]
          , tr []
            [ th [] [ scoreNumberView "0.0" ]
            , td [] [ text "Impossible to Implement" ]
            , td [] [ text "Easy to Accidentally Defeat" ]
            ]
          ]
        ]
      )
    )
  }


labelWidthPct : Float
labelWidthPct = 7.5


languageReport : Int -> UnindexedSlideModel
languageReport propertyIndex =
  { baseSlideModel
  | animationFrames = always 1
  , view =
    let
      property : TypeSystemProperty
      property =
        Tuple.first
        ( List.foldl
          ( \next (acc, idx) ->
            ( if propertyIndex < 0 || propertyIndex >= idx then next else acc
            , idx + 1
            )
          )
          ( { name = "", problem = "", individualScores = Dict.empty, cumulativeScores = Dict.empty }, 0 )
          typeSystemProperties
        )

      propertyHeading : String
      propertyHeading =
        if propertyIndex < 0 || propertyIndex >= List.length typeSystemProperties then heading
        else heading ++ ": " ++ property.name

      numLanguages : Float
      numLanguages = toFloat (Dict.size property.cumulativeScores)

      chartAreaHeightVw : Float
      chartAreaHeightVw = 4.75 * (min 6.0 numLanguages)

      barFromTopVw : Float
      barFromTopVw = chartAreaHeightVw / numLanguages

      barHeightVw : Float
      barHeightVw = barFromTopVw * 0.55
    in
    ( \page model ->
      standardSlideView page propertyHeading
      "Strong Typing Score Card"
      ( div []
        [ p [] [ text "Type system strengths of the languages we are evaluating:" ]
        , div [ css [ width (pct 90), margin2 zero auto ] ]
          [ div [ css [ position relative, height (vw chartAreaHeightVw) ] ]
            ( -- Vertical lines
              List.map
              ( \score ->
                div
                [ css
                  [ position absolute
                  , left (pct (labelWidthPct - 0.05 + toFloat score * (100 - labelWidthPct) / toFloat numTypeSystemProperties))
                  , height (pct 96)
                  , borderLeft3 (vw 0.1) solid lightGrey
                  ]
                ]
                []
              )
              ( List.range 0 numTypeSystemProperties )
            ++ -- Score bars
              List.map
              ( \(language, cumScore) ->
                let
                  score : Score
                  score =
                    if model.animationFramesRemaining == 0 then cumScore.current
                    else cumScore.previous
                in
                div
                [ css
                  [ position absolute
                  , top (vw (0.5 + toFloat score.rank * barFromTopVw))
                  , width (pct 100)
                  , transition [ Css.Transitions.top3 (transitionDurationMs * 2) 0 easeInOut ]
                  ]
                ]
                [ div
                  [ css
                    [ position absolute, top zero, left zero, width (pct 5)
                    , textAlign right
                    ]
                  ]
                  [ Maybe.withDefault
                    ( text language )
                    ( Dict.get language logosByLanguage )
                  ]
                , div
                  [ css [ position absolute, top zero, left (pct labelWidthPct), right zero ] ]
                  [ div
                    [ css
                      [ position absolute
                      , right (pct (-0.375 + 100 * (toFloat numTypeSystemProperties - score.upper) / toFloat numTypeSystemProperties))
                      , width (pct (0.75 + 100 * (score.range / toFloat numTypeSystemProperties)))
                      , height (vw barHeightVw)
                      , backgroundColor primary, opacity (num 0.75)
                      , transition
                        [ Css.Transitions.right3 (transitionDurationMs * 2) 0 easeInOut
                        , Css.Transitions.width3 (transitionDurationMs * 2) 0 easeInOut
                        ]
                      ]
                    ]
                    []
                  ]
                ]
              )
              ( Dict.toList property.cumulativeScores )
            )
          , -- Score labels
            div [ css [ position relative ] ]
            ( List.map
              ( \score ->
                div
                [ css
                  [ position absolute
                  , left (pct (labelWidthPct - 0.625 + toFloat score * (100 - labelWidthPct) / toFloat numTypeSystemProperties))
                  , width (vw 1)
                  , color darkGray, fontSize (em 0.625)
                  , textAlign center
                  ]
                ]
                [ text (toString score) ]
              )
              ( List.range 0 numTypeSystemProperties )
            )
          ]
        ]
      )
    )
  }


errorPreventionReport : String -> UnindexedSlideModel
errorPreventionReport language =
  { baseSlideModel
  | view =
    ( \page _ ->
      let
        languageHeading : String
        languageHeading = "Strong Typing & Quality Software"

        subheading : String
        subheading = "Errors Prevented by the " ++ language ++ " Type System"

        errorsAndScores : List (String, Score)
        errorsAndScores =
          [ ("Memory Leak", scoreRequired)
          , ("Buffer Overflow", scoreRequired)
          ]
          ++( List.filterMap
              ( \{ problem, individualScores } ->
                Maybe.map
                ( \score -> (problem, score) )
                ( Dict.get language individualScores )
              )
              typeSystemProperties
            )
          ++[ ("Data Race", if language == "Elm" || language == "TypeScript" then scoreRequired else scoreUnsupported)
            , ("Arithmetic Error", scoreUnsupported)
            , ("Infinite Loop", scoreUnsupported)
            , ("Functional Error", scoreUnsupported)
            , ("Others", scoreUnsupported)
            ]

        legendAndScores : List (String, Score)
        legendAndScores =
          [ ("Error Prevented", scoreRequired)
          , ("Error Probably Prevented", scoreDefeatable)
          , ("Error Possibly Prevented", scoreOptional)
          , ("Error Probably Not Prevented", scorePartialAndOptional)
          , ("Error Not Prevented", scoreUnsupported)
          ]

        scoreColor : Score -> Style
        scoreColor score =
          Css.batch
          ( case (score.upper, score.range) of
            (1.0, 0.0) ->
              [ color (rgb 21 96 66), backgroundColor (rgb 221 247 225) ]
            (1.0, 0.5) ->
              [ color (rgb 128 185 69), backgroundColor (rgb 238 247 208) ]
            (1.0, 1.0) ->
              [ color (rgb 245 145 15), backgroundColor (rgb 255 246 191) ]
            (0.5, 0.5) ->
              [ color (rgb 171 77 0), backgroundColor (rgb 255 222 196) ]
            (0.0, 0.0) ->
              [ color (rgb 143 37 4), backgroundColor (rgb 255 213 200) ]
            _ ->
              [ color darkGray, backgroundColor lightGrey]
          )

      in
      standardSlideView page languageHeading subheading
      ( div [ css [ fontSize (em 0.75) ] ]
        [ div [ css [ displayFlex, height (vw 20) ] ]
          ( List.map
            ( \(error, score) ->
              div
              [ css
                [ property "display" "grid"
                , scoreColor score
                , width (pct (100.0 / toFloat (List.length errorsAndScores)))
                ]
              ]
              [ div
                [ css
                  [ position relative, left (pct -30), width (vw 15)
                  , margin2 auto auto
                  , transform ( rotate (deg -90) )
                  , textAlign center
                  ]
                ]
                [ text error ]
              ]
            )
            ( List.sortBy
              ( \(_, score) -> (-score.upper, score.range) )
              errorsAndScores
            )
          )
        , div []
          ( List.map
            ( \(legend, score) ->
              div [ css [ margin2 (em 0.25) zero ] ]
              [ div
                [ css
                  [ display inlineBlock, width (em 0.75), height (em 0.75)
                  , margin2 zero (em 0.25)
                  , scoreColor score
                  ]
                ]
                []
              , text legend
              ]
            )
            legendAndScores
          )
        ]
      )
    )
  }
