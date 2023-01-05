module Deck.Slide.ExceptionSafety exposing
  ( introduction
  , introGo, unsafeGoExplicit, unsafeGoVariableReuse
  , unsafePython, unsafePythonRun, safePython, safePythonInvalid
  , unsafeTypeScript, safeTypeScript, safeTypeScriptInvalid
  , unsafeKotlin, safeKotlin, safeKotlinInvalid
  , safeSwift, safeSwiftInvalid, safeSwiftInvocation, unsafeSwift
  , safeSwiftMonadic, safeSwiftMonadicInvalid
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, div, em, p, text)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Exception Safety"

subheadingGo : String
subheadingGo = "Go Is Not Exception Safe"

subheadingPython : String
subheadingPython = "Python Is Not Exception Safe (But Can Be Made Safer)"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Is Not Exception Safe (But Can Be Made Safer)"

subheadingKotlin : String
subheadingKotlin = "Kotlin Is Not Exception Safe (But Includes a Safer Option)"

subheadingSwift : String
subheadingSwift = "Swift Is Exception Safe (With Options to Be Unsafe)"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Prevents Unhandled Recoverable Exceptions"
      ( div []
        [ p []
          [ text "Programs don’t always run according to plan - errors occur."
          ]
        , p []
          [ text "Some errors are recoverable: "
          , text "Users providing invalid input "
          , text "(Recover by rejecting the input and re-prompting the user)."
          ]
        , p []
          [ text "Some are clearly not: When the system is out of memory."
          ]
        , p []
          [ text "Exception safe languages require the programmer to "
          , mark [] [ text "handle all recoverable errors" ]
          , text "."
          ]
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
package url
...
func QueryUnescape(s string) (string, error)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Go’s convention for error-handling is to return the success value "
          , em [] [ text "and" ]
          , text " the error:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeGoExplicit : UnindexedSlideModel
unsafeGoExplicit =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
      """
package main
import "net/url"

func main() {
    url, _ := url.QueryUnescape("bad%url") // error ignored!
    println(url) // let’s hope 0-value is OK!
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "In this example, the error from the "
          , syntaxHighlightedCodeSnippet Go "url.QueryUnescape(...)"
          , text " call is ignored, and the program just continues with the zero-value for "
          , syntaxHighlightedCodeSnippet Go "url"
          , text "." ]
        , div [] [ codeBlock ]
        , p []
          [ text "This is a minimal and contrived example, and if anything, "
          , text "it does shows one of the strengths of Go - you have to explicitly assign the error to "
          , syntaxHighlightedCodeSnippet Go "_"
          , text " to ignore it..."
          ]
        ]
      )
    )
  }


unsafeGoVariableReuse : UnindexedSlideModel
unsafeGoVariableReuse =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Go
      ( Dict.fromList
        [ (4, Deletion), (5, Addition), (6, Addition), (7, Addition)
        , (8, Deletion), (9, Addition)
        ]
      )
      Dict.empty []
      """
package main
import "strconv"

func main() {
    url, _ := url.QueryUnescape("bad%url") // error ignored!
    url1, err := url.QueryUnescape("good%20enough%21")
    if err != nil { return }
    url2, err := url.QueryUnescape("bad%url")
    println(url) // let’s hope 0-value is OK!
    println(url1, "\\n", url2)
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "...The real problem arises when the error variable is re-used, and accidentally ignored:" ]
        , div [] [ codeBlock ]
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
from urllib.parse import unquote

url: str = unquote("bad%c3url", errors="strict")
print(url)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Any function can raise an exception, you are never required to check for it:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "This program type checks..."
          ]
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
        [ p []
          [ text "...but fails at runtime:"
          ]
        , console
          """
% python exception_safety/unsafe.py
Traceback (most recent call last):
  File "/strongly-typed/exception_safety/unsafe.py", line 3, in <module>
    url: str = unquote("bad%c3url", errors="strict")
  File "/usr/local/lib/python3.10/urllib/parse.py", line 667, in unquote
    append(unquote_to_bytes(bits[i]).decode(encoding, errors))
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xc3 in position 3:
 invalid continuation byte
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
from urllib.parse import unquote

def safe_unquote(quoted: str) -> str | Exception:
    try:
        return unquote(quoted, errors="strict")
    except Exception as e:
        return e

unquoted_or_err: str | Exception = safe_unquote("bad%c3url")
if not isinstance(unquoted_or_err, Exception):
    print(unquoted_or_err.lower())
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Python can be made exception safe by returning the exception instead of raising:"
          ]
        , div [] [ codeBlock ]
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
      ( Dict.fromList [ (9, Deletion) ] )
      ( Dict.fromList [ (10, [ ColumnEmphasis Error 22 7 ] ) ] )
      [ CodeBlockError 10 20
        [ div []
          [ text """Cannot access member "lower" for type "Exception" """ ]
        ]
      ]
      """
from urllib.parse import unquote

def safe_unquote(quoted: str) -> str | Exception:
    try:
        return unquote(quoted, errors="strict")
    except Exception as e:
        return e

unquoted_or_err: str | Exception = safe_unquote("bad%c3url")
if not isinstance(unquoted_or_err, Exception):
print(unquoted_or_err.lower())
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Python can be made exception safe by returning the exception instead of raising:"
          ]
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
const url: string = decodeURI("bad%url");
console.log(url);
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Any function can throw an exception, you are never required to check for it:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "This program compiles, but fails at runtime:"
          ]
        , console
          """
% jsc exception_safety/unsafe.js
Exception: URIError: URI error
decodeURI@[native code]
global code@exception_safety/unsafe.js:1:20
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
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
function safeDecodeURI(encodedURI: string): string | Error {
  try {
    return decodeURI(encodedURI);
  } catch (e: any) {
    return e instanceof Error ? e : Error(e);
  }
}
const urlOrErr: string | Error = safeDecodeURI("bad%url");
if (urlOrErr instanceof string)
  console.log(urlOrErr.toLowerCase());
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "As with Python, you can return the exception instead of throwing it:"
          ]
        , div [] [ codeBlock ]
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
      ( Dict.fromList [ (8, Deletion) ] )
      ( Dict.fromList [ (9, [ ColumnEmphasis Error 21 13 ] ) ] )
      [ CodeBlockError 9 20
        [ div []
          [ text "TS2339: Property 'toLowerCase' does not exist on type 'string | Error'." ]
        ]
      ]
      """
function safeDecodeURI(encodedURI: string): string | Error {
  try {
    return decodeURI(encodedURI);
  } catch (e: any) {
    return e instanceof Error ? e : Error(e);
  }
}
const urlOrErr: string | Error = safeDecodeURI("bad%url");
if (urlOrErr instanceof string)
console.log(urlOrErr.toLowerCase());
\xAD
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "The use of union types ensures that success and error conditions are accounted for:"
          ]
        , div [] [] -- Skip transition animation
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
val url: String = java.net.URLDecoder.decode("bad%url", "UTF-8")
println(url)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Exceptions are unchecked, any function can throw one:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "This program compiles, but crashes at runtime:"
          ]
        , console
          """
% kotlinc -script unsafe.kts
java.lang.IllegalArgumentException: URLDecoder: Illegal hex characters in
escape (%) pattern - Error at index 0 in: "ur"
    at java.base/java.net.URLDecoder.decode(URLDecoder.java:239)
    at java.base/java.net.URLDecoder.decode(URLDecoder.java:149)
    at Exception_unsafe.<init>(exception_unsafe.kts:3)"""
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
fun safeDecodeUrl(s: String, enc: String): Result<String> =
    Result.runCatching { java.net.URLDecoder.decode(s, enc) }

val urlRes: Result<String> = safeDecodeUrl("bad%url", "UTF-8")
urlRes.fold(
    onSuccess = { println(it) },
    onFailure = { println("Unable to decode URL") },
)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "However, it provides an exception safe option, in the form of "
          , syntaxHighlightedCodeSnippet Kotlin "_: Result<T>"
          , text ":"
          ]
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
      ( Dict.fromList [ (6, Deletion) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 0 1 ] ) ] )
      [ CodeBlockError 6 1
        [ div [] [ text "no value passed for parameter 'onFailure'" ] ]
      ]
      """
fun safeDecodeUrl(s: String, enc: String): Result<String> =
    Result.runCatching { java.net.URLDecoder.decode(s, enc) }

val urlRes: Result<String> = safeDecodeUrl("bad%url", "UTF-8")
urlRes.fold(
    onSuccess = { println(it) },
    onFailure = { println("Unable to decode URL") },
)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Not accounting for the failure case results in a compile error:"
          ]
        , div [] [] -- No transition
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
import Foundation

func decodeUri(_ encodedUri: String) throws -> String {
    guard let url = encodedUri.removingPercentEncoding else {
        throw NSError()
    }
    return url
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "In fact, it pretty much nails exception handling. Twice. "
          , text "Functions that can throw exceptions must be declared with the "
          , syntaxHighlightedCodeSnippet Swift "throws"
          , text " keyword:"
          ]
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
      ( Dict.fromList [ (2, Deletion), (3, Addition) ] )
      ( Dict.fromList [ (5, [ ColumnEmphasis Error 8 15 ] ) ] )
      [ CodeBlockError 5 12
        [ div []
          [ text "error is not handled because the enclosing function is not declared 'throws'" ]
        ]
      ]
      """
import Foundation

func decodeUri(_ encodedUri: String) throws -> String {
func decodeUri(_ encodedUri: String) -> String {
    guard let url = encodedUri.removingPercentEncoding else {
        throw NSError()
    }
    return url
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Removing "
          , syntaxHighlightedCodeSnippet Swift "throws"
          , text " results in a compile error:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftInvocation : UnindexedSlideModel
safeSwiftInvocation =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift Dict.empty
      ( Dict.fromList [ (0, [ ColumnEmphasis Error 19 20 ] ) ] )
      [ CodeBlockError 0 19
        [ div []
          [ text "call can throw but is not marked with 'try'" ]
        ]
      ]
      """
let url1: String = decodeUri("bad%url")

let url2: String? = try? decodeUri("bad%url")

let url3: String
do {
    url3 = try decodeUri("bad%url")
} catch {
    url3 = "http://stackoverflow.com"
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "The compiler makes you handle errors that may arise from a "
          , syntaxHighlightedCodeSnippet Swift "throws"
          , text " function:"
          ]
        , div [] [] -- No transition
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
let url String = try! decodeUri("bad%url") // Crash! 💥
print(url)
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift however, does provide an unsafe escape hatch by means of "
          , syntaxHighlightedCodeSnippet Swift "try!"
          , text ". This is for converting a recoverable error to an unrecoverable error:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "Which compiles, but fails at runtime:"
          ]
        , console
          """
% swift run exception_safety
Build complete! (0.13s)
zsh: illegal hardware instruction  swift run exception_safety
"""
        ]
      )
    )
  }


safeSwiftMonadic : UnindexedSlideModel
safeSwiftMonadic =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
let urlRes: Result<String, Error> = Result {
    try decodeUri("bad%url")
}

switch urlRes {
case .success(let url): print(url)
case .failure(_): print("Unable to decode URI")
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift also has a "
          , syntaxHighlightedCodeSnippet Swift "_: Result<Success, Failure>"
          , text " just like Kotlin’s:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftMonadicInvalid : UnindexedSlideModel
safeSwiftMonadicInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList [ (6, Deletion) ] )
      ( Dict.fromList [ (4, [ ColumnEmphasis Error 0 6 ] ) ] )
      [ CodeBlockError 3 15
        [ div []
          [ text "switch must be exhaustive" ]
        ]
      ]
      """
let urlRes: Result<String, Error> = Result {
    try decodeUri("bad%url")
}

switch urlRes {
case .success(let url): print(url)
case .failure(_): print("Unable to decode URI")
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Failing to account for both success and failure cases result in a compile error:"
          ]
        , div [] [] -- No transition
        , div [] [ codeBlock ]
        ]
      )
    )
  }
