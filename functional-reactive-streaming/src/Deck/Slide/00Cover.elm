module Deck.Slide.Cover exposing (cover)

import Css exposing
  -- Container
  ( left, position, top, width, margin, margin2
  -- Content
  , fontSize
  -- Units
  , em, vw, zero
  -- Alignments & Positions
  , absolute
  -- Other values
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (coverBackgroundGraphic)
import Html.Styled exposing (Html, br, div, h1, p, text)
import Html.Styled.Attributes exposing (css)


cover : UnindexedSlideModel
cover =
  { baseSlideModel
  | view =
    ( \_ _ ->
      div []
      [ coverBackgroundGraphic
      , div
        [ css
          [ position absolute
          , top (vw 17), left (vw 35), width (vw 58)
          ]
        ]
        [ h1 [ css [ margin zero, headerFontFamily, fontSize (vw 4.5) ] ]
          [ text "Functional Reactive"
          , br [] []
          , text "Streaming"
          , br [] []
          , text "with Kotlin Flow"
          ]
        , p
          [ css [ margin2 (em 2.5) zero, fontSize (em 0.875) ] ]
          [ text "Jack Leow"
          , br [] []
          , text "November 1, 2023"]
        ]
      ]
    )
  }
