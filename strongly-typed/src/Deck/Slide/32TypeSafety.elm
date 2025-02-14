module Deck.Slide.TypeSafety exposing
  ( introduction
  , safeGo, safeGoInvalid, unsafeGoInvalid, unsafeGo
  , safePython, safePythonInvalid, unsafePythonUnannotated, unsafePythonRun
  , pythonTypeHintUnannotated, pythonTypeHintWrong, pythonTypeHintWrongRun
  , safeTypeScript, safeTypeScriptInvalid, unsafeTypeScriptAny, unsafeTypeScriptUnannotated, unsafeTypeScriptFuncParam
  , safeScala, safeScalaInvalid, unsafeScalaInvalid, unsafeScala
  , safeKotlin, safeKotlinInvalid, unsafeKotlinInvalid, unsafeKotlin
  , safeSwift, safeSwiftInvalid, unsafeSwiftInvalid, unsafeSwift
  , safeElm, safeElmInvalid1, safeElmInvalid2, unsafeElm
  )

import Css exposing
  -- Container
  ( marginBottom
  -- Units
  , vw
  -- Other Values
  )
import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, code, div, em, p, text, u)
import Html.Styled.Attributes exposing (css)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Type Safety"

subheadingGo : String
subheadingGo = "Go Is Type Safe"

subheadingPython : String
subheadingPython = "Python Can Be Type Safe"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Be Type Safe"

subheadingScala : String
subheadingScala = "Scala Is Type Safe"

subheadingKotlin : String
subheadingKotlin = "Kotlin Is Type Safe"

subheadingSwift : String
subheadingSwift = "Swift Is Type Safe"

subheadingElm : String
subheadingElm = "Elm Is Type Safe"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Type Mismatch Errors"
      ( div []
        [ p []
          [ text "The most fundamental aspect of strong typing."
          ]
        , p []
          [ text "All data values have distinct types. As do function inputs and outputs."
          ]
        , p []
          [ text "Type safe languages ensure that "
          , mark [] [ text "types match across the entire program" ]
          , text "."
          ]
        ]
      )
    )
  }


safeGo : UnindexedSlideModel
safeGo =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package typesafety

func Multiply(num1 float64, num2 float64) float64 {
    return num1 * num2
}

var product float64 = Multiply(42, 2.718)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Function parameters and return values "
          , em [] [ text "must " ]
          , text "have declared types, and must be called with those types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeGoInvalid : UnindexedSlideModel
safeGoInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go
      ( Dict.fromList [ (6, Deletion), (7, Addition) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 31 4, ColumnEmphasis Error 37 4 ] ) ] )
      [ CodeBlockError 7 23
        [ div []
          [ text """cannot use "42" (type untyped string) as type float64 in argument to Multiply""" ]
        , div []
          [ text "cannot use true (type untyped bool) as type float64 in argument to Multiply" ]
        ]
      ]
      """
package typesafety

func Multiply(num1 float64, num2 float64) float64 {
    return num1 * num2
}

var product float64 = Multiply(42, 2.718)
var product float64 = Multiply("42", true)
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeGoInvalid : UnindexedSlideModel
unsafeGoInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go
      ( Dict.fromList [ (2, Deletion), (3, Addition) ] )
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 11 11 ] ) ] )
      [ CodeBlockError 4 10
        [ div []
          [ text "invalid operation: operator * not defined on num1 (variable of type any)" ]
        ]
      ]
      """
package typesafety

