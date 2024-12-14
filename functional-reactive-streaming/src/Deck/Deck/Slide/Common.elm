module Deck.Slide.Common exposing (..)

import Css exposing
  ( Color, Style, property
  -- Container
  , display, float, height, left, margin2
  , marginRight, padding, width
  -- Content
  , backgroundColor, before, color
  , fontFamilies, fontSize, fontStyle, fontWeight
  -- Units
  , em, int, vw, zero
  -- Color
  , rgb, rgba
  -- Alignments & Positions
  -- Other values
  , block, italic
  )
import Deck.Common exposing (Model, Msg)
import Html.Styled as Html exposing (Attribute, Html, text)
import Html.Styled.Attributes exposing (css)


-- Model
type alias UnindexedSlideModel =
  { active : Model -> Bool
  , update : Msg -> Model -> (Model, Cmd Msg)
  , view : Int -> Model -> Html Msg
  , eventsWsPath : Maybe String
  , animationFrames : Model -> Int
  }


-- Constants
transitionDurationMs : Float
transitionDurationMs = 500


baseSlideModel : UnindexedSlideModel
baseSlideModel =
  { active = always True
  , update = ( \_ model -> (model, Cmd.none) )
  , view = ( \_ _ -> text "(Placeholder)" )
  , eventsWsPath = Nothing
  , animationFrames = always 0
  }


-- Styles
white : Color
white = rgb 255 255 255


black : Color
black = rgb 0 0 0


themeForegroundColor : Color
themeForegroundColor = rgb 0x30 0x69 0x98


themeBackgroundColor : Color
themeBackgroundColor = rgb 0x4B 0x8B 0xBE


darkGray : Color
darkGray = rgb 192 192 192


lightGray : Color
lightGray = rgb 238 238 238


consoleText : Color
consoleText = rgb 65 255 0


headerFontFamily : Style
headerFontFamily = fontFamilies [ "Montserrat" ]


numberFontFamily : Style
numberFontFamily = fontFamilies [ "Open Sans" ]


paragraphFontFamily : Style
paragraphFontFamily = fontFamilies [ "Open Sans" ]


codeFontFamily : Style
codeFontFamily = Css.batch [ fontFamilies [ "Fira Code" ], fontWeight (int 500) ]


coverStyle : Style
coverStyle =
  Css.batch [ backgroundColor themeBackgroundColor ]


headerStyle : Style
headerStyle =
  Css.batch
  [ headerFontFamily, fontSize (vw 3.2)
  , before
    [ property "content" "''"
    , display block, float left
    , width (em 0.2), height (em 1.2)
    , marginRight (em 1.875)
    , backgroundColor themeForegroundColor
    ]
  ]


subHeaderStyle : Style
subHeaderStyle =
  Css.batch [ headerFontFamily, fontSize (vw 2.7) ]


contentContainerStyle : Style
contentContainerStyle =
  margin2 zero (vw 7)


-- View
blockquote : List (Attribute msg) -> List (Html msg) -> Html msg
blockquote attributes = Html.blockquote (css [ fontStyle italic ] :: attributes)


mark : List (Attribute msg) -> List (Html msg) -> Html msg
mark attributes = Html.mark attributes


li : List (Attribute msg) -> List (Html msg) -> Html msg
li attributes =
  Html.li
  ( css [ margin2 (em 0.5) zero ]
  ::attributes
  )


console : String -> Html msg
console output =
  Html.pre
  [ css
    [ padding (em 0.25)
    , color consoleText, backgroundColor black
    , fontFamilies [ "Glass TTY VT220" ]
    ]
  ]
  [ text (String.trimLeft output) ]
