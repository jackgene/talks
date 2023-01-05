module Deck.Slide.Cover exposing (cover)

import Css exposing
  -- Container
  ( left, position, top, width, margin, margin2
  -- Content
  , color, fontSize
  -- Units
  , em, vw, zero
  -- Alignments & Positions
  , absolute
  -- Other values
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (coverBackgroundGraphic)
import Html.Styled exposing (Html, br, div, h1, p, span, text)
import Html.Styled.Attributes exposing (css)


cover : UnindexedSlideModel
cover =
  { baseSlideModel
  | view =
    ( \_ _ ->
      div [ css [ coverStyle ] ]
      [ coverBackgroundGraphic
      , div
        [ css
          [ position absolute
          , top (vw 18), left (vw 35), width (vw 58)
          , color primaryForeground
          ]
        ]
        [ h1 [ css [ margin zero, headerFontFamily, fontSize (vw 4.2) ] ]
          [ text "Strong Typing and the Errors It Prevents"
          ]
        , p
          [ css [ margin2 (em 2.8) zero, fontSize (vw 2.5) ] ]
          [ text "Jack Leow"
          , br [] []
          , span [ css [ fontSize (vw 2.0) ] ] [ text "January 4, 2023" ]
          ]
        ]
      ]
    )
  }