module Deck.Slide.Introduction exposing
  ( wikipediaDefinitions, typefulDefinitions, ourDefinition, inScope
  )

import Css exposing
  ( Style
  -- Container
  , displayFlex, flexDirection, flexWrap, float, height, width
  -- Units
  , pct, vw
  -- Other values
  , column, left, wrap
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Html.Styled exposing (Html, b, div, p, text, ul)
import Html.Styled.Attributes exposing (css)


-- Constants
heading : String
heading = "What is “Strong Typing”?"


-- Slides
wikipediaDefinitions : UnindexedSlideModel
wikipediaDefinitions =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "There Are No Formal Definitions of the Term"
      ( div []
        [ p []
          [ text "Looking up “Strongly Typed” in Wikipedia:"
          , blockquote []
            [ p []
              [ text "In computer programming, one of the many ways that programming languages are colloquially "
              , text " classified is whether the language's type system makes it strongly typed or weakly typed (loosely typed). ..."
              ]
            , p [] [ text "..." ]
            , p []
              [ text "Generally, a strongly typed language has stricter typing rules at compile time, "
              , mark [] [ text "which implies that errors and exceptions are more likely to happen during compilation" ]
              , text ". ..."
              ]
            ]
          ]
        ]
      )
    )
  }


typefulDefinitions : UnindexedSlideModel
typefulDefinitions =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "There Are No Formal Definitions of the Term"
      ( div []
        [ p []
          [ text "An example of a definition comes from Luca Cardelli's 1989 paper “Typeful Programming”:" ]
        , blockquote []
          [ text "… Hence, typeful programming advocates static typing, as much as possible, and dynamic typing when necessary; the strict observance of either or both of these techniques leads to "
          , mark [] [ text "strong typing, intended as the absence of unchecked run-time type errors" ]
          , text ". …"
          ]
        ]
      )
    )
  }


ourDefinition : UnindexedSlideModel
ourDefinition =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Definition for the Purpose of this Talk"
      ( div []
        [ p []
          [ text "The strength of a type system describes its "
          , mark [] [ text "ability to prevent runtime errors" ]
          , text "."
          ]
        , p []
          [ text "The stronger the type system, the more kinds of errors are detected during type checking, "
          , text "the fewer kinds of unchecked errors are possible during runtime."
          ]
        , p []
          [ text "Of note, "
          , mark [] [ text "“Strongly Typed” does not mean “Statically Typed.”" ]
          , text " Dynamically Typed languages can be Strongly Typed, "
          , text "conversely Statically Typed languages aren't necessarily Strongly Typed."
          ]
        ]
      )
    )
  }


inScope : UnindexedSlideModel
inScope =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Errors That A Strong Type System Can Prevent"
      ( let
          listStyle : Style
          listStyle = Css.batch [ width (pct 48), float left ]
        in
        div []
        [ p []
          [ text "The following are some classes of errors a type system can prevent:"
          , ul
            [ css [ displayFlex, flexDirection column, flexWrap wrap, height (vw 28) ] ]
            [ li [ css [ listStyle ] ] [ text "Memory Leak" ]
            , li [ css [ listStyle ] ] [ text "Buffer Overflow" ]
            , li [ css [ listStyle ] ] [ text "Type Mismatch" ]
            , li [ css [ listStyle ] ] [ text "Null Pointer Dereference" ]
            , li [ css [ listStyle ] ] [ text "Out Of Bounds Array Access" ]
            , li [ css [ listStyle ] ] [ text "Type Conversion Failure" ]
            , li [ css [ listStyle ] ] [ text "Unhandled Recoverable Error" ]
            , li [ css [ listStyle ] ] [ text "Inexhaustive Match" ]
            , li [ css [ listStyle ] ] [ text "State Data Corruption" ]
            , li [ css [ listStyle ] ] [ text "Data Race" ]
            ]
          ]
        ]
      )
    )
  }
