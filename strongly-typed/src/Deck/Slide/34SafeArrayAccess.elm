module Deck.Slide.SafeArrayAccess exposing
  ( introduction
  , unsafeGo, unsafeGoRun
  , unsafePython, safePython
  , unsafeTypeScript, safeTypeScriptInvalid, safeTypeScript
  , unsafeScala, safeScala
  , unsafeKotlin, safeKotlin
  , unsafeSwift, safeSwift
  , safeElm, unsafeElm
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, a, br, div, p, text)
import Html.Styled.Attributes exposing (href, target)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Safe Array Access"

subheadingGo : String
subheadingGo = "Go Does Not Have Safe Array Access"

subheadingPython : String
subheadingPython = "Python Does Not Have Safe Array Access (But Can Be Made Safer)"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Have Safe Array Access"

subheadingScala : String
subheadingScala = "Scala Has Safe Array Access (But With Options to Be Unsafe)"

subheadingKotlin : String
subheadingKotlin = "Kotlin Has Safe Array Access (But With Options to Be Unsafe)"

subheadingSwift : String
subheadingSwift = "Swift Does Not Have Safe Array Access (But Can Be Made Safer)"

subheadingElm : String
subheadingElm = "Elm Array Access Is Safe"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Errors Related to Accessing Out Of Bounds Array Elements"
      ( div []
        [ p []
          [ text "Virtually all languages since C/C++ prevent out of bounds array access." ]
        , p []
          [ text "Languages that have safe array access further "
          , mark [] [ text "require programmers to explicitly handle out of bounds array access" ]
          , text ", instead of just having the program crash at runtime."
          ]
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

func main() {
    words := []string{"one", "two", "three"}
    _ = words[10]  // panic!
}"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "The Go compiler allows:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeGoRun : UnindexedSlideModel
unsafeGoRun =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p [] [ text "But the program panics at runtime:" ]
        , console
          """
% safe_array_access/unsafe
panic: runtime error: index out of range [10] with length 3

goroutine 1 [running]:
main.main()
    /strongly-typed/safe_array_access/unsafe.go:5 +0x1d
"""
        ]
      )
    )
  }


unsafePython : UnindexedSlideModel
unsafePython =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
words: list[str] = ["one", "two", "three"]
word: str = words[10]
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "This program type checks:" ]
        , div [] [ codeBlock ]
        , p [] [ text "But crashes at runtime:" ]
        , console
          """
% python safe_array_access/unsafe.py
Traceback (most recent call last):
  File "/strongly-typed/safe_array_access/unsafe.py", line 2, in <module>
    word: str = words[10]
IndexError: list index out of range
"""
        ]
      )
    )
  }


safePython : UnindexedSlideModel
safePython =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
from typing import Optional, TypeVar
T = TypeVar("T")

def safe_get(xs: list[T], idx: int) -> Optional[T]:
    return xs[idx] if -len(xs) <= idx < len(xs) else None

words: list[str] = ["one", "two", "three"]
word: Optional[str] = safe_get(words, 3)
if word is not None:
    word = word.upper()
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "It is however, possible to provide your own safer solution:" ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScript : UnindexedSlideModel
unsafeTypeScript =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
const words: string[] = ["one", "two", "three"];
const word: string = words[-1].toUpperCase();
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "This code is clearly wrong:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "But compiles, even in "
          , syntaxHighlightedCodeSnippet TypeScript "--strict"
          , text " mode, only to fail at runtime:"
          ]
        , console
          """
% tsc --strict safe_array_access/unsafe.ts
% jsc safe_array_access/unsafe.js
Exception: TypeError: undefined is not an object (evaluating 'words[-1].toUpp
erCase')
global code@safe_array_access/unsafe.js:3:21
"""
        ]
      )
    )
  }


safeTypeScriptInvalid : UnindexedSlideModel
safeTypeScriptInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty
      ( Dict.fromList [ (1, [ ColumnEmphasis Error 21 9 ] ) ] )
      [ CodeBlockError 1 19
        [ div []
          [ text """TS2532: Object is possibly 'undefined'.""" ]
        ]
      ]
      """
const words: string[] = ["one", "two", "three"];
const word: string = words[-1].toUpperCase();
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "The exact same code can by made array access safe, just by adding the "
          , br [] []
          , syntaxHighlightedCodeSnippet XML "--noUncheckedIndexedAccess"
          , text " compile option:"
          ]
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
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList [ (1, Deletion), (2, Addition) ] )
      Dict.empty []
      """
