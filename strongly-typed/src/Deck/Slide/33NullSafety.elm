module Deck.Slide.NullSafety exposing
  ( introduction
  , unsafeGo, unsafeGoRun
  , safePythonNonNull, safePythonNonNullInvalid, safePythonNullableInvalid, safePythonNullable
  , safeTypeScriptNonNull, safeTypeScriptNonNullInvalid, safeTypeScriptNullableInvalid, safeTypeScriptNullable
  , safeScalaNullableInvalid, safeScalaNullable, safeScalaNullableFun, safeScalaNullableFor, unsafeScala
  , safeKotlinNullable, unsafeKotlin
  , safeSwiftNullable, safeSwiftNullableFun, unsafeSwift
  , safeElmNonNull, safeElmNullableInvalid, safeElmNullable, safeElmNullableFun, unsafeElm
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, code, div, em, p, text, u)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Null Safety"

subheadingGo : String
subheadingGo = "Go Is Not Null Safe"

subheadingPython : String
subheadingPython = "Python Can Be Null Safe"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Be Null Safe"

subheadingScala : String
subheadingScala = "Scala Can Be Null Safe"

subheadingKotlin : String
subheadingKotlin = "Kotlin Is Null Safe (With Options to Be Unsafe)"

subheadingSwift : String
subheadingSwift = "Swift Is Null Safe (With Options to Be Unsafe)"

subheadingElm : String
subheadingElm = "Elm Is Null Safe"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Null Pointer Dereferences"
      ( div []
        [ p []
          [ text "Null-safe languages make it "
          , mark [] [ text "impossible to dereference null pointers" ]
          , text "."
          ]
        , p []
          [ text "Nullable pointers must be null-checked before access." ]
        , p []
          [ text "Non-nullable pointers are required to always have a value, "
          , text "and can be accessed without null-checking."
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
    var name *string = nil // clearly nil
    println(*name)         // unchecked pointer access - panic!
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Consider the following program that accesses a pointer without checking for "
          , syntaxHighlightedCodeSnippet Go "nil"
          , text ":" ]
        , div [] [ codeBlock ]
        , p []
          [ text "The Go compiler happily allows it:" ]
        , console
          """
% go build null_safety/unsafe.go; echo $?
0
"""
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
% null_safety/unsafe
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x1054cb6]

goroutine 1 [running]:
main.main()
    /strongly-typed/null_safety/unsafe.go:5 +0x16
"""
        ]
      )
    )
  }


safePythonNonNull : UnindexedSlideModel
safePythonNonNull =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
text: str = "Lorem Ipsum"

print(text.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Variables are non-nullable (cannot be "
          , syntaxHighlightedCodeSnippet Python "None"
          , text ") by default:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safePythonNonNullInvalid : UnindexedSlideModel
safePythonNonNullInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList [ (0, Deletion), (1, Addition) ] )
      ( Dict.fromList [ (1, [ ColumnEmphasis Error 12 4 ] ) ] )
      [ CodeBlockError 0 17
        [ div []
          [ text """Expression of type "None" cannot be assigned to declared type "str" """ ]
        ]
      ]
      """
text: str = "Lorem Ipsum"
text: str = None

print(text.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Attempting to assign "
          , syntaxHighlightedCodeSnippet Python "None"
          , text " results in a type error:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safePythonNullableInvalid : UnindexedSlideModel
safePythonNullableInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList
        [ (0, Addition)
        , (2, Deletion), (3, Addition)
        ]
      )
      ( Dict.fromList [ (5, [ ColumnEmphasis Error 11 7 ] ) ] )
      [ CodeBlockError 4 19
        [ div []
          [ text """"upper" is not a known member of "None" """ ]
        ]
      ]
      """
from typing import Optional

text: str = None
text: Optional[str] = None

print(text.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Nullable variables must be explicitly annotated "
          , syntaxHighlightedCodeSnippet Python ": Optional[str]"
          , text ", and if so cannot be accessed directly:"
          ]
        , div [] [] -- To disable transition animation
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safePythonNullable : UnindexedSlideModel
safePythonNullable =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList
        [ (4, Deletion), (5, Addition), (6, Addition)
        ]
      )
      Dict.empty []
      """
from typing import Optional

text: Optional[str] = None

print(text.upper())
if text is not None:
    print(text.upper())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Before accessing a nullable variable, the programmer is required to check that it is not "
          , syntaxHighlightedCodeSnippet Python "None"
          , text ":"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "Note that in Python, "
          , syntaxHighlightedCodeSnippet Python ": Optional[str]"
          , text " is a type alias for "
          , syntaxHighlightedCodeSnippet Python ": Union[str, None]"
          , text ", or in Python 3.10 "
          , syntaxHighlightedCodeSnippet Python ": str | None"
          , text "."
          ]
        ]
      )
    )
  }


