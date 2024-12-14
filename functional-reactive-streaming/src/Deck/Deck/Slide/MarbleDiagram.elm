module Deck.Slide.MarbleDiagram exposing
  ( HorizontalPosition, Shape(..), Element
  , OperandValue(..), Operand, Operation
  , diagramView, slideOutCodeBlock
  , operationView, streamLineView, partitionColor
  )

import Css exposing
  ( Color, Style
  -- Container
  , borderRadius, borderTop3, bottom, boxShadow5, displayFlex, height, left
  , margin, overflow, padding2, position, top, width
  -- Content
  , backgroundColor, backgroundImage, fontFamilies, fontSize, opacity
  -- Units
  , em, num, pct, px, vw, zero
  -- Color
  , rgb, rgba
  -- Alignment & Positions
  , absolute, relative
  -- Other values
  , auto, hidden, linearGradient, solid, stop
  )
import Css.Transitions exposing (easeInOut, linear, transition)
import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing
  ( Language(Python), syntaxHighlightedCodeBlock )
import Dict
import Html.Styled exposing (Html, br, div, text)
import Html.Styled.Attributes exposing (css)


type alias HorizontalPosition =
  { leftEm : Float
  , widthEm : Float
  }


type Shape
  = Disc
  | Square


type alias Element =
  { value : Int
  , shape : Shape
  , partition : Int
  , time : Float
  }


type OperandValue
  = Stream
    { terminal : Bool
    , elements : List Element
    }
  | Single Element


type alias Operand =
  { horizontalPosition : HorizontalPosition
  , value : OperandValue
  }


type alias Operation =
  { horizontalPosition : HorizontalPosition
  , operatorCode : List String
  }


-- From https://www.pastelcolorpalettes.com/primary-colors-in-pastels
partition0Color : Color
partition0Color = rgb 163 188 232


partition3Color : Color
partition3Color = rgb 250 248 132


partition4Color : Color
partition4Color = rgb 240 154 160


partition1Color : Color
partition1Color = rgb 182 232 142


partition2Color : Color
partition2Color = rgb 235 174 131


streamLineView : HorizontalPosition -> Float -> Html msg
streamLineView pos heightEm =
  div
  [ css
    [ position absolute
    , left (em (pos.leftEm + pos.widthEm / 2 + 0.1))
    , width (px 1), height (em heightEm)
    , backgroundImage (linearGradient (stop darkGray) (stop lightGray) [])
    ]
  ]
  []


operationView : HorizontalPosition -> Bool -> List String -> Html msg
operationView pos scaleChanged codeLines =
  div
  [ css
    [ position absolute, left (em pos.leftEm)
    , width (em pos.widthEm), padding2 (em 0.75) (em 0.5)
    , transition
      ( if scaleChanged then []
        else [ Css.Transitions.left3 transitionDurationMs 0 easeInOut ]
      )
    ]
  ]
  [ div [ css [ fontFamilies [ "Fira Code" ], fontSize (em 0.75) ] ]
    ( codeLines |> List.map text |> List.intersperse (br [] []) )
  ]


elementView : Shape -> Color -> Int -> Html msg
elementView shape color value =
  div
  [ css
    [ displayFlex, width (vw 5), height (vw 5), margin (vw 1)
    , backgroundColor color
    , borderRadius
      ( case shape of
          Disc -> pct 50
          Square -> pct 0
      )
    , boxShadow5 zero (em 0.25) (em 0.25) (em -0.125) (rgba 0 0 0 0.25)
    ]
  ]
  [ div
    [ css
      [ margin auto
      , fontSize
        ( if value < 1000 then (em 1)
          else if value < 10000 then (em 0.8)
          else (em 0.7)
        )
      ]
    ]
    [ text (toString value) ]
  ]


partitionColor : Int -> Color
partitionColor partition =
  ( case partition of
      0 -> partition0Color
      1 -> partition1Color
      2 -> partition2Color
      _ -> darkGray
  )


operandView : Operand -> Float -> Bool -> Html msg
operandView operand lastElementTime animate =
  div
  [ css
    [ position absolute
    , left (em operand.horizontalPosition.leftEm)
    , bottom
      ( em
        ( let
            shiftedTime : Float
            shiftedTime =
              if not animate then 7200
              else 4900 - lastElementTime

            bottomEm : Float
            bottomEm = 2 + 4 * shiftedTime / 2000
          in bottomEm
        )
      )
    , height (em (4 * lastElementTime / 2000 + 3)), width (em 3.125)
    , ( case operand.value of
          Stream { terminal } ->
            if not terminal then Css.batch []
            else borderTop3 (px 1) solid darkGray
          _ -> Css.batch []
      )
    , ( if not animate then Css.batch []
        else
          transition
          [ Css.Transitions.bottom3 lastElementTime 0 linear ]
      )
    ]
  ]
  ( case operand.value of
      Stream { terminal, elements } ->
        ( elements |> List.map
          ( \element ->
            div
            [ css
              [ position absolute
              , bottom (em (4 * element.time / 2000))
              ]
            ]
            [ elementView element.shape (partitionColor element.partition) element.value ]
          )
        )

      Single element ->
        [ div
            [ css [ position absolute, top (em -1.5) ]
            ]
          [ elementView element.shape (partitionColor element.partition) element.value ]
        ]
  )


diagramView : Operand -> Operation -> Operand -> Bool -> Html msg
diagramView input operation output animate =
  let
    lastElementInputTime : Float
    lastElementInputTime =
      Maybe.withDefault 0
      ( case input.value of
          Stream { elements } ->
            elements |> List.map .time |> List.maximum
          _ -> Nothing
      )

    lastElementOutputTime : Float
    lastElementOutputTime =
      Maybe.withDefault 0
      ( case output.value of
          Stream { elements } ->
            elements |> List.map .time |> List.maximum
          _ -> Nothing
      )

    lastElementTime : Float
    lastElementTime =
      max lastElementInputTime lastElementOutputTime
  in
  div -- diagram frame
  [ css
    [ position absolute, width (vw 40), height (vw 36)
    , overflow hidden
    ]
  ]
  [ div -- static background
    [ css [ position absolute, top zero ] ]
    ( ( case input.value of
        Stream _ -> [ streamLineView input.horizontalPosition 18 ]
        Single _ -> []
      )
    ++[ operationView operation.horizontalPosition True operation.operatorCode ]
    ++( case output.value of
        Stream _ -> [ streamLineView output.horizontalPosition 18 ]
        Single _ -> []
      )
    )
  -- animated foreground
  , operandView input lastElementTime animate
  , operandView output lastElementTime animate
  ]


slideOutCodeBlock : String -> Bool -> Html msg
slideOutCodeBlock code show =
  div
  [ css
    ( [ position relative
      , transition
        [ Css.Transitions.opacity3 transitionDurationMs 0 easeInOut
        , Css.Transitions.top3 transitionDurationMs 0 easeInOut
        ]
      ]
    ++( if show then [ top (vw -31), opacity (num 0.9375) ]
        else [ top zero, opacity zero ]
      )
    )
  ]
  [ syntaxHighlightedCodeBlock Python Dict.empty Dict.empty [] code ]
