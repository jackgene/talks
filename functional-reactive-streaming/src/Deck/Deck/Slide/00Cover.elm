module Deck.Slide.Cover exposing (cover)

import Css exposing
  -- Container
  ( bottom, left, position, right, top, width, margin, margin2
  -- Content
  , fontSize
  -- Units
  , em, vw, zero
  -- Alignments & Positions
  , absolute
  -- Other values
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (coverBackgroundGraphic, wordSubmitterAppQrCode)
import Html.Styled exposing (Html, br, div, h1, p, text)
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
          , bottom zero, right (vw 1), width (vw 49)
          , fontSize (em 0.8)
          ]
        ]
        [ div [ css [ position absolute, bottom (em 1.75), left zero] ] [ text "http://wordcloud.jackleow.com" ]
        , div [ css [ position absolute, bottom zero, right zero] ] [ wordSubmitterAppQrCode "25vw" ]
        ]
      , div
        [ css
          [ position absolute
          , top (vw 17), left (vw 35), width (vw 58)
          ]
        ]
        [ h1 [ css [ margin zero, headerFontFamily, fontSize (vw 4.5) ] ]
          [ text "Functional Reactive"
          , br [] []
          , text "Streaming with RxPY"
          ]
        , p
          [ css [ margin2 (em 5) zero, fontSize (em 0.875) ] ]
          [ text "Jack Leow"
          , br [] []
          , text "November 1, 2024"
          ]
        ]
      ]
    )
  }