safeTypeScriptNonNull : UnindexedSlideModel
safeTypeScriptNonNull =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
const text: string = "Lorem Ipsum";

alert(text.toUpperCase());
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "TypeScript variables are non-nullable by default: "
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  , active = ( \model -> List.isEmpty model.languagesAndCounts )
  }


safeTypeScriptNonNullInvalid : UnindexedSlideModel
safeTypeScriptNonNullInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript Dict.empty
      ( Dict.fromList [ (0, [ ColumnEmphasis Error 21 4 ] ) ] )
      [ CodeBlockError -1 26
        [ div []
          [ text """TS2322: Type 'null' is not assignable to type 'string'.""" ]
        ]
      ]
      """
const text: string = null;

alert(text.toUpperCase());
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with all languages with modern type-systems, variables in TypeScript are non-nullable by default. "
          , text "Attempting to assign "
          , syntaxHighlightedCodeSnippet TypeScript "null"
          , text " results in a type error:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeTypeScriptNullableInvalid : UnindexedSlideModel
safeTypeScriptNullableInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList [ (0, Deletion), (1, Addition) ] )
      ( Dict.fromList [ (3, [ ColumnEmphasis Error 6 4 ] ) ] )
      [ CodeBlockError 3 5
        [ div []
          [ text """TS2531: Object is possibly 'null'. """ ]
        ]
      ]
      """
const text: string = null;
const text: string | null = null;

alert(text.toUpperCase());
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Nullable variables work the same way in TypeScript as in Python, "
          , text "but with a slightly different type annotation syntax:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeTypeScriptNullable : UnindexedSlideModel
safeTypeScriptNullable =
  let
    codeBlock1 : Html msg
    codeBlock1 =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (2, Deletion), (3, Addition)
        ]
      )
      Dict.empty []
      """
const text: string | null = null;

alert(text.toUpperCase());
if (text !== null) alert(text.toUpperCase());
"""

    codeBlock2 : Html msg
    codeBlock2 =
      syntaxHighlightedCodeBlock TypeScript
      ( Dict.fromList
        [ (0, Deletion), (1, Addition)
        ]
      )
      Dict.empty []
      """
alert(text.toUpperCase());
alert(text?.toUpperCase() ?? "(text was null)");
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with Python, an explicit check for "
          , syntaxHighlightedCodeSnippet TypeScript "null"
          , text " ("
          , syntaxHighlightedCodeSnippet TypeScript "text !== null"
          , text ") is required before the value is access. "
          ]
        , div [] [ codeBlock1 ]
        , p []
          [ text "However, TypeScript also offers syntactic sugar to simplify nullable value access:"
          ]
        , div [] [ codeBlock2 ]
        ]
      )
    )
  }


safeScalaNullableInvalid : UnindexedSlideModel
safeScalaNullableInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala Dict.empty
      ( Dict.fromList [ (2, [ ColumnEmphasis Error 8 19 ] ) ] )
      [ CodeBlockError 2 5
        [ div []
          [ text """value toUpperCase is not a member of Option[String]""" ]
        ]
      ]
      """
val textOpt: Option[String] = None

println(textOpt.toUpperCase)
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Scala achieves null-safety using the "
          , syntaxHighlightedCodeSnippet Scala "_: Option[+A]"
          , text " type in its standard library:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "As it is a different type, its content cannot be accessed directly."
          ]
        ]
      )
    )
  }


safeScalaNullable : UnindexedSlideModel
safeScalaNullable =
  let
    codeBlock1 : Html msg
    codeBlock1 =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList
        [ (2, Deletion), (3, Addition), (4, Addition)
        ]
      )
      Dict.empty []
      """
val textOpt: Option[String] = None

println(textOpt.toUpperCase)
textOpt.foreach { (text: String) => println(text.toUpperCase) }
"""

    codeBlock2 : Html msg
    codeBlock2 =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
val textOpt: Option[String] = None

println(textOpt.map(_.toUpperCase).getOrElse("(text was null)"))
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Scala achieves null-safety using the "
          , syntaxHighlightedCodeSnippet Scala "_: Option[+A]"
          , text " type in its standard library:"
          ]
        , div [] [ codeBlock1 ]
        , p []
          [ text "It has a very expressive API, allowing for succinct code:"
          ]
        , div [] [ codeBlock2 ]
        ]
      )
    )
  }


