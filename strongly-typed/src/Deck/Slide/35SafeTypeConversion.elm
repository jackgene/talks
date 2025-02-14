module Deck.Slide.SafeTypeConversion exposing
  ( introduction
  , safeGo, introGo, unsafeGo, unsafeGoRun
  , safePython, unsafePythonGoodGuard
  , unsafePythonBadGuard, unsafePythonBadGuardRun, unsafePythonCast
  , safeTypeScript, unsafeTypeScriptGoodPredicateInvalid, unsafeTypeScriptGoodPredicate, unsafeTypeScriptCast
  , unsafeTypeScriptBadPredicate, unsafeTypeScriptBadPredicateRun
  , safeScala, unsafeScala
  , safeKotlinSmart, safeKotlinExplicit, unsafeKotlin
  , safeSwift, unsafeSwift
  , safeElm
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, br, div, em, p, text)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Safe Type Conversion"

subheadingGo : String
subheadingGo = "Go Is Not Type Conversion Safe (With Safe Options)"

subheadingPython : String
subheadingPython = "Python Is Not Type Conversion Safe (With Safe Options)"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Is Not Type Conversion Safe (With Safe Options)"

subheadingScala : String
subheadingScala = "Scala Is Not Type Conversion Safe (With Safe Options)"

subheadingKotlin : String
subheadingKotlin = "Kotlin Is Type Conversion Safe (With Options to Be Unsafe)"

subheadingSwift : String
subheadingSwift = "Swift Is Type Conversion Safe (With Options to Be Unsafe)"

