module Deck.Slide.MemorySafety exposing (slide)

import Deck.Slide.Common exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Html.Styled exposing (Html, div, p, text)


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Memory Safety"


-- Slides
slide : UnindexedSlideModel
slide =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Buffer Overflows"
      ( div []
        [ p []
          [ text "Virtually all modern languages have bound-checked arrays, "
          , text "which prevents arbitrary memory writes, and hence buffer overflows. "
          , text "This applies to the languages we are evaluating, and they all get a 1.0 upper-bound score."
          ]
        , p []
          [ text "Go and Swift, however, provide facilities for unsafe memory access, circumventing these checks. "
          , text "Given these facilities are hard to reach, we give Go and Swift a 0.5 lower-bound score."
          ]
        , p []
          [ text "In Python, TypeScript, and Kotlin, memory-safety cannot be circumvented. "
          , text "They each get a lower-bound score of 1.0."
          ]
        ]
      )
    )
  }
