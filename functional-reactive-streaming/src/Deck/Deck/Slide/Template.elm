module Deck.Slide.Template exposing (..)

import Css exposing
  -- Container
  ( borderTop3, bottom, display, height, left, margin, margin4
  , padding2, position, right, top, width
  -- Content
  , color, fontSize, fontWeight, verticalAlign
  -- Units
  , em, vw, zero
  -- Alignments & Positions
  , absolute
  -- Other values
  , inlineBlock, middle, normal, solid
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (coverBackgroundGraphic, numberedDisc)
import Html.Styled exposing (Html, div, footer, h1, h2, text)
import Svg.Styled.Attributes exposing (css)


sectionCoverSlideView : Int -> String -> Html msg
sectionCoverSlideView number title =
  div []
  [ coverBackgroundGraphic
  , h1
    [ css
      [ position absolute, margin zero
      , top (vw 5), left (vw 6)
      , color white, numberFontFamily, fontWeight normal, fontSize (vw 35)
      ]
    ]
    [ text (toString number) ]
  , h1
    [ css
      [ position absolute
      , top (vw 18), left (vw 35), width (vw 55)
      , headerFontFamily, fontSize (vw 6)
      ]
    ]
    [ text title ]
  ]


standardSlideView : Int -> String -> String -> Html msg -> Html msg
standardSlideView page heading subheading content =
  div []
  [ h1 [ css [ headerStyle ] ] [ text heading ]
  , div [ css [ contentContainerStyle ] ]
    [ h2 [ css [ subHeaderStyle ] ] [ text subheading ]
    , content
    , footer
      [ css
        [ position absolute
        , right (vw 4), bottom zero, left (vw 4), height (vw 3)
        , borderTop3 (vw 0.1) solid black
        , padding2 (vw 1) zero
        , paragraphFontFamily, fontSize (vw 1.3), color darkGray
        ]
      ]
      [ div [ css [ display inlineBlock, position absolute, right zero ] ]
        [ text "Functional Reactive Streaming with RxPY"
        , numberedDisc (toString page) 50
          [ css [ width (vw 2.5), margin4 zero zero (em 0.1) (em 0.4), verticalAlign middle ] ]
        ]
      ]
    ]
  ]