subheadingElm : String
subheadingElm = "Elm Is Type Conversion Safe"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Type Conversion Failures"
      ( div []
        [ p []
          [ text "As long as there is a type hierarchy, or abstract types, type conversions are inevitable."
          ]
        , p []
          [ text "Languages with safe type conversions require programmers to "
          , mark [] [ text "account for conversion failures" ]
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
package main
import "strings"

func main() {
    var thing any = 42
    switch str := thing.(type) {
        case string:
            println(strings.ToUpper(str))
    }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "The safe way to assert types in Go is to use type "
          , syntaxHighlightedCodeSnippet Go "switch"
          , text "es:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


introGo : UnindexedSlideModel
introGo =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package main
import "strings"

func main() {
    var thing any = 42
    if str, ok := thing.(string); ok {
        println(strings.ToUpper(str))
    }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "But Go also has type assertions, which is meant to be used like this:" ]
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
import "strings"

func main() {
    var thing any = 42

    str, _ := thing.(string)      // non-panicking type assertion
    println(strings.ToUpper(str)) // let's hope zero-value is ok!

    str = thing.(string)          // unsafe type assertion - panic!
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "The following type assertion will clearly fail, but the Go compiler allows it:" ]
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
        [ p [] [ text "But the program immediately panics when run:" ]
        , console
          """
% safe_type_cast/unsafe

panic: interface conversion: interface {} is int, not string

goroutine 1 [running]:
main.main()
    /strongly-typed/safe_type_cast/unsafe.go:10 +0x65
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
      syntaxHighlightedCodeBlock Python Dict.empty
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 6 7 ] ) ] )
      [ CodeBlockError 4 5
        [ div []
          [ text """Cannot access member "upper" for type "int" """ ]
        ]
      ]
      """
import random

thing: int | str = random.choice([42, "forty-two"])

thing.upper()

if isinstance(thing, str):
    thing.upper()
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Through type narrowing, there’s rarely a need to explicitly convert types:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafePythonGoodGuard : UnindexedSlideModel
unsafePythonGoodGuard =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
from typing import Any, TypeGuard

def is_str_array(objs: list[Any]) -> TypeGuard[list[str]]:
    return all(isinstance(obj, str) for obj in objs)

nums: list[Any] = [1, 2, 3]
if is_str_array(nums):
    for num in nums:
        print(num.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "However, Python sometimes require you to implement your own type checking:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafePythonBadGuard : UnindexedSlideModel
unsafePythonBadGuard =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList
        [ (3, Deletion), (4, Addition)
        ]
      )
      Dict.empty []
      """
from typing import Any, TypeGuard

def is_str_array(objs: list[Any]) -> TypeGuard[list[str]]:
    return all(isinstance(obj, str) for obj in objs)
    return True

nums: list[Any] = [1, 2, 3]
if is_str_array(nums):
    for num in nums:
        print(num.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Without verifying your type checking logic:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafePythonBadGuardRun : UnindexedSlideModel
unsafePythonBadGuardRun =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Only at runtime do you learn about these errors:" ]
        , console
          """
% python safe_type_cast/unsafe_typeguard.py
Traceback (most recent call last):
  File "/strongly-typed/safe_type_cast/unsafe_typeguard.py", line 9, in <modul
e>
    print(num.upper())
AttributeError: 'int' object has no attribute 'upper'
"""
        ]
      )
    )
  }


unsafePythonCast : UnindexedSlideModel
unsafePythonCast =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
from typing import cast

text: str = cast(str, 42)
print(text.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Casting is just an escape hatch to “cheat” the type system:" ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "Casts will never fail in Python, but what happens after may:" ]
        , console
          """
% python safe_type_cast/unsafe_cast.py
Traceback (most recent call last):
  File "/strongly-typed/safe_type_cast/unsafe_cast.py", line 4, in <module>
    print(text.upper())
AttributeError: 'int' object has no attribute 'upper'
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
      ( Dict.fromList [ (3, [ ColumnEmphasis Error 6 13 ] ) ] )
      [ CodeBlockError 3 4
        [ div []
          [ text "TS2339: Property 'toUpperCase' does not exist on type 'string | number'."
          , br [] []
          , text "Property 'toUpperCase' does not exist on type 'number'." ]
        ]
      ]
      """
const thing: number | string =
    Math.random() < 0.5 ? 42 : "forty-two"

thing.toUpperCase()


if (typeof(thing) === "string") {
  thing.toUpperCase()
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Thanks to narrowing, type conversion is rarely necessary:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptGoodPredicateInvalid : UnindexedSlideModel
unsafeTypeScriptGoodPredicateInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty
      ( Dict.fromList [ (6, [ ColumnEmphasis Error 30 13 ] ) ] )
      [ CodeBlockError 6 24
        [ div []
          [ text "TS2339: Property 'toUpperCase' does not exist on type 'string | number'."
          , br [] []
          , text "Property 'toUpperCase' does not exist on type 'number'." ]
        ]
      ]
      """
function isStringArray(objs: any[]): objs is string[] {
  return objs.every(obj => typeof(obj) === "string");
}

const nums: (number | string)[] = [1, 2, 3];

nums.forEach(num => alert(num.toUpperCase()));

\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with Python, TypeScript sometimes outsources type checking to the programmer:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptGoodPredicate : UnindexedSlideModel
unsafeTypeScriptGoodPredicate =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (6, Deletion), (7, Addition), (8, Addition), (9, Addition)
        ]
      )
      Dict.empty []
      """
function isStringArray(objs: any[]): objs is string[] {
  return objs.every(obj => typeof(obj) === "string");
}

const nums: (number | string)[] =  [1, 2, 3];

nums.forEach(num => alert(num.toUpperCase()));
if (isStringArray(nums)) {
  nums.forEach(num => alert(num.toUpperCase()));
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with Python, TypeScript sometimes outsources type checking to the programmer:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptBadPredicate : UnindexedSlideModel
unsafeTypeScriptBadPredicate =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (1, Deletion), (2, Addition)
        ]
      )
      Dict.empty []
      """
function isStringArray(objs: any[]): objs is string[] {
  return objs.every(obj => typeof(obj) === "string");
  return true;
}

const nums: (number | string)[] = [1, 2, 3];

if (isStringArray(nums)) {
  nums.forEach(num => alert(num.toUpperCase()));
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "TypeScript does nothing to ensure that type predicates are correct:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeTypeScriptBadPredicateRun : UnindexedSlideModel
unsafeTypeScriptBadPredicateRun =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "At runtime, the program in the previous slide fails with:" ]
        , console
          """
% jsc safe_type_cast/unsafe_predicate.js
Exception: TypeError: num.toUpperCase is not a function. (In 'num.toUpperCase(
)', 'num.toUpperCase' is undefined)
@safe_type_cast/unsafe_predicate.js:7:63
forEach@[native code]
global code@safe_type_cast/unsafe_predicate.js:7:17
"""
        ]
      )
    )
  }


unsafeTypeScriptCast : UnindexedSlideModel
unsafeTypeScriptCast =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
const text: string = (42 as unknown) as string;

