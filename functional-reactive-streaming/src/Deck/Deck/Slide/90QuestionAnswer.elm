module Deck.Slide.QuestionAnswer exposing (slide)

import Array
import Css exposing
  ( property
  -- Container
  , border, height, margin, width, outline, position
  -- Content
  , fontSize, fontWeight, textAlign
  -- Units
  , auto, int, vw, zero
  -- Alignments & Positions
  , absolute, center
  -- Other values
  , none
  )
import Deck.Common exposing (typingSpeedMultiplier)
import Deck.Slide.Common exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Html.Styled exposing (Html, div, input, text)
import Html.Styled.Attributes exposing (autofocus, css, type_)


slide : Int -> UnindexedSlideModel
slide index =
  { baseSlideModel
  | active = (\{questions} -> index <= Array.length questions)
  , animationFrames =
    ( \{questions} ->
      ( Maybe.withDefault 0
        ( Maybe.map
          ( \question -> String.length question * typingSpeedMultiplier )
          ( Array.get index questions )
        )
      )
    )
  , view =
    ( \page model -> standardSlideView page
      "Audience Questions"
      ( "Question #" ++ (toString (index + 1)) )
      ( div
        [ css
         [ property "display" "grid", position absolute
         , width (vw 84), height (vw 20)
         ]
        ]
        [ div [ css [ margin auto, fontSize (vw 4), textAlign center ] ]
          [ case Array.get index model.questions of
            Just question ->
              text
              ( String.dropRight
                (model.animationFramesRemaining // typingSpeedMultiplier)
                question
              )
            Nothing ->
              input
              [ type_ "text", autofocus True
              , css
                [ width (vw 0.1), border zero, outline none
                , fontSize (vw 4), fontWeight (int 900)
                ]
              ]
              []
          ]
        ]
      )
    )
  , eventsWsPath = Just "question"
  }