safeScalaNullableFun : UnindexedSlideModel
safeScalaNullableFun =
  let
    codeBlockFun : Html msg
    codeBlockFun =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
val textOpt: Option[String] = Some("xyz")
val numsByText: Map[String,Int] = Map("xyz" -> 42)

val num: Option[Int] =
  textOpt.flatMap { numsByText.get }.map { _ * 2 }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Scala "
          , syntaxHighlightedCodeSnippet Scala "_: Option[+A]"
          , text "s are consistent with other Scala container types, leading to powerful, and familiar, usage patterns:"
          ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlockFun ]
        ]
      )
    )
  }


safeScalaNullableFor : UnindexedSlideModel
safeScalaNullableFor =
  let
    codeBlockFun : Html msg
    codeBlockFun =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList
        [ (4, Deletion), (5, Addition), (6, Addition), (7, Addition), (8, Addition)
        ]
      )
      Dict.empty []
      """
val textOpt: Option[String] = Some("xyz")
val numsByText: Map[String,Int] = Map("xyz" -> 42)

val num: Option[Int] =
  textOpt.flatMap { numsByText.get }.map { _ * 2 }
  for
    text: String <- textOpt
    mapped: Int <- numsByText.get(text)
  yield mapped * 2
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Or if you prefer "
          , syntaxHighlightedCodeSnippet Scala "for"
          , text "-comprehensions:"
          ]
        , div [] [] -- Skip transition animation
        , div [] [ codeBlockFun ]
        , p []
          [ text "It is also possible to nest them "
          , syntaxHighlightedCodeSnippet Scala ": Option[Option[String]]"
          , text ", if needed."
          ]
        ]
      )
    )
  }


unsafeScala : UnindexedSlideModel
unsafeScala =
  let
    codeBlock1 : Html msg
    codeBlock1 =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
val text: String = null
println(text.toUpperCase) // NullPointerException!
"""

    codeBlock2 : Html msg
    codeBlock2 =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
val textOpt: Option[String] = None
println(textOpt.orNull.toUpperCase) // NullPointerException!
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Unfortunately, for compatibility with Java, all references can be "
          , syntaxHighlightedCodeSnippet Scala "null"
          , text ":"
          ]
        , div [] [ codeBlock1 ]
        , p []
          [ text "And "
          , syntaxHighlightedCodeSnippet Scala "_: Option[+A]"
          , text "s can be converted to their unsafe-equivalents:"
          ]
        , div [] [ codeBlock2 ]
        , p []
          [ text "Though with the "
          , syntaxHighlightedCodeSnippet XML "-Yexplicit-nulls"
          , text " compiler flag, new to Scala 3, the above do not compile."
          ]
        ]
      )
    )
  }


safeKotlinNullable : UnindexedSlideModel
safeKotlinNullable =
  let
    codeBlock1 : Html msg
    codeBlock1 =
      syntaxHighlightedCodeBlock Kotlin Dict.empty Dict.empty []
      """
val text: String? = null

if (text != null) println(text.uppercase())
"""

    codeBlock2 : Html msg
    codeBlock2 =
      syntaxHighlightedCodeBlock Kotlin Dict.empty Dict.empty []
      """
val text: String? = null

println(text?.uppercase() ?: "(text was null)")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Kotlin shares all of TypeScript’s null safety features. "
          , text "The primary difference is syntax, to designate a type as optional in Kotlin, "
          , text "a question mark "
          , syntaxHighlightedCodeSnippet Kotlin "?"
          , text " is appended to the type annotation:"
          ]
        , div [] [ codeBlock1 ]
        , p []
          [ text "Like TypeScript, there’s syntactic sugar to make things more succinct:"]
        , div [] [ codeBlock2 ]
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
val text: String? = null

println(text!!.uppercase())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Unfortunately, Kotlin does offer a non-null assertion operator ("
          , syntaxHighlightedCodeSnippet Kotlin "!!"
          , text "). "
          , text "Per Kotlin documentation, it is for “NullPointerException-lovers”:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftNullable : UnindexedSlideModel
safeSwiftNullable =
  let
    codeBlock1 : Html msg
    codeBlock1 =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
let text: String? = nil

if let text = text {
    print(text.uppercased())
}
"""

    codeBlock2 : Html msg
    codeBlock2 =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
let text: String? = nil

print(text?.uppercased() ?? "(text was nil)")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift and Kotlin’s null safety syntax differs only subtly:"
          ]
        , div [] [ codeBlock1 ]
        , p []
          [ text "Swift’s sugared null safe access is identical to TypeScript’s:"
          ]
        , div [] [ codeBlock2 ]
        ]
      )
    )
  }