const words: string[] = ["one", "two", "three"];
const word: string = words[-1].toUpperCase();
const word: string | null = words[-1]?.toUpperCase() ?? null;
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "With "
          , syntaxHighlightedCodeSnippet TypeScript "--noUncheckedIndexedAccess"
          , text ", array access is safe. The programmer is required to use the "
          , syntaxHighlightedCodeSnippet TypeScript "?."
          , text " operator to access the potentially "
          , syntaxHighlightedCodeSnippet TypeScript "undefined"
          , text " value:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeScala : UnindexedSlideModel
unsafeScala =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
val words: Seq[String] = Seq("one", "two", "three")
val word: String = words(-1).toUpperCase
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Scala’s collection access is unsafe by default:" ]
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles and fails at runtime:"
          ]
        , console
          """
java.lang.IndexOutOfBoundsException: -1
  at scala.collection.LinearSeqOps.apply(LinearSeq.scala:115)
  at scala.collection.LinearSeqOps.apply$(LinearSeq.scala:114)
  at scala.collection.immutable.List.apply(List.scala:79)
  ... 43 elided
"""
        ]
      )
    )
  }


safeScala : UnindexedSlideModel
safeScala =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList [ (1, Deletion), (2, Addition) ] )
      Dict.empty []
      """
val words: Seq[String] = Seq("one", "two", "three")
val word: String = words(-1).toUpperCase
val word: Option[String] = words.lift(-1).map(_.toUpperCase)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "For safe array access, use the built-in "
          , syntaxHighlightedCodeSnippet Scala "lift(Int)"
          , text " method:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeKotlin : UnindexedSlideModel
unsafeKotlin =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin Dict.empty Dict.empty []
      """
val words: List<String> = listOf("one", "two", "three")
val word: String = words[-1]
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Kotlin’s array access is unsafe by default:" ]
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles and fails at runtime:"
          ]
        , console
          """
% kotlinc -script safe_array_access/unsafe.kts
java.lang.ArrayIndexOutOfBoundsException: Index -1 out of bounds for length 3
    at java.base/java.util.Arrays$ArrayList.get(Arrays.java:4165)
    at Unsafe.<init>(unsafe.kts:2)
"""
        ]
      )
    )
  }


safeKotlin : UnindexedSlideModel
safeKotlin =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin
      ( Dict.fromList [ (1, Deletion), (2, Addition) ] )
      Dict.empty []
      """
val words: List<String> = listOf("one", "two", "three")
val word: String = words[-1]
val word: String? = words.getOrNull(-1)?.uppercase()
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "For safe array access, use the built-in "
          , syntaxHighlightedCodeSnippet Kotlin "getOrNull(Int)"
          , text " method:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeSwift : UnindexedSlideModel
unsafeSwift =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
let words: [String] = ["one", "two", "three"]
let word: String = words[-1]
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift’s array access is unsafe:" ]
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles and fails at runtime:"
          ]
        , console
          """
% ./safe_array_access
Swift/ContiguousArrayBuffer.swift:575: Fatal error: Index out of range
zsh: illegal hardware instruction  ./safe_array_access
"""
        ]
      )
    )
  }


safeSwift : UnindexedSlideModel
safeSwift =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList
        [ (0, Addition), (1, Addition), (2, Addition), (3, Addition), (4, Addition)
        , (7, Deletion), (8, Addition)
        ]
      )
      Dict.empty []
      """
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let words: [String] = ["one", "two", "three"]
let word: String = words[-1]
let word: String? = words[safe: -1]
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "But can be made safe by extending Swift’s collection:" ]
        , div [] [] -- skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "Source: "
          , a [ href "https://stackoverflow.com/a/30593673/31506", target "_blank" ]
            [ text "https://stackoverflow.com/a/30593673/31506" ]
          ]
        ]
      )
    )
  }


safeElm : UnindexedSlideModel
safeElm =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm Dict.empty Dict.empty []
      """
module SafeArrayAccess exposing (..)
import Array exposing (Array)

words : Array String
words = Array.fromList ["one", "two", "three"]

word : Maybe String
word = words
  |> Array.get -1
  |> Maybe.map String.toUpper
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Elm collections return elements wrapped in "
          , syntaxHighlightedCodeSnippet Elm "Maybe"
          , text "s to account for the fact that an element may not be there:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeElm : UnindexedSlideModel
unsafeElm =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Elm does not allow the programmer to unsafely access elements of an array or of collections of any other type." ]
        ]
      )
    )
  }
