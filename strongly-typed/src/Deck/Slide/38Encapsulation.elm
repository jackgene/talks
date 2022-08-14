module Deck.Slide.Encapsulation exposing
  ( introduction
  , safeGoPrep, safeGo
  , safePython
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
heading = TypeSystemProperties.heading ++ ": Encapsulation"

subheadingGo : String
subheadingGo = "Go Can Enforce Encapsulation"

subheadingPython : String
subheadingPython = "Python Can Enforce Encapsulation"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Enforce Encapsulation"

subheadingKotlin : String
subheadingKotlin = "Kotlin Can Enforce Encapsulation"

subheadingSwift : String
subheadingSwift = "Swift Can Enforce Encapsulation"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Accidental State Transitions"
      ( div []
        [ p []
          [ text "Program state is rarely relevant globally to a program - they often pertain to a more limited scope." ]
        , p []
          [ text "Languages that enforce encapsulation allow the programmer to "
          , text "declare data within a specific scope, and "
          , mark [] [ text "limit access to that data only within the declared scope" ]
          , text "."
          ]
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
package counter

type Counter struct {
    count int
}

func (c *Counter) Count() int { return c.count }
func (c *Counter) Increment() { c.count ++ }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Consider the following counter implementation:" ]
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
        [ (5, [ ColumnEmphasis Error 6 5 ] )
        ]
      )
      [ CodeBlockError 5 6
        [ div []
          [ text "c.count undefined (cannot refer to unexported field or method count)"
          ]
        ]
      ]
      """
package main
import "strongly-typed-go/encapsulation/counter"

func main() {
    c := &counter.Counter{}
    c.count = -1

    print("Count: ", c.Count())
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Go does not allow access to the private "
          , syntaxHighlightedCodeSnippet Go "count"
          , text " field:"
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
      ( Dict.fromList
        [ (8, [ ColumnEmphasis Error 2 6 ] )
        ]
      )
      [ CodeBlockError 8 2
        [ div []
          [ text """"_count" is protected and used outside of the class in which it is declared"""
          ]
        ]
      ]
      """
class Counter:
    def __init__(self) -> None:
        self._count = 0
    def count(self) -> int:
        return self._count
    def increment(self) -> None:
        self._count += 1
c = Counter()
c._count = -1

print("Count", c.count())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "The Python type checker prevents external access to private members:" ]
        , div [] [ codeBlock ]
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
        [ (7, [ ColumnEmphasis Error 2 6 ] )
        ]
      )
      [ CodeBlockError 7 2
        [ div []
          [ text "TS18013: Property '#count' is not accessible outside class 'Counter' because it has a private identifier."
          ]
        ]
      ]
      """
class Counter {
  #count: number = 0;
  public get count(): number { return this.#count; }
  public increment() { this.#count ++; }
}

let c = new Counter();
c.#count = -1

console.log("Count:", c.count)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "TypeScript prevents external access to private members:" ]
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
        [ (7, [ ColumnEmphasis Error 2 5 ] )
        ]
      )
      [ CodeBlockError 7 2
        [ div []
          [ text "cannot assign to 'count': the setter is private in 'Counter'"
          ]
        ]
      ]
      """
class Counter {
    var count: Int = 0
        private set
    fun increment() { count ++ }
}

val c = Counter()
c.count = -1

println("Count: " + c.count)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Kotlin prevents external access to private members:" ]
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
        [ (7, [ ColumnEmphasis Error 2 5 ] )
        ]
      )
      [ CodeBlockError 7 2
        [ div []
          [ text "cannot assign to property: 'count' setter is inaccessible"
          ]
        ]
      ]
      """
public struct Counter {
    private(set) var count: Int = 0

    public mutating func increment() { count += 1 }
}

var c = Counter()
c.count = -1

print("Count:", c.count)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift prevents external access to private members::" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }
