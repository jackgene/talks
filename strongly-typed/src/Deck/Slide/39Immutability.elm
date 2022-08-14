module Deck.Slide.Immutability exposing
  ( introduction
  , unsafeGoPrep, unsafeGo, safeGoPrep, safeGo
  , safePythonPrep, safePython, unsafePythonFrozenMutation, unsafePythonConstantMutation
  , safeTypeScript
  , safeKotlin
  , safeSwift
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, div, p, text)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Immutability"

subheadingGo : String
subheadingGo = "Go Can Enforce Immutability Through Encapsulation"

subheadingPython : String
subheadingPython = "Python Has Partial Support for Immutability"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Have Immutability"

subheadingKotlin : String
subheadingKotlin = "Kotlin Can Have Immutability"

subheadingSwift : String
subheadingSwift = "Swift Can Have Immutability"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Accidental Changes to Invariant Data, Race Conditions"
      ( div []
        [ p []
          [ text "Mutability is the source of many bugs, especially when combined with parallelism." ]
        , p []
          [ text "Languages that enforce immutability require the programmer to indicate if data is mutable or immutable. They then "
          , mark [] [ text "forbid changes to immutable data" ]
          , text "."
          ]
        ]
      )
    )
  }


unsafeGoPrep : UnindexedSlideModel
unsafeGoPrep =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package circle
import "math"