console.log(text.toUpperCase());
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Just as with Python, casting allows you to bypass type checks:" ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "They will never fail, resulting in possible runtime errors:" ]
        , console
          """
% jsc safe_type_cast/unsafe_cast.js
Exception: TypeError: text.toUpperCase is not a function. (In
'text.toUpperCase()', 'text.toUpperCase' is undefined)
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
      syntaxHighlightedCodeBlock Scala Dict.empty
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 0 17 ] ) ] )
      [ CodeBlockError 4 2
        [ div [] [ text "value toUpperCase is not a member of Int | String" ] ]
      ]
      """
val thing: Int | String =
  if (util.Random.nextBoolean) 42
  else "forty-two"

thing.toUpperCase

thing match
  case str: String => str.toUpperCase
  case _ =>
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Type casts are rarely necessary in Scala, and when they are, can be done safely:" ]
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
val text: String = 42\xAD.asInstanceOf[String] // ClassCastException!
text.toUpperCase
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "An explicit cast is also available, but is unsafe:"
          ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles, but is guaranteed to fail at runtime:"
          ]
        , console
          """
java.lang.ClassCastException: class java.lang.Integer cannot be cast to class
java.lang.String (java.lang.Integer and java.lang.String are in module
java.base of loader 'bootstrap')
  ... 43 elided
"""
        ]
      )
    )
  }


safeKotlinSmart : UnindexedSlideModel
safeKotlinSmart =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin Dict.empty
      ( Dict.fromList [ (2, [ ColumnEmphasis Error 6 11 ] ) ] )
      [ CodeBlockError 2 2
        [ div []
          [ text "unresolved reference. None of the following candidates is applicable because of receiver type mismatch:"
          , br [] []
          , text "..." ]
        ]
      ]
      """
val thing: Any = if (Math.random() < 0.5) 42 else "forty-two"

thing.uppercase()


if (thing is String) {
    thing.uppercase()
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Kotlin’s implicit “smart casts” make explicit casts rarely necessary:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeKotlinExplicit : UnindexedSlideModel
safeKotlinExplicit =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Kotlin Dict.empty Dict.empty []
      """
val thing: Any = if (Math.random() < 0.5) 42 else "forty-two"

// null if cast fails
val text: String? = thing as? String

if (text != null) {
    text.uppercase()
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "The the option of a safe explicit cast is available:" ]
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
val text: String = 42 as String  // ClassCastException!
text.uppercase()
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "An explicit "
          , em [] [ text "unsafe" ]
          , text " cast is also available, which should save you a nanosecond or two:"
          ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles, but is guaranteed to fail at runtime:"
          ]
        , console
          """
% kotlinc -script safe_type_cast/unsafe.kts
java.lang.ClassCastException: class java.lang.Integer cannot be cast to class
java.lang.String (java.lang.Integer and java.lang.String are in module
java.base of loader 'bootstrap')
    at Unsafe.<init>(unsafe.kts:1)
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
      syntaxHighlightedCodeBlock Swift Dict.empty
      ( Dict.fromList [ (2, [ ColumnEmphasis Error 6 12 ] ) ] )
      [ CodeBlockError 2 4
        [ div []
          [ text "value of type 'Any' has no member 'uppercased'" ]
        ]
      ]
      """
let thing: Any = Bool.random() ? 42 : "forty-two"

thing.uppercased()

if let thing = thing as? String {
    thing.uppercased()
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift casts must be explicit, but the syntax is fairly succinct:" ]
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
let text: String = 42 as! String  // it's a trap!
text.uppercased()
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "When every nanosecond counts, Swift has the "
          , em [] [ text "unsafe" ]
          , text " cast operator - "
          , syntaxHighlightedCodeSnippet Swift "as!"
          , text ":"
          ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlock ]
        , p []
          [ text "This compiles, but traps with this unhelpful message:"
          ]
        , console
          """
% ./safe_type_cast
zsh: illegal hardware instruction  ./safe_type_cast
"""
        ]
      )
    )
  }


safeElm : UnindexedSlideModel
safeElm =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Elm only allows the programmer to work with type information known at compile time." ]
        , p []
          [ text "It does not allow type conversion to a more specific type at runtime. For instance, programmers cannot see if a "
          , syntaxHighlightedCodeSnippet Elm "comparable"
          , text " reference refers to a "
          , syntaxHighlightedCodeSnippet Elm "String"
          , text " at runtime, and perform "
          , syntaxHighlightedCodeSnippet Elm "String"
          , text "-specific operations on it."
          ]
        , p []
          [ text "By only allowing type conversion to a more general type, Elm type conversions are always safe." ]
        ]
      )
    )
  }