func Multiply(num1 float64, num2 float64) float64 {
func Multiply(num1 any, num1 any) float64 {
    return num1 * num2
}

var product float64 = Multiply("42", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "You cannot accidentally get around the Go type system:" ]
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
      syntaxHighlightedCodeBlock Go
      ( Dict.fromList
        [ (3, Deletion), (4, Addition), (5, Addition), (6, Addition)
        ]
      )
      Dict.empty
      []
      """
package typesafety

func Multiply(num1 any, num2 any) float64 {
    return num1 * num2
    num1_, _ := num1.(float64)
    num2_, _ := num2.(float64)
    return num1_ * num2_
}

var product float64 = Multiply("42", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "While possible, you would have to Go out of your way to defeat the type system:" ]
        , div [] [] -- skip transition animation
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
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
def multiply(num1: float, num2: float) -> float:
    return num1 * num2

product: float = multiply(42, 2.718)
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Function parameters and return values can have declared types..." ]
        , div [] [ codeBlock ]
        , p []
          [ text "...and if so, must be called with those types." ]
        ]
      )
    )
  }


safePythonInvalid : UnindexedSlideModel
safePythonInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList [ (3, Deletion), (4, Addition) ] )
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 26 4 ] ) ] )
      [ CodeBlockError 4 5
        [ div []
          [ text """Argument of type "Literal['42']" cannot be assigned to parameter "num1" of type "float" in function "multiply" """ ]
        ]
      ]
      """
def multiply(num1: float, num2: float) -> float:
    return num1 * num2

product: float = multiply(42, 2.718)
product: float = multiply("42", True)
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Type-checking fails if a function is called with non-matching parameter types:" ]
        , div [ css [ marginBottom (vw 4) ] ] [ codeBlock ]
        , p []
          [ text "Note: "
          , syntaxHighlightedCodeSnippet Python "True"
          , text " is a valid parameter value here. This is because a Python "
          , syntaxHighlightedCodeSnippet Python "bool"
          , text " is a sub-type of "
          , syntaxHighlightedCodeSnippet Python "int"
          , text ", which is compatible with "
          , syntaxHighlightedCodeSnippet Python "float"
          , text "."
          ]
        ]
      )
    )
  }


unsafePythonUnannotated : UnindexedSlideModel
unsafePythonUnannotated =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList
        [ (0, Deletion), (1, Addition)
        ]
      )
      Dict.empty []
      """
def multiply(num1: float, num2: float) -> float:
def multiply(num1, num2):
    return num1 * num2

product = multiply("42", "2.718")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Python typing is optional by design - you can simply omit type annotations:" ]
        , div [ css [] ] [ codeBlock ]
        , p []
          [ text "However, when you run the program..." ]
        ]
      )
    )
  }


unsafePythonRun : UnindexedSlideModel
unsafePythonRun =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p [] [ text "...the program fails with the following:" ]
        , console
          """
% python type_safety/unsafe.py
Traceback (most recent call last):
  File "/strongly-typed/type_safety/unsafe.py", line 4, in <module>
    product = multiply("42", "2.718")
  File "/strongly-typed/type_safety/unsafe.py", line 2, in multiply
    return num1 * num2
TypeError: can't multiply sequence by non-int of type 'str'
"""
        ]
      )
    )
  }


pythonTypeHintUnannotated : UnindexedSlideModel
pythonTypeHintUnannotated =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
def multiply(num1, num2):
    return num1 * num2

print(multiply(42, 2.718))
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "A Word About Python Type Hints"
      ( div []
        [ p [] [ text "Python type hints are just that - hints. Consider the program with type hints removed, it is simple enough you can tell it is correct:" ]
        , div [ css [] ] [ codeBlock ]
        , p [] [ text "A test run shows that the program is indeed correct:" ]
        , console
          """
% python type_safety/unannotated_valid.py
114.156
"""
        ]
      )
    )
  }


pythonTypeHintWrong : UnindexedSlideModel
pythonTypeHintWrong =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList
        [ (0, Deletion), (1, Addition)
        ]
      )
      ( Dict.fromList
        [ (2, [ ColumnEmphasis Error 16 1 ] )
        , (5, [ ColumnEmphasis Error 15 2, ColumnEmphasis Error 19 5 ] )
        ]
      )
      [ CodeBlockError 2 15
        [ div []
          [ text """Operator "*" not supported for types "str" and "str" """ ]
        ]
      , CodeBlockError 5 3
        [ div []
          [ text """Argument of type "Literal[42]" cannot be assigned to parameter "num1" of type "str" in function "multiply_strs" """ ]
        , div []
          [ text """Argument of type "float" cannot be assigned to parameter "num2" of type "str" in function "multiply_strs" """ ]
        ]
      ]
      """
def multiply(num1, num2):
def multiply(num1: str, num2: str) -> str:
    return num1 * num2


print(multiply(42, 2.718))
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "A Word About Python Type Hints"
      ( div []
        [ p [] [ text "Now we add a bunch of clearly incorrect type information:" ]
        , div [ css [] ] [ codeBlock ]
        ]
      )
    )
  }


pythonTypeHintWrongRun : UnindexedSlideModel
pythonTypeHintWrongRun =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "A Word About Python Type Hints"
      ( div []
        [ p []
          [ text "The program "
          , em [] [ text "still" ]
          , text " runs correctly. Type information is "
          , em [] [ text "completely ignored" ]
          , text " by the Python interpreter:" ]
        , console
          """
% python type_safety/wrong_type_valid.py
114.156
"""
        , p []
          [ text "Type annotations in Python are just "
          , em [] [ text "hints" ]
          , text " to facilitate 3rd-party type checkers, such as those built into PyCharm or Visual Studio Code. "
          ]
        , p []
          [ text "It is up to programming teams to incorporate these type checkers in their build process, "
          , text "where they’d use a dedicated type checker like mypy, Pyright, or Pyre."
          ]
        ]
      )
    )
  }


safeTypeScript : UnindexedSlideModel
safeTypeScript =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
function multiply(num1: number, num2: number): number {
  return num1 * num2;
}

const product: number = multiply(42, 2.718);
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Function parameters and return values can have declared types..." ]
        , div [] [ codeBlock ]
        , p []
          [ text "...and if so, must be called with those types." ]
        ]
      )
    )
  }


safeTypeScriptInvalid : UnindexedSlideModel
safeTypeScriptInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList [ (4, Deletion), (5, Addition) ] )
      ( Dict.fromList [ (5, [ ColumnEmphasis Error 33 4, ColumnEmphasis Error 39 4 ] ) ] )
      [ CodeBlockError 5 19
        [ div []
          [ text "TS2345: Argument of type 'string' is not assignable to parameter of type 'number'." ]
        , div []
          [ text "TS2345: Argument of type 'boolean' is not assignable to parameter of type 'number'." ]
        ]
      ]
      """
function multiply(num1: number, num2: number): number {
  return num1 * num2;
}

const product: number = multiply(42, 2.718);
const product: number = multiply("42", true);

\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptAny : UnindexedSlideModel
unsafeTypeScriptAny =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (0, Deletion), (1, Addition)
        , (5, Deletion), (6, Addition)
        ]
      )
      Dict.empty []
      """
function multiply(num1: number, num2: number): number {
function multiply(num1: any, num2: any): any {
  return num1 * num2;
}

const product = multiply("42", true);
const product = multiply("42", "2.718");
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with Python, TypeScript allows you to annotate anything with "
          , syntaxHighlightedCodeSnippet TypeScript "any"
          , text ":"
          ]
        , div [ css [] ] [ codeBlock ]
        , p [] [ text "..." ]
        ]
      )
    )
  }


unsafeTypeScriptUnannotated : UnindexedSlideModel
unsafeTypeScriptUnannotated =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (0, Deletion), (1, Addition)
        ]
      )
      Dict.empty []
      """
function multiply(num1: any, num2: any): any {
function multiply(num1, num2) {
  return num1 * num2;
}

const product = multiply("42", "2.718");
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "...Or skip type declarations altogether as with plain JavaScript, when not in strict mode:" ]
        , div [ css [] ] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptFuncParam : UnindexedSlideModel
unsafeTypeScriptFuncParam =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
const elem = document.createElement("dialog");

// Type signature of onclose:
// onclose: ((this: GlobalEventHandlers, ev: Event) => any) | null;

// Compiles despite function signature mismatch
elem.onclose = function () {};

// Which can lead to bugs like these
elem.onclose = window.close;
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "TypeScript’s biggest weakness however, is that in order to work well with JavaScript, "
          , text "not everything is fully type-checked:"
          ]
        , div [] [] -- Skip transition animation
        , div [ css [] ] [ codeBlock ]
        ]
      )
    )
  }


safeScala : UnindexedSlideModel
safeScala =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
def multiply(num1: Double, num2: Double): Double = num1 * num2

val product: Double = multiply(42.0, 2.718)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Function parameters and return values "
          , em [] [ text "must " ]
          , text "have declared types, and must be called with those types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeScalaInvalid : UnindexedSlideModel
safeScalaInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList [ (2, Deletion), (3, Addition) ] )
      ( Dict.fromList [ (3, [ ColumnEmphasis Error 31 4, ColumnEmphasis Error 37 4 ] ) ] )
      [ CodeBlockError 3 29
        [ div []
          [ text """Found:    ("42" : String)""" ]
        , div []
          [ text "Required: Double" ]
        ]
      , CodeBlockError 2 42
        [ div []
          [ text "Found:    (true : Boolean)" ]
        , div []
          [ text "Required: Double" ]
        ]
      ]
      """
def multiply(num1: Double, num2: Double): Double = num1 * num2

val product: Double = multiply(42.0, 2.718)
val product: Double = multiply("42", true)

\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeScalaInvalid : UnindexedSlideModel
unsafeScalaInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList [ (0, Deletion), (1, Addition) ] )
      ( Dict.fromList [ (1, [ ColumnEmphasis Error 45 6 ] ) ] )
      [ CodeBlockError 1 45
        [ div []
          [ text "value * is not a member of Any" ]
        ]
      ]
      """
def multiply(num1: Double, num2: Double): Double = num1 * num2
def multiply(num1: Any, num2: Any): Double = num1 * num2

val product: Double = multiply("42.0", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "As with Go, you cannot accidentally get around Scala’s type safety:" ]
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
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList
        [ (0, Deletion), (1, Addition), (2, Addition), (3, Addition), (4, Addition)
        , (5, Deletion), (6, Addition)
        ]
      )
      Dict.empty []
      """
def multiply(num1: Any, num2: Any): Double = num1 * num2
def multiply(a1: Any, a2: Any): Option[Double] = (a1, a2) match
  case (num1: Double, num2: Double) => Some(num1 * num2)
  case _ => None

val product: Double = multiply("42.0", true)
val product: Option[Double] = multiply("42.0", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "It takes a little more effort:" ]
        , div [] [] -- Skip transition animation
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
      syntaxHighlightedCodeBlock Kotlin Dict.empty Dict.empty []
      """
fun multiply(num1: Double, num2: Double): Double = num1 * num2

val product: Double = multiply(42.0, 2.718)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Function parameters and return values "
          , em [] [ text "must " ]
          , text "have declared types, and must be called with those types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeKotlinInvalid : UnindexedSlideModel
safeKotlinInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin
      ( Dict.fromList [ (2, Deletion), (3, Addition) ] )
      ( Dict.fromList [ (3, [ ColumnEmphasis Error 31 4, ColumnEmphasis Error 37 4 ] ) ] )
      [ CodeBlockError 3 29
        [ div []
          [ text "type mismatch: inferred type is String but Double was expected" ]
        , div []
          [ text "the boolean literal does not conform to the expected type Double" ]
        ]
      ]
      """
fun multiply(num1: Double, num2: Double): Double = num1 * num2

val product: Double = multiply(42.0, 2.718)
val product: Double = multiply("42", true)
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeKotlinInvalid : UnindexedSlideModel
unsafeKotlinInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin
      ( Dict.fromList [ (0, Deletion), (1, Addition) ] )
      ( Dict.fromList [ (1, [ ColumnEmphasis Error 50 1 ] ) ] )
      [ CodeBlockError 1 6
        [ div []
          [ text "unresolved reference. None of the following candidates is applicable because of receiver type mismatch: " ]
        , div []
          [ text "public inline operator fun BigDecimal.times(other: BigDecimal): BigDecimal defined in kotlin" ]
        , div []
          [ text "public inline operator fun BigInteger.times(other: BigInteger): BigInteger defined in kotlin" ]
        ]
      ]
      """
fun multiply(num1: Double, num2: Double): Double = num1 * num2
fun multiply(num1: Any, num2: Any): Double = num1 * num2



val product: Double = multiply("42.0", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "As with Go, you cannot accidentally get around Kotlin’s type safety:" ]
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
      syntaxHighlightedCodeBlock Kotlin
      ( Dict.fromList
        [ (0, Deletion), (1, Addition), (2, Addition), (3, Addition)
        , (5, Deletion), (6, Addition)
        ]
      )
      Dict.empty []
      """
fun multiply(num1: Any, num2: Any): Double = num1 * num2
fun multiply(num1: Any, num2: Any): Double? =
    if (num1 !is Double || num2 !is Double) null
    else num1 * num2

val product: Double = multiply("42.0", true)
val product: Double? = multiply("42.0", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "It takes a little more effort:" ]
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
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
func multiply(_ num1: Double, _ num2: Double) -> Double {
    num1 * num2
}

let product: Double = multiply(42, 2.718)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Function parameters and return values "
          , em [] [ text "must" ]
          , text " have declared types, and must be called with those types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftInvalid : UnindexedSlideModel
safeSwiftInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList [ (4, Deletion), (5, Addition) ] )
      ( Dict.fromList [ (5, [ ColumnEmphasis Error 31 4, ColumnEmphasis Error 37 4 ] ) ] )
      [ CodeBlockError 5 25
        [ div []
          [ text "cannot convert value of type 'String' to expected argument type 'Double'" ]
        , div []
          [ text "cannot convert value of type 'Bool' to expected argument type 'Double'" ]
        ]
      ]
      """
func multiply(_ num1: Double, _ num2: Double) -> Double {
    num1 * num2
}

let product: Double = multiply(42, 2.718)
let product: Double = multiply("42", true)
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeSwiftInvalid : UnindexedSlideModel
unsafeSwiftInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList [ (0, Deletion), (1, Addition) ] )
      ( Dict.fromList [ (2, [ ColumnEmphasis Error 16 1 ] ) ] )
      [ CodeBlockError 2 14
        [ div []
          [ text "binary operator '*' cannot be applied to two 'Any' operands" ]
        ]
      ]
      """
func multiply(_ num1: Double, _ num2: Double) -> Double {
func multiply(_ num1: Any, _ num2: Any) -> Double {
    return num1 * num2
}

let product: Double = multiply("42", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "As Swift is statically typed, you cannot accidentally forget type safety:" ]
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
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList
        [ (0, Deletion), (1, Addition), (2, Addition), (3, Addition), (4, Addition)
        , (8, Deletion), (9, Addition)
        ]
      )
      Dict.empty []
      """
func multiply(_ num1: Any, _ num2: Any) -> Double {
func multiply(_ num1: Any, _ num2: Any) -> Double? {
    guard
        let num1 = num1 as? Double, let num2 = num2 as? Double
    else { return nil }
    return num1 * num2
}

let product: Double = multiply("42", true)
let product: Double? = multiply("42", true)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Defeating Swift's type safety takes effort:" ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
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
module TypeSafety exposing (..)

multiply : Float -> Float -> Float
multiply num1 num2 = num1 * num2

product : Float
product = multiply 42 2.718
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Function parameters and return values have known types at compile-time, and must be called using inputs of the correct types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmInvalid1 : UnindexedSlideModel
safeElmInvalid1 =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList [ (6, Deletion), (7, Addition) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 19 4, ColumnEmphasis Error 24 4 ] ) ] )
      [ CodeBlockError 7 20
        [ div []
          [ text "The 1st argument to "
          , code [] [ text "multiply" ]
          , text " is not what I expect:"
          ]
        , div [] [ text "This argument is a string of type: String" ]
        , div []
          [ text "But "
          , code [] [ text "multiply" ]
          , text " needs the 1st argument to be: Float"
          ]
        , div []
          [ u [] [ text "Hint" ]
          , text ": Want to convert a String into a Float? Use the "
          , code [] [ text "String.toFloat" ]
          , text " function!"
          ]
        ]
      ]
      """
module TypeSafety exposing (..)

multiply : Float -> Float -> Float
multiply num1 num2 = num1 * num2

product : Float
product = multiply 42 2.718
product = multiply "42" True
\xAD
\xAD
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmInvalid2 : UnindexedSlideModel
safeElmInvalid2 =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList [ (6, Deletion), (7, Addition) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 19 4, ColumnEmphasis Error 24 4 ] ) ] )
      [ CodeBlockError 7 25
        [ div []
          [ text "The 2nd argument to "
          , code [] [ text "multiply" ]
          , text " is not what I expect:"
          ]
        , div []
          [ text "This "
          , code [] [ text "True" ]
          , text " value is a: Bool"
          ]
        , div []
          [ text "But "
          , code [] [ text "multiply" ]
          , text " needs the 2nd argument to be: Float"
          ]
        , div []
          [ u [] [ text "Hint" ]
          , text ": ..."
          ]
        ]
      ]
      """
module TypeSafety exposing (..)

multiply : Float -> Float -> Float
multiply num1 num2 = num1 * num2

product : Float
product = multiply 42 2.718
product = multiply "42" True
\xAD
\xAD
\xAD
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Compilation fails if a function is called with non-matching parameter types:" ]
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
          [ text "Elm does not have a top/universal type (like an "
          , syntaxHighlightedCodeSnippet Elm "any"
          , text " in other languages) as such you cannot defeat type safety in it."
          ]
        , p []
          [ text "In that respect, you could argue that Elm is the only truly type-safe language in this list: The only language that deserves a 1.0 lower-bound score." ]
        ]
      )
    )
  }