type Circle struct {
    Radius float64
}
func (c *Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Consider this implementation of a circle:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeGo : UnindexedSlideModel
unsafeGo =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package main
import "strongly-typed-go/immutability/circle"

func main() {
    unitCircle := circle.Circle{Radius: 1.0}
    println("r:", unitCircle.Radius, "a:", unitCircle.Area())
    unitCircle.Radius = 2.0
    println("r:", unitCircle.Radius, "a:", unitCircle.Area())
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Go really does not have language support for immutability:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeGoPrep : UnindexedSlideModel
safeGoPrep =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package circle
import "math"

type Circle struct {
    r float64
}
func (c *Circle) Radius() float64 { return c.r }
func (c *Circle) Area() float64 { return math.Pi * c.r * c.r }
// Constructor function
func New(radius float64) *Circle { return &Circle{r: radius} }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Immutability can be achieved by keeping mutable state private, and only exporting accessor methods to them:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeGo : UnindexedSlideModel
safeGo =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty
      ( Dict.fromList
        [ (6, [ ColumnEmphasis Error 15 1 ] )
        , (7, [ ColumnEmphasis Error 12 1 ] )
        ]
      )
      [ CodeBlockError 6 18
        [ div []
          [ text "unitCircle.r undefined (cannot refer to unexported field or method r)"
          ]
        ]
      , CodeBlockError 7 12
        [ div []
          [ text "cannot assign to math.Pi (declared const)"
          ]
        ]
      ]
      """
package main
import "math"
import "strongly-typed-go/immutability/circle"

func main() {
    unitCircle := circle.New(1.0)
    unitCircle.r = 2.0
    math.Pi = 0.0
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Updating "
          , syntaxHighlightedCodeSnippet Go "const"
          , text "s or unexported members is forbidden:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safePythonPrep : UnindexedSlideModel
safePythonPrep =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
import math
from dataclasses import dataclass
from functools import cached_property

@dataclass(frozen=True)
class Circle:
    radius: float

    @cached_property
    def area(self):
        return math.pi * self.radius ** 2
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Making something “frozen” in Python makes it mostly immutable:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safePython : UnindexedSlideModel
safePython =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 12 6 ] ) ] )
      [ CodeBlockError 4 11
        [ div []
          [ text """Cannot assign member "radius" for type "Circle": "Circle" is frozen"""
          ]
        ]
      ]
      """
from circle import Circle

unit_circle = Circle(1.0)
print("r:", unit_circle.radius, ", a:", unit_circle.area)
unit_circle.radius = 2.0

print("r:", unit_circle.radius, ", a:", unit_circle.area)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Python does not let you mutate a frozen object:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafePythonFrozenMutation : UnindexedSlideModel
unsafePythonFrozenMutation =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList [ (4, Deletion), (5, Addition) ] )
      Dict.empty []
      """
from circle import Circle

unit_circle = Circle(1.0)
print("r:", unit_circle.radius, ", a:", unit_circle.area)
unit_circle.radius = 2.0
object.__setattr__(unit_circle, "radius", 2.0)
print("r:", unit_circle.radius, ", a:", unit_circle.area)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Unless you really want to:" ]
        , div [] [ codeBlock ]
        , console
          """
% python immutability/unsafe_frozen.py
r: 1.0 , a: 3.141592653589793
r: 2.0 , a: 3.141592653589793
"""
        ]
      )
    )
  }


unsafePythonConstantMutation : UnindexedSlideModel
unsafePythonConstantMutation =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
from circle import Circle
import math

circle = Circle(123)
math.pi = 0.0
print("r:", circle.radius, ", a:", circle.area)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "You can even define your own "
          , syntaxHighlightedCodeSnippet Python "math.pi"
          , text ":"
          ]
        , div [] [] -- no animation
        , div [] [ codeBlock ]
        , console
          """
% python immutability/unsafe_constant.py
r: 123 , a: 0.0
"""
        ]
      )
    )
  }


safeTypeScript : UnindexedSlideModel
safeTypeScript =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty
      ( Dict.fromList
        [ (7, [ ColumnEmphasis Error 11 6 ] )
        , (8, [ ColumnEmphasis Error 5 2 ] )
        ]
      )
      [ CodeBlockError 7 15
        [ div []
          [ text "TS2540: Cannot assign to 'radius' because it is a read-only property."
          ]
        ]
      , CodeBlockError 8 5
        [ div []
          [ text "TS2540: Cannot assign to 'PI' because it is a read-only property."
          ]
        ]
      ]
      """
class Circle {
  readonly radius: number;
  constructor(radius: number) { this.radius = radius; }
  public get area() { return Math.PI * Math.pow(this.radius, 2); }
}

let unitCircle = new Circle(1.0);
unitCircle.radius = 2.0;
Math.PI = 0.0;
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Declare a field as "
          , syntaxHighlightedCodeSnippet TypeScript "readonly"
          , text " and the TypeScript compiler guarantees that it is:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeKotlin : UnindexedSlideModel
safeKotlin =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin Dict.empty
      ( Dict.fromList
        [ (7, [ ColumnEmphasis Error 11 6 ] )
        , (8, [ ColumnEmphasis Error 0 2 ] )
        ]
      )
      [ CodeBlockError 7 11
        [ div []
          [ text "val cannot be reassigned"
          ]
        ]
      , CodeBlockError 8 0
        [ div []
          [ text "val cannot be reassigned"
          ]
        ]
      ]
      """
import kotlin.math.PI

data class Circle(val radius: Double) {
    val area: Double by lazy { PI * radius * radius }
}

val unitCircle = Circle(radius = 1.0)
unitCircle.radius = 2.0
PI = 0.0
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Kotlin encourages immutability. Values, declared using "
          , syntaxHighlightedCodeSnippet Kotlin "val"
          , text " are immutable:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwift : UnindexedSlideModel
safeSwift =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift Dict.empty
      ( Dict.fromList
        [ (6, [ ColumnEmphasis Error 11 6 ] )
        , (7, [ ColumnEmphasis Error 7 2 ] )
        ]
      )
      [ CodeBlockError 6 16
        [ div []
          [ text "cannot assign to property: 'radius' is a 'let' constant"
          ]
        ]
      , CodeBlockError 7 6
        [ div []
          [ text "cannot assign to property: 'pi' is a get-only property"
          ]
        ]
      ]
      """
struct Circle {
    let radius: Double
    private(set) lazy var area: Double = Double.pi * radius * radius
}

let unitCircle = Circle(radius: 1.0)
unitCircle.radius = 2.0
Double.pi = 0.0
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift "
          , syntaxHighlightedCodeSnippet Swift "let"
          , text "s are immutable encouraging immutability, however "
          , syntaxHighlightedCodeSnippet Swift "var"
          , text "s are inevitable:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }
