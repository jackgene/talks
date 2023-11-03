module Deck.Slide exposing
  ( activeNavigationOf, slideFromLocationHash, slideView, firstQuestionIndex )

import Array exposing (Array)
import Css exposing
  ( property
  -- Container
  , bottom, height, margin, maxWidth, width, overflow, overflowY, position, right
  -- Content
  , backgroundColor, color, float, fontSize, opacity
  -- Units
  , auto, num, pct, vw
  -- Alignments & Positions
  , absolute, relative
  -- Other values
  , hidden, noWrap, rgb, whiteSpace
  )
import Deck.Common exposing (Model, Msg, Navigation, Slide(Slide), SlideModel)
import Deck.Font exposing (..)
import Deck.Slide.AdditionalConsiderations as AdditionalConsiderations
import Deck.Slide.Common exposing (UnindexedSlideModel, black, paragraphFontFamily, white)
import Deck.Slide.Cover as Cover
import Deck.Slide.ExampleApplication as ExampleApplication
import Deck.Slide.Operators as Operators
import Deck.Slide.Overview as Overview
import Deck.Slide.QuestionAnswer as QuestionAnswer
import Deck.Slide.WordCloud as WordCloud
import Deck.Slide.SectionCover as SectionCover
import Html.Styled exposing (Html, div, node, text)
import Html.Styled.Attributes exposing (css, type_)


-- Common
indexSlide : Int -> UnindexedSlideModel -> Slide
indexSlide index unindexedSlide =
  Slide
  { active = unindexedSlide.active
  , update = unindexedSlide.update
  , view = unindexedSlide.view index
  , index = index
  , eventsWsPath = unindexedSlide.eventsWsPath
  , animationFrames = unindexedSlide.animationFrames
  }


preQuestionSlides : List UnindexedSlideModel
preQuestionSlides =
  [ Cover.cover
  , WordCloud.wordCloud "Audience Word Cloud" "Words You Associate With Functional Reactive Streaming"
  , SectionCover.introduction
  ] ++
  Overview.slides ++
  [ SectionCover.operators ] ++
  Operators.slides ++
  [ SectionCover.application ] ++
  ExampleApplication.slides ++
  [ WordCloud.wordCloud ExampleApplication.heading "Visualizing the Word Counts as a Word Cloud"
  , SectionCover.additionalConsiderations
  , AdditionalConsiderations.distributedDeployment
  , ExampleApplication.implementationCompleteDistribution False
  , AdditionalConsiderations.eventSourcing
  , ExampleApplication.implementationCompleteEventSourcing False
  , WordCloud.wordCloud "Additional Considerations" "The New Word Cloud"
  -- Q & A
  , SectionCover.questions
  ]


questionSlides : List UnindexedSlideModel
questionSlides =
  [ QuestionAnswer.slide 0
  , QuestionAnswer.slide 1
  , QuestionAnswer.slide 2
  , QuestionAnswer.slide 3
  , QuestionAnswer.slide 4
  , QuestionAnswer.slide 5
  , QuestionAnswer.slide 6
  , QuestionAnswer.slide 7
  , QuestionAnswer.slide 8
  , QuestionAnswer.slide 9

  -- Thank you
  , SectionCover.thankYou
  ]


slidesList : List Slide
slidesList =
  List.indexedMap indexSlide (preQuestionSlides ++ questionSlides)


slides : Array Slide
slides = Array.fromList slidesList


activeNavigationOf : Model -> Array Navigation
activeNavigationOf model =
  let
    (onlyPrevsReversed, _) =
      List.foldl
      ( \(Slide slideModel) (accum, maybePrevIdx) ->
        ( ( { lastSlideIndex =
              case maybePrevIdx of
                Just prevIdx -> prevIdx
                Nothing -> slideModel.index
            , nextSlideIndex = -1
            }
          , slideModel
          ) :: accum
        , if not (slideModel.active model) then maybePrevIdx
          else Just slideModel.index
        )
      )
      ( [], Nothing )
      slidesList

    (withNexts, _) =
      List.foldl
      ( \(nav, slideModel) (accum, maybeNextIdx) ->
        ( { nav
          | nextSlideIndex =
            case maybeNextIdx of
              Just nextIdx -> nextIdx
              Nothing -> slideModel.index
          } :: accum
        , if not (slideModel.active model) then maybeNextIdx
          else Just slideModel.index
        )
      )
      ( [], Nothing )
      onlyPrevsReversed
  in
  Array.fromList withNexts


withinIndexRange : Array Slide -> Int -> Int
withinIndexRange slides desiredIndex =
  min
  ( ( Array.length slides ) - 1 )
  ( max 0 desiredIndex )


slideFromLocationHash : String -> Slide
slideFromLocationHash hash =
  Maybe.withDefault (indexSlide 0 Cover.cover)
  ( Maybe.andThen
    ( \parsedIndex -> Array.get (withinIndexRange slides parsedIndex) slides )
    ( Result.toMaybe
      ( String.toInt (String.dropLeft 7 hash) )
    )
  )


firstQuestionIndex : Int
firstQuestionIndex = List.length preQuestionSlides


-- View
slideView : Model -> SlideModel -> Html Msg
slideView model slide =
  div
  [ css
    [ property "display" "grid", position absolute
    , width (pct 100), height (pct 100)
    , backgroundColor (rgb 0 0 0)
    , overflowY auto
    ]
  ]
  [ node "style" [ type_ "text/css" ]
    [ text
      ( """
        @font-face {
          font-family: "Montserrat";
          src: url("data:font/woff2;base64,""" ++ fontMontserratBoldWoff2Base64 ++ """");
          font-weight: 700;
        }
        @font-face {
          font-family: "Open Sans";
          src: url("data:font/woff2;base64,""" ++ fontOpenSansRegularWoff2Base64 ++ """");
          font-weight: 400;
        }
        @font-face {
          font-family: "Open Sans";
          src: url("data:font/woff2;base64,""" ++ fontOpenSansRegularItalicWoff2Base64 ++ """");
          font-weight: 400;
          font-style: italic;
        }
        @font-face {
          font-family: "Open Sans";
          src: url("data:font/woff2;base64,""" ++ fontMontserratBoldWoff2Base64 ++ """");
          font-weight: 700;
        }
        @font-face {
          font-family: "Open Sans";
          src: url("data:font/woff2;base64,""" ++ fontOpenSansBoldItalicWoff2Base64 ++ """");
          font-weight: 700;
          font-style: italic;
        }
        @font-face {
          font-family: "Fira Code";
          src: url("data:font/woff2;base64,""" ++ fontFiraCodeRegularWoff2Base64 ++ """");
          font-weight: 400;
        }
        @font-face {
          font-family: "Fira Code";
          src: url("data:font/woff2;base64,""" ++ fontFiraCodeMediumWoff2Base64 ++ """");
          font-weight: 500;
        }
        @font-face {
          font-family: "Fira Code";
          src: url("data:font/woff2;base64,""" ++ fontFiraCodeBoldWoff2Base64 ++ """");
          font-weight: 700;
        }
        @font-face {
          font-family: "Glass TTY VT220";
          src: url("data:font/ttf;base64,""" ++ fontGlassTtyVt220TtfBase64 ++ """");
          font-weight: 400;
        }
        """
      )
    ]
  , div
    [ css
      [ position relative, width (pct 100), margin auto
      , overflow hidden, property "aspect-ratio" "16 / 9"
      , color black, backgroundColor white
      , paragraphFontFamily, fontSize (vw 2.2)
      ]
    ]
    [ slide.view model
    , if model.transcription.text == "" then div [] []
      else
        div
        [ css
          [ property "display" "grid", position absolute
          , bottom (pct 7.5), width (pct 100)
          ]
        ]
        [ div
          [ css
            [ margin auto, maxWidth (pct 95), overflow hidden
            ]
          ]
          [ div
            [ css
              [ backgroundColor black, color white, opacity (num 0.75)
              , whiteSpace noWrap, float right
              ]
            ]
            [ text model.transcription.text ]
          ]
        ]
    ]
  ]
