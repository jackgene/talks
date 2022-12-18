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
import Deck.Slide.Common exposing
  ( UnindexedSlideModel, black, languages, paragraphFontFamily, white )
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
import Set


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


unindexedSlideModelForLang : String -> UnindexedSlideModel -> Maybe UnindexedSlideModel
unindexedSlideModelForLang language unindexedSlideModel =
  if not (Set.member language languages) then Nothing
  else Just unindexedSlideModel


errorPreventionReport : String -> Maybe UnindexedSlideModel
errorPreventionReport language =
  unindexedSlideModelForLang language
  ( TypeSystemProperties.errorPreventionReport language )


unindexedSlideModels : List UnindexedSlideModel
unindexedSlideModels =
  ( [ Cover.cover
    , AudiencePoll.poll, AudiencePoll.jsVsTs

    -- Introduction
    , SectionCover.introduction
    , Introduction.wikipediaDefinitions
    --, Introduction.typefulDefinitions
    , Introduction.ourDefinition
    , Introduction.outOfScope
    , Introduction.inScope
    ]

    -- Type System Properties
  ++( List.filterMap identity
      [ Just SectionCover.typeSystemProperties
      , Just (TypeSystemProperties.tableOfContent Nothing)
      , Just TypeSystemProperties.methodology

      , Just (TypeSystemProperties.tableOfContent (Just 0))
      , Just TypeSafety.introduction
      , unindexedSlideModelForLang "Go" TypeSafety.safeGo
      , unindexedSlideModelForLang "Go" TypeSafety.invalidSafeGo 
      , unindexedSlideModelForLang "Go" TypeSafety.invalidUnsafeGo 
      , unindexedSlideModelForLang "Go" TypeSafety.unsafeGo 
      , unindexedSlideModelForLang "Python" TypeSafety.safePython 
      , unindexedSlideModelForLang "Python" TypeSafety.invalidSafePython 
      , unindexedSlideModelForLang "Python" TypeSafety.unsafePythonUnannotated 
      , unindexedSlideModelForLang "Python" TypeSafety.unsafePythonRun 
      , unindexedSlideModelForLang "Python" TypeSafety.pythonTypeHintUnannotated
      , unindexedSlideModelForLang "Python" TypeSafety.pythonTypeHintWrong
      , unindexedSlideModelForLang "Python" TypeSafety.pythonTypeHintWrongRun
      , unindexedSlideModelForLang "TypeScript" TypeSafety.safeTypeScript 
      , unindexedSlideModelForLang "TypeScript" TypeSafety.invalidSafeTypeScript 
      , unindexedSlideModelForLang "TypeScript" TypeSafety.unsafeTypeScriptAny 
      , unindexedSlideModelForLang "TypeScript" TypeSafety.unsafeTypeScriptUnannotated 
      , unindexedSlideModelForLang "TypeScript" TypeSafety.unsafeTypeScriptFuncParam 
      , unindexedSlideModelForLang "Scala" TypeSafety.safeScala 
      , unindexedSlideModelForLang "Scala" TypeSafety.invalidSafeScala 
      , unindexedSlideModelForLang "Scala" TypeSafety.invalidUnsafeScala 
      , unindexedSlideModelForLang "Scala" TypeSafety.unsafeScala 
      , unindexedSlideModelForLang "Kotlin" TypeSafety.safeKotlin 
      , unindexedSlideModelForLang "Kotlin" TypeSafety.invalidSafeKotlin 
      , unindexedSlideModelForLang "Kotlin" TypeSafety.invalidUnsafeKotlin 
      , unindexedSlideModelForLang "Kotlin" TypeSafety.unsafeKotlin 
      , unindexedSlideModelForLang "Swift" TypeSafety.safeSwift 
      , unindexedSlideModelForLang "Swift" TypeSafety.invalidSafeSwift 
      , unindexedSlideModelForLang "Swift" TypeSafety.invalidUnsafeSwift 
      , unindexedSlideModelForLang "Swift" TypeSafety.unsafeSwift 
      , Just (TypeSystemProperties.languageReport 0)

      , Just (TypeSystemProperties.tableOfContent (Just 1))
      , Just NullSafety.introduction
      , unindexedSlideModelForLang "Go" NullSafety.unsafeGo 
      , unindexedSlideModelForLang "Go" NullSafety.unsafeGoRun 
      , unindexedSlideModelForLang "Python" NullSafety.safePythonNonNull 
      , unindexedSlideModelForLang "Python" NullSafety.safePythonNonNullInvalid 
      , unindexedSlideModelForLang "Python" NullSafety.safePythonNullableInvalid 
      , unindexedSlideModelForLang "Python" NullSafety.safePythonNullable 
      , unindexedSlideModelForLang "TypeScript" NullSafety.safeTypeScriptNonNull 
      , unindexedSlideModelForLang "TypeScript" NullSafety.safeTypeScriptNonNullInvalid 
      , unindexedSlideModelForLang "TypeScript" NullSafety.safeTypeScriptNullableInvalid 
      , unindexedSlideModelForLang "TypeScript" NullSafety.safeTypeScriptNullable 
      , unindexedSlideModelForLang "Scala" NullSafety.safeScalaNullableInvalid 
      , unindexedSlideModelForLang "Scala" NullSafety.safeScalaNullable 
      , unindexedSlideModelForLang "Scala" NullSafety.safeScalaNullableFun 
      , unindexedSlideModelForLang "Scala" NullSafety.safeScalaNullableFor 
      , unindexedSlideModelForLang "Scala" NullSafety.unsafeScala 
      , unindexedSlideModelForLang "Kotlin" NullSafety.safeKotlinNullable 
      , unindexedSlideModelForLang "Kotlin" NullSafety.unsafeKotlin 
      , unindexedSlideModelForLang "Swift" NullSafety.safeSwiftNullable 
      , unindexedSlideModelForLang "Swift" NullSafety.safeSwiftNullableFun 
      , unindexedSlideModelForLang "Swift" NullSafety.unsafeSwift 
      , Just (TypeSystemProperties.languageReport 1)

      , Just (TypeSystemProperties.tableOfContent (Just 2))
      , Just SafeArrayAccess.introduction
      , unindexedSlideModelForLang "Go" SafeArrayAccess.unsafeGo 
      , unindexedSlideModelForLang "Go" SafeArrayAccess.unsafeGoRun 
      , unindexedSlideModelForLang "Python" SafeArrayAccess.unsafePython 
      , unindexedSlideModelForLang "Python" SafeArrayAccess.safePython 
      , unindexedSlideModelForLang "TypeScript" SafeArrayAccess.unsafeTypeScript 
      , unindexedSlideModelForLang "TypeScript" SafeArrayAccess.safeTypeScriptInvalid 
      , unindexedSlideModelForLang "TypeScript" SafeArrayAccess.safeTypeScript 
      , unindexedSlideModelForLang "Scala" SafeArrayAccess.unsafeScala 
      , unindexedSlideModelForLang "Scala" SafeArrayAccess.safeScala 
      , unindexedSlideModelForLang "Kotlin" SafeArrayAccess.unsafeKotlin 
      , unindexedSlideModelForLang "Kotlin" SafeArrayAccess.safeKotlin 
      , unindexedSlideModelForLang "Swift" SafeArrayAccess.unsafeSwift 
      , unindexedSlideModelForLang "Swift" SafeArrayAccess.safeSwift 
      , Just (TypeSystemProperties.languageReport 2)

      , Just (TypeSystemProperties.tableOfContent (Just 3))
      , Just SafeTypeConversion.introduction
      , unindexedSlideModelForLang "Go" SafeTypeConversion.safeGo 
      , unindexedSlideModelForLang "Go" SafeTypeConversion.introGo 
      , unindexedSlideModelForLang "Go" SafeTypeConversion.unsafeGo 
      , unindexedSlideModelForLang "Go" SafeTypeConversion.unsafeGoRun 
      , unindexedSlideModelForLang "Python" SafeTypeConversion.safePython 
      , unindexedSlideModelForLang "Python" SafeTypeConversion.unsafePythonGoodGuard
      , unindexedSlideModelForLang "Python" SafeTypeConversion.unsafePythonBadGuard 
      , unindexedSlideModelForLang "Python" SafeTypeConversion.unsafePythonBadGuardRun 
      , unindexedSlideModelForLang "Python" SafeTypeConversion.unsafePythonCast 
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.safeTypeScript 
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.unsafeTypeScriptGoodPredicateInvalid
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.unsafeTypeScriptGoodPredicate
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.unsafeTypeScriptBadPredicate 
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.unsafeTypeScriptBadPredicateRun 
      , unindexedSlideModelForLang "TypeScript" SafeTypeConversion.unsafeTypeScriptCast 
      , unindexedSlideModelForLang "Scala" SafeTypeConversion.safeScala 
      , unindexedSlideModelForLang "Scala" SafeTypeConversion.unsafeScala 
      , unindexedSlideModelForLang "Kotlin" SafeTypeConversion.safeKotlinSmart 
      , unindexedSlideModelForLang "Kotlin" SafeTypeConversion.safeKotlinExplicit 
      , unindexedSlideModelForLang "Kotlin" SafeTypeConversion.unsafeKotlin 
      , unindexedSlideModelForLang "Swift" SafeTypeConversion.safeSwift 
      , unindexedSlideModelForLang "Swift" SafeTypeConversion.unsafeSwift 
      , Just (TypeSystemProperties.languageReport 3)

      , Just (TypeSystemProperties.tableOfContent (Just 4))
      , Just ExceptionSafety.introduction
      , unindexedSlideModelForLang "Go" ExceptionSafety.introGo 
      , unindexedSlideModelForLang "Go" ExceptionSafety.unsafeGoExplicit 
      , unindexedSlideModelForLang "Go" ExceptionSafety.unsafeGoVariableReuse 
      , unindexedSlideModelForLang "Python" ExceptionSafety.unsafePython 
      , unindexedSlideModelForLang "Python" ExceptionSafety.unsafePythonRun 
      , unindexedSlideModelForLang "Python" ExceptionSafety.safePython 
      , unindexedSlideModelForLang "Python" ExceptionSafety.safePythonInvalid 
      , unindexedSlideModelForLang "TypeScript" ExceptionSafety.unsafeTypeScript 
      , unindexedSlideModelForLang "TypeScript" ExceptionSafety.safeTypeScript 
      , unindexedSlideModelForLang "TypeScript" ExceptionSafety.safeTypeScriptInvalid 
      , unindexedSlideModelForLang "Scala" ExceptionSafety.unsafeScala 
      , unindexedSlideModelForLang "Scala" ExceptionSafety.safeScala 
      , unindexedSlideModelForLang "Scala" ExceptionSafety.safeScalaInvalid 
      , unindexedSlideModelForLang "Kotlin" ExceptionSafety.unsafeKotlin 
      , unindexedSlideModelForLang "Kotlin" ExceptionSafety.safeKotlin 
      , unindexedSlideModelForLang "Kotlin" ExceptionSafety.safeKotlinInvalid 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.safeSwift 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.safeSwiftInvalid 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.safeSwiftInvocation 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.unsafeSwift 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.safeSwiftMonadic 
      , unindexedSlideModelForLang "Swift" ExceptionSafety.safeSwiftMonadicInvalid 
      , Just (TypeSystemProperties.languageReport 4)

      , Just (TypeSystemProperties.tableOfContent (Just 5))
      , Just ExhaustivenessChecking.introduction
      , unindexedSlideModelForLang "Go" ExhaustivenessChecking.unsafeGoPrep 
      , unindexedSlideModelForLang "Go" ExhaustivenessChecking.unsafeGo 
      , unindexedSlideModelForLang "Python" ExhaustivenessChecking.safePython 
      , unindexedSlideModelForLang "Python" ExhaustivenessChecking.safePythonInvalid 
      , unindexedSlideModelForLang "TypeScript" ExhaustivenessChecking.safeTypeScript 
      , unindexedSlideModelForLang "TypeScript" ExhaustivenessChecking.safeTypeScriptInvalid 
      , unindexedSlideModelForLang "Scala" ExhaustivenessChecking.safeScalaPrep 
      , unindexedSlideModelForLang "Scala" ExhaustivenessChecking.safeScala 
      , unindexedSlideModelForLang "Scala" ExhaustivenessChecking.safeScalaInvalid 
      , unindexedSlideModelForLang "Scala" ExhaustivenessChecking.safeScalaAlt 
      , unindexedSlideModelForLang "Kotlin" ExhaustivenessChecking.safeKotlin 
      , unindexedSlideModelForLang "Kotlin" ExhaustivenessChecking.safeKotlinInvalid 
      , unindexedSlideModelForLang "Swift" ExhaustivenessChecking.safeSwiftPrep 
      , unindexedSlideModelForLang "Swift" ExhaustivenessChecking.safeSwift 
      , unindexedSlideModelForLang "Swift" ExhaustivenessChecking.safeSwiftInvalid 
      , unindexedSlideModelForLang "Swift" ExhaustivenessChecking.safeSwiftAlt 
      , Just (TypeSystemProperties.languageReport 5)

      , Just (TypeSystemProperties.tableOfContent (Just 6))
      , Just Encapsulation.introduction
      , unindexedSlideModelForLang "Go" Encapsulation.safeGoPrep 
      , unindexedSlideModelForLang "Go" Encapsulation.safeGo 
      , unindexedSlideModelForLang "Python" Encapsulation.safePython 
      , unindexedSlideModelForLang "TypeScript" Encapsulation.safeTypeScript 
      , unindexedSlideModelForLang "Scala" Encapsulation.safeScala 
      , unindexedSlideModelForLang "Kotlin" Encapsulation.safeKotlin 
      , unindexedSlideModelForLang "Swift" Encapsulation.safeSwift 
      , Just (TypeSystemProperties.languageReport 6)

      , Just (TypeSystemProperties.tableOfContent (Just 7))
      , Just Immutability.introduction
      , unindexedSlideModelForLang "Go" Immutability.unsafeGoPrep 
      , unindexedSlideModelForLang "Go" Immutability.unsafeGo 
      , unindexedSlideModelForLang "Go" Immutability.safeGoPrep 
      , unindexedSlideModelForLang "Go" Immutability.safeGo 
      , unindexedSlideModelForLang "Python" Immutability.safePythonPrep 
      , unindexedSlideModelForLang "Python" Immutability.safePython 
      , unindexedSlideModelForLang "Python" Immutability.unsafePythonFrozenMutation 
      , unindexedSlideModelForLang "Python" Immutability.unsafePythonConstantMutation 
      , unindexedSlideModelForLang "TypeScript" Immutability.safeTypeScript 
      , unindexedSlideModelForLang "Scala" Immutability.safeScala 
      , unindexedSlideModelForLang "Kotlin" Immutability.safeKotlin 
      , unindexedSlideModelForLang "Swift" Immutability.safeSwift 
      , Just (TypeSystemProperties.languageReport 7)
      ]
    )

    -- Conclusion
  ++( List.filterMap identity
      [ Just SectionCover.conclusion
      , errorPreventionReport "Go"
      , errorPreventionReport "Python"
      , errorPreventionReport "TypeScript"
      , errorPreventionReport "Scala"
      , errorPreventionReport "Kotlin"
      , errorPreventionReport "Swift"
      , Just Conclusion.introduction
      , Just Conclusion.enableStricterTypeChecking
      , Just Conclusion.codeGeneration
      , Just Conclusion.preCompileChecks
      , Just Conclusion.testing
      ]
    )

    -- Q & A
  ++[ SectionCover.questions
    , QuestionAnswer.slide 0
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
  )


slidesList : List Slide
slidesList =
  List.indexedMap indexSlide unindexedSlideModels


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
firstQuestionIndex = List.length unindexedSlideModels


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
