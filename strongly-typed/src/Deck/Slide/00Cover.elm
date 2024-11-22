module Deck.Slide.Cover exposing (cover)

import Css exposing
  -- Container
  ( left, position, top, width, margin, margin2
  -- Content
  , backgroundColor, color, fontSize, fontWeight
  -- Units
  , em, int, vw, zero
  -- Alignments & Positions
  , absolute
  -- Other values
  , normal
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (coverBackgroundGraphic)
import Html.Styled exposing (Html, br, div, h1, h2, p, text)
import Html.Styled.Attributes exposing (css)


cover : UnindexedSlideModel
cover =
  { baseSlideModel
  | view =
    ( \_ _ ->
      div [ css [ color white, backgroundColor primary ] ]
      [ coverBackgroundGraphic
      , div
        [ css
          [ position absolute
          , top (vw 20), left (vw 35), width (vw 58)
          ]
        ]
        [ h1 [ css [ margin zero, headerFontFamily, fontSize (vw 4.2) ] ]
          [ text "Strong Typing and the Errors It Prevents"
          ]
        , p
          [ css [ margin2 (em 2.5) zero, fontSize (vw 2.5) ] ]
          [ text "Jack Leow" ]
        ]
      ]
    )
  }
