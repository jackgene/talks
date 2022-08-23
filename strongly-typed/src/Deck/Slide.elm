module Deck.Slide exposing (activeNavigationOf, slideFromLocationHash, slideView, firstQuestionIndex)

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
import Deck.Slide.Common exposing (UnindexedSlideModel, black, paragraphFontFamily, white)
import Deck.Slide.QuestionAnswer as QuestionAnswer
import Deck.Slide.Cover as Cover
import Deck.Slide.AudiencePoll as AudiencePoll
import Deck.Slide.SectionCover as SectionCover
import Deck.Slide.Introduction as Introduction
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Deck.Slide.TypeSafety as TypeSafety
import Deck.Slide.NullSafety as NullSafety
import Deck.Slide.ExceptionSafety as ExceptionSafety
import Deck.Slide.SafeTypeConversion as SafeTypeConversion
import Deck.Slide.SafeArrayAccess as SafeArrayAccess
import Deck.Slide.ExhaustivenessChecking as ExhaustivenessChecking
import Deck.Slide.Immutability as Immutability
import Deck.Slide.Encapsulation as Encapsulation
import Deck.Slide.Conclusion as Conclusion
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
  , AudiencePoll.poll, AudiencePoll.jsVsTs

  -- Introduction
  , SectionCover.introduction
  , Introduction.wikipediaDefinitions
  --, Introduction.typefulDefinitions
  , Introduction.ourDefinition
  , Introduction.outOfScope
  , Introduction.inScope

  -- Type System Properties
  , SectionCover.typeSystemProperties
  , TypeSystemProperties.tableOfContent Nothing
  , TypeSystemProperties.methodology
  , TypeSystemProperties.tableOfContent (Just 0)
  , TypeSafety.introduction
  , TypeSafety.safeGo
  , TypeSafety.invalidSafeGo
  , TypeSafety.invalidUnsafeGo
  , TypeSafety.unsafeGo
  , TypeSafety.safePython
  , TypeSafety.invalidSafePython
  , TypeSafety.unsafePythonUnannotated
  , TypeSafety.unsafePythonRun
  , TypeSafety.pythonTypeHintUnannotated
  , TypeSafety.pythonTypeHintWrong
  , TypeSafety.pythonTypeHintWrongRun
  , TypeSafety.safeTypeScript
  , TypeSafety.invalidSafeTypeScript
  , TypeSafety.unsafeTypeScriptAny
  , TypeSafety.unsafeTypeScriptUnannotated
  , TypeSafety.unsafeTypeScriptFuncParam
  , TypeSafety.safeKotlin
  , TypeSafety.invalidSafeKotlin
  , TypeSafety.invalidUnsafeKotlin
  , TypeSafety.unsafeKotlin
  , TypeSafety.safeSwift
  , TypeSafety.invalidSafeSwift
  , TypeSafety.invalidUnsafeSwift
  , TypeSafety.unsafeSwift
  , TypeSystemProperties.languageReport 0
  , TypeSystemProperties.tableOfContent (Just 1)
  , NullSafety.introduction
  , NullSafety.unsafeGo
  , NullSafety.unsafeGoRun
  , NullSafety.safePythonNonNull
  , NullSafety.safePythonNonNullInvalid
  , NullSafety.safePythonNullableInvalid
  , NullSafety.safePythonNullable
  , NullSafety.safeTypeScriptNonNull
  , NullSafety.safeTypeScriptNonNullInvalid
  , NullSafety.safeTypeScriptNullableInvalid
  , NullSafety.safeTypeScriptNullable
  , NullSafety.safeKotlinNullable
  , NullSafety.unsafeKotlin
  , NullSafety.safeSwiftNullable
  , NullSafety.safeSwiftNullableFun
  , NullSafety.unsafeSwift
  , TypeSystemProperties.languageReport 1
  , TypeSystemProperties.tableOfContent (Just 2)
  , SafeArrayAccess.introduction
  , SafeArrayAccess.unsafeGo
  , SafeArrayAccess.unsafeGoRun
  , SafeArrayAccess.unsafePython
  , SafeArrayAccess.safePython
  , SafeArrayAccess.unsafeTypeScript
  , SafeArrayAccess.safeTypeScriptInvalid
  , SafeArrayAccess.safeTypeScript
  , SafeArrayAccess.unsafeKotlin
  , SafeArrayAccess.safeKotlin
  , SafeArrayAccess.unsafeSwift
  , SafeArrayAccess.safeSwift
  , TypeSystemProperties.languageReport 2
  , TypeSystemProperties.tableOfContent (Just 3)
  , SafeTypeConversion.introduction
  , SafeTypeConversion.safeGo
  , SafeTypeConversion.introGo
  , SafeTypeConversion.unsafeGo
  , SafeTypeConversion.unsafeGoRun
  , SafeTypeConversion.safePython
  , SafeTypeConversion.unsafePythonGoodGuard
  , SafeTypeConversion.unsafePythonBadGuard
  , SafeTypeConversion.unsafePythonBadGuardRun
  , SafeTypeConversion.unsafePythonCast
  , SafeTypeConversion.safeTypeScript
  , SafeTypeConversion.unsafeTypeScriptGoodPredicateInvalid
  , SafeTypeConversion.unsafeTypeScriptGoodPredicate
  , SafeTypeConversion.unsafeTypeScriptBadPredicate
  , SafeTypeConversion.unsafeTypeScriptBadPredicateRun
  , SafeTypeConversion.unsafeTypeScriptCast
  , SafeTypeConversion.safeKotlinSmart
  , SafeTypeConversion.safeKotlinExplicit
  , SafeTypeConversion.unsafeKotlin
  , SafeTypeConversion.safeSwift
  , SafeTypeConversion.unsafeSwift
  , TypeSystemProperties.languageReport 3
  , TypeSystemProperties.tableOfContent (Just 4)
  , ExceptionSafety.introduction
  , ExceptionSafety.introGo
  , ExceptionSafety.unsafeGoExplicit
  , ExceptionSafety.unsafeGoVariableReuse
  , ExceptionSafety.unsafePython
  , ExceptionSafety.unsafePythonRun
  , ExceptionSafety.safePython
  , ExceptionSafety.safePythonInvalid
  , ExceptionSafety.unsafeTypeScript
  , ExceptionSafety.safeTypeScript
  , ExceptionSafety.safeTypeScriptInvalid
  , ExceptionSafety.unsafeKotlin
  , ExceptionSafety.safeKotlin
  , ExceptionSafety.safeKotlinInvalid
  , ExceptionSafety.safeSwift
  , ExceptionSafety.safeSwiftInvalid
  , ExceptionSafety.safeSwiftInvocation
  , ExceptionSafety.unsafeSwift
  , ExceptionSafety.safeSwiftMonadic
  , ExceptionSafety.safeSwiftMonadicInvalid
  , TypeSystemProperties.languageReport 4
  , TypeSystemProperties.tableOfContent (Just 5)
  , ExhaustivenessChecking.introduction
  , ExhaustivenessChecking.unsafeGoPrep
  , ExhaustivenessChecking.unsafeGo
  , ExhaustivenessChecking.safePython
  , ExhaustivenessChecking.safePythonInvalid
  , ExhaustivenessChecking.safeTypeScript
  , ExhaustivenessChecking.safeTypeScriptInvalid
  , ExhaustivenessChecking.safeKotlin
  , ExhaustivenessChecking.safeKotlinInvalid
  , ExhaustivenessChecking.safeSwiftPrep
  , ExhaustivenessChecking.safeSwift
  , ExhaustivenessChecking.safeSwiftInvalid
  , ExhaustivenessChecking.safeSwiftAlt
  , TypeSystemProperties.languageReport 5
  , TypeSystemProperties.tableOfContent (Just 6)
  , Encapsulation.introduction
  , Encapsulation.safeGoPrep
  , Encapsulation.safeGo
  , Encapsulation.safePython
  , Encapsulation.safeTypeScript
  , Encapsulation.safeKotlin
  , Encapsulation.safeSwift
  , TypeSystemProperties.languageReport 6
  , TypeSystemProperties.tableOfContent (Just 7)
  , Immutability.introduction
  , Immutability.unsafeGoPrep
  , Immutability.unsafeGo
  , Immutability.safeGoPrep
  , Immutability.safeGo
  , Immutability.safePythonPrep
  , Immutability.safePython
  , Immutability.unsafePythonFrozenMutation
  , Immutability.unsafePythonConstantMutation
  , Immutability.safeTypeScript
  , Immutability.safeKotlin
  , Immutability.safeSwift
  , TypeSystemProperties.languageReport 7

  -- Conclusion
  , SectionCover.conclusion
  , TypeSystemProperties.errorPreventionReport "Go"
  , TypeSystemProperties.errorPreventionReport "Python"
  , TypeSystemProperties.errorPreventionReport "TypeScript"
  , TypeSystemProperties.errorPreventionReport "Kotlin"
  , TypeSystemProperties.errorPreventionReport "Swift"
  , Conclusion.introduction
  , Conclusion.enableStricterTypeChecking
  , Conclusion.codeGeneration
  , Conclusion.preCompileChecks
  , Conclusion.testing

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