safeSwiftNullableFun : UnindexedSlideModel
safeSwiftNullableFun =
  let
    codeBlockFun : Html msg
    codeBlockFun =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
let text: String? = "xyz"
let numsByText: [String: Int] = [ "xyz": 42 ]
let num: Int? = text
    .flatMap { numsByText[$0] }
    .map { $0 * 2 }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Because Swift’s nilable types are really implemented as "
          , syntaxHighlightedCodeSnippet Swift "_: Optional<Wrapped>"
          , text "s, they can be chained in a functional way:"
          ]
        , div [] [ codeBlockFun ]
        , p []
          [ text "It is also possible to nest them "
          , syntaxHighlightedCodeSnippet Swift ": String??"
          , text ", should the need arise."
          ]
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
let text: String? = nil
print(text!.uppercased())

let unsafeText: String! = nil
print(unsafeText.uppercased())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Now the bad news: Like Kotlin, Swift offers unsafe nil access. "
          , text "In fact, it offers 2 options."
          ]
        , p []
          [ text "There’s arguably no reason to use them these days, but they are there:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmNonNull : UnindexedSlideModel
safeElmNonNull =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm Dict.empty Dict.empty []
      """
module NullSafety exposing (..)

text : String
text = "Lorem Ipsum"

upperText : String
upperText = String.toUpper text
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Elm does not have the concept of null, everything must have a value. In this example, "
          , syntaxHighlightedCodeSnippet Elm "text"
          , text " "
          , em [] [ text "must" ]
          , text " be assigned a valid string:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmNullableInvalid : UnindexedSlideModel
safeElmNullableInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList
        [ (2, Deletion), (3, Deletion), (4, Addition), (5, Addition)
        ]
      )
      ( Dict.fromList [ (8, [ ColumnEmphasis Error 27 4 ] ) ] )
      [ CodeBlockError 5 32
        [ div []
        [ div []
          [ text "The 1st argument to "
          , code [] [ text "toUpper" ]
          , text " is not what I expect:"
          ]
        , div []
          [ text "This "
          , code [] [ text "text" ]
          , text " value is a: Maybe String"
          ]
        , div []
          [ text "But "
          , code [] [ text "toUpper" ]
          , text " needs the 1st argument to be: String"
          ]
        , div []
          [ u [] [ text "Hint" ]
          , text ": Use "
          , code [] [ text "Maybe.withDefault" ]
          , text " to handle possible errors. Longer term, it is"
          , text " usually better to write out the full "
          , code [] [ text "case" ]
          , text " though!"
          ]
        ]
        ]
      ]
      """
module NullSafety exposing (..)

text : String
text = "Lorem Ipsum"
text : Maybe String
text = Nothing

upperText : String
upperText = String.toUpper text
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
          [ text "Elm represents values that may be absent by wrapping them in a "
          , syntaxHighlightedCodeSnippet Elm "Maybe T"
          , text ". In this case, the values may no longer be accessed without first unwrapping them:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmNullable : UnindexedSlideModel
safeElmNullable =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList
        [ (6, Deletion), (7, Addition), (8, Addition), (9, Addition)
        ]
      )
      Dict.empty []
      """
module NullSafety exposing (..)

text : Maybe String
text = Nothing

upperText : String
upperText = String.toUpper text
upperText = case text of
  Just val -> String.toUpper val
  Nothing -> "(text was absent)"
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "The Elm compiler knows that a "
          , syntaxHighlightedCodeSnippet Elm "Maybe"
          , text " may have two possible values ("
          , syntaxHighlightedCodeSnippet Elm "Just _"
          , text " or "
          , syntaxHighlightedCodeSnippet Elm "Nothing"
          , text ") and requires programmers to account for both:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmNullableFun : UnindexedSlideModel
safeElmNullableFun =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList
        [ (6, Deletion), (7, Deletion), (8, Deletion), (9, Addition), (10, Addition), (11, Addition)
        ]
      )
      Dict.empty []
      """
module NullSafety exposing (..)

text : Maybe String
text = Nothing

upperText : String
upperText = case text of
  Just val -> String.toUpper val
  Nothing -> "(text was absent)"
upperText = text
  |> Maybe.map String.toUpper
  |> Maybe.withDefault "(text was absent)"
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "The same thing can also be accomplished using "
          , syntaxHighlightedCodeSnippet Elm "Maybe"
          , text " functions:"
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
          [ text "Elm does not allow the programmer to get around null safety." ]
        ]
      )
    )
  }
