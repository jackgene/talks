module Deck.Slide.ExhaustivenessChecking exposing
  ( introduction
  , unsafeGoPrep, unsafeGo
  , safePython, safePythonInvalid, unsafePython
  , safeTypeScript, safeTypeScriptInvalid
  , safeScalaPrep, safeScala, safeScalaInvalid, safeScalaAlt, unsafeScala
  , safeKotlin, safeKotlinInvalid
  , safeSwiftPrep, safeSwift, safeSwiftInvalid, safeSwiftAlt
  , safeElm, safeElmInvalid, safeElmAlt, unsafeElm
  )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Deck.Slide.TypeSystemProperties as TypeSystemProperties
import Dict exposing (Dict)
import Html.Styled exposing (Html, br, code, div, em, p, text, u)
import SyntaxHighlight.Model exposing
  ( ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..) )


-- Constants
heading : String
heading = TypeSystemProperties.heading ++ ": Exhaustiveness Checking"

subheadingGo : String
subheadingGo = "Go Does Not Have Exhaustiveness Checking"

subheadingPython : String
subheadingPython = "Python Can Have Exhaustiveness Checking"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Have Exhaustiveness Checking"

subheadingScala : String
subheadingScala = "Scala Can Have Exhaustiveness Checking"

subheadingKotlin : String
subheadingKotlin = "Kotlin Can Have Exhaustiveness Checking"

subheadingSwift : String
subheadingSwift = "Swift Can Have Exhaustiveness Checking"

subheadingElm : String
subheadingElm = "Elm Can Have Exhaustiveness Checking"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading
      "Ensures All Program State Transitions Are Accounted For"
      ( div []
        [ p []
          [ text "A computer program can be thought of as a series of state transitions." ]
        , p []
          [ text "Languages that check for exhaustiveness require the programmer to "
          , mark [] [ text "account for all possible states" ]
          , text ", when performing transitions between states."
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
package status

type AccountStatus interface {
    isStatus()
}

type Active struct{}
func (_ Active)\xA0isStatus() {}

type Inactive struct{}
func (_ Inactive)\xA0isStatus() {}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingGo
      ( div []
        [ p []
          [ text "Consider the following "
          , em [] [ text "sealed" ]
          , text " interface, with two possible implementations:"
          ]
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
      syntaxHighlightedCodeBlock Go Dict.empty
      ( Dict.fromList [ (8, [ ColumnEmphasis Error 0 1 ] ) ] )
      [ CodeBlockError 7 1
        [ div [] [ text "missing return at end of function" ] ]
      ]
      """
package exhaustiveness
import "strongly-typed-go/exhaustiveness/status"

func DoWork(s status.AccountStatus) string {
    switch s.(type) {
    case status.Active: return "Perform API calls..."
    case status.Inactive: return "Skipping processing..."
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
          [ text "Even though the "
          , syntaxHighlightedCodeSnippet Go "switch"
          , text " accounts for both values, the Go compiler is not satisfied:"
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
      syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
from enum import Enum

class AccountStatus(Enum):
    Active = 1
    Inactive = 2

def do_work(status: AccountStatus):
    match status:
        case AccountStatus.Active: print("Perform API calls...")
        case AccountStatus.Inactive: print("Skipping...")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Some Python type checkers are able to determine when a "
          , syntaxHighlightedCodeSnippet Python "match"
          , text " is exhaustive:"
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
      ( Dict.fromList [ (5, Addition) ] )
      ( Dict.fromList [ (8, [ ColumnEmphasis Error 10 6 ] ) ] )
      [ CodeBlockError 6 18
        [ div []
          [ text "Cases within match statement do not exhaustively handle all values"
          , br [] []
          , text """\xA0\xA0Unhandled type: "Literal[AccountStatus.Terminated]" """
          , br [] []
          , text """\xA0\xA0If exhaustive handling is not intended, add "case _: pass" """
          ]
        ]
      ]
      """
from enum import Enum

class AccountStatus(Enum):
    Active = 1
    Inactive = 2
    Terminated = 3

def do_work(status: AccountStatus):
    match status:
        case AccountStatus.Active: print("Perform API calls...")
        case AccountStatus.Inactive: print("Skipping...")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "When a value is added to the "
          , syntaxHighlightedCodeSnippet Python "Enum"
          , text ", inexhaustive "
          , syntaxHighlightedCodeSnippet Python "match"
          , text "es fail immediately:"
          ]
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
      syntaxHighlightedCodeBlock Python
      ( Dict.fromList [ (10, Deletion), (11, Addition) ] )
      Dict.empty []
      """
from enum import Enum

class AccountStatus(Enum):
    Active = 1
    Inactive = 2
    Terminated = 3

def do_work(status: AccountStatus):
    match status:
        case AccountStatus.Active: print("Perform API calls...")
        case AccountStatus.Inactive: print("Skipping...")
        case _: print("Skipping...")
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingPython
      ( div []
        [ p []
          [ text "Unfortunately, wildcard matches effectively defeats exhaustiveness checking:"
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
      syntaxHighlightedCodeBlock TypeScript Dict.empty Dict.empty []
      """
enum AccountStatus {
  ACTIVE,
  INACTIVE,
}
function doWork(status: AccountStatus): string {
  switch(status) {
    case AccountStatus.ACTIVE: return "Perform API calls...";
    case AccountStatus.INACTIVE: return "Skipping...";
  }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "The TypeScript compiler is able to determine when code flow is exhaustive:"
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
      ( Dict.fromList [ (3, Addition) ] )
      ( Dict.fromList [ (5, [ ColumnEmphasis Error 40 6 ] ) ] )
      [ CodeBlockError 3 13
        [ div []
          [ text "TS2366: Function lacks ending return statement and return type does not include 'undefined'."
          ]
        ]
      ]
      """
enum AccountStatus {
  ACTIVE,
  INACTIVE,
  TERMINATED,
}
function doWork(status: AccountStatus): string {
  switch(status) {
    case AccountStatus.ACTIVE: return "Perform API calls...";
    case AccountStatus.INACTIVE: return "Skipping...";
  }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingTypeScript
      ( div []
        [ p []
          [ text "Adding new "
          , syntaxHighlightedCodeSnippet TypeScript "enum"
          , text " values make existing "
          , syntaxHighlightedCodeSnippet TypeScript "switch"
          , text "es inexhaustive:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeScalaPrep : UnindexedSlideModel
safeScalaPrep =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
enum Status:
  case Active, Inactive

enum Membership:
  case Basic, Premium
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Scala’s exhaustiveness checking is more comprehensive, consider these "
          , syntaxHighlightedCodeSnippet Scala "enum"
          , text "s:"
          ]
        , div [] [ codeBlock ]
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
import Status._
import Membership._

def doWork(status: Status, membership: Membership): String =
  (status, membership) match
    case (Active, Basic) => "Perform basic API calls..."
    case (Active, Premium) => "Perform premium API calls..."
    case (Inactive, Basic) => "Skipping..."
    case (Inactive, Premium) => "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "The Scala compiler is able to check for exhaustiveness even across "
          , syntaxHighlightedCodeSnippet Scala "enum"
          , text " combinations:"
          ]
        , div [] [] -- Skip transition animation
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
      ( Dict.fromList [ (8, Deletion) ] )
      ( Dict.fromList [ (4, [ ColumnEmphasis Warning 2 20 ] ) ] )
      [ CodeBlockError 3 29
        [ div [] [ text "match may not be exhaustive." ]
        , div [] [ text "It would fail on pattern case: (Inactive, Premium)" ]
        ]
      ]
      """
import Status._
import Membership._

def doWork(status: Status, membership: Membership): String =
  (status, membership) match
    case (Active, Basic) => "Perform basic API calls..."
    case (Active, Premium) => "Perform premium API calls..."
    case (Inactive, Basic) => "Skipping..."
    case (Inactive, Premium) => "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "Removing a "
          , syntaxHighlightedCodeSnippet Scala "case"
          , text " in the "
          , syntaxHighlightedCodeSnippet Scala "match"
          , text " results in a compile warning:"
          ]
        , div [] [ codeBlock ]
        , p []
          [ text "Scala compiler warnings can be upgraded to errors using "
          , syntaxHighlightedCodeSnippet XML "-Xfatal-warnings"
          , text "."
          ]
        ]
      )
    )
  }


safeScalaAlt : UnindexedSlideModel
safeScalaAlt =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Scala
      ( Dict.fromList [ (7, Deletion), (8, Addition) ] )
      Dict.empty []
      """
import Status._
import Membership._

def doWork(status: Status, membership: Membership): String =
  (status, membership) match
    case (Active, Basic) => "Perform basic API calls..."
    case (Active, Premium) => "Perform premium API calls..."
    case (Inactive, Basic) => "Skipping..."
    case (Inactive, _) => "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "The Scala compiler accounts for wildcards when checking exhaustiveness:" ]
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
      ( Dict.fromList [ (7, Deletion), (8, Addition) ] )
      Dict.empty []
      """
import Status._
import Membership._

def doWork(status: Status, membership: Membership): String =
  (status, membership) match
    case (Active, Basic) => "Perform basic API calls..."
    case (Active, Premium) => "Perform premium API calls..."
    case (Inactive, _) => "Skipping..."
    case _ => "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingScala
      ( div []
        [ p []
          [ text "As with Python however, wildcards defeat exhaustiveness checking, and should not be used excessively:" ]
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
enum class AccountStatus {
    Active,
    Inactive,
}

fun doWork(status: AccountStatus): String =
    when(status) {
        AccountStatus.Active -> "Perform API calls..."
        AccountStatus.Inactive -> "Skipping..."
    }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "The Kotlin compiler is able to determine when a "
          , syntaxHighlightedCodeSnippet Kotlin "when"
          , text " match is exhaustive:"
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
      ( Dict.fromList [ (3, Addition) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 4 4 ] ) ] )
      [ CodeBlockError 6 19
        [ div []
          [ text "'when' expression must be exhaustive, add necessary 'Terminated' branch or 'else' branch instead"
          ]
        ]
      ]
      """
enum class AccountStatus {
    Active,
    Inactive,
    Terminated,
}

fun doWork(status: AccountStatus): String =
    when(status) {
        AccountStatus.Active -> "Perform API calls..."
        AccountStatus.Inactive -> "Skipping..."
    }
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingKotlin
      ( div []
        [ p []
          [ text "Inexhaustive matches do not compile:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftPrep : UnindexedSlideModel
safeSwiftPrep =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
enum Status {
    case active
    case inactive
}

enum Membership {
    case basic
    case premium
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Swift’s exhaustiveness checking is more comprehensive, consider these "
          , syntaxHighlightedCodeSnippet Swift "enum"
          , text "s:"
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
      syntaxHighlightedCodeBlock Swift Dict.empty Dict.empty []
      """
func doWork(status: Status, membership: Membership) -> String {
    switch (status, membership) {
    case (.active, .basic): return "Perform basic API calls..."
    case (.active, .premium): return "Perform premium API calls..."
    case (.inactive, .basic): return "Skipping..."
    case (.inactive, .premium): return "Skipping..."
    }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "The Swift compiler is able to check for exhaustiveness even across "
          , syntaxHighlightedCodeSnippet Swift "enum"
          , text " combinations:"
          ]
        , div [] [] -- Skip transition animation
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
      ( Dict.fromList [ (5, Deletion) ] )
      ( Dict.fromList [ (1, [ ColumnEmphasis Error 4 6 ] ) ] )
      [ CodeBlockError 0 29
        [ div []
          [ text "switch must be exhaustive: add missing case: '(.inactive, .premium)"
          ]
        ]
      ]
      """
func doWork(status: Status, membership: Membership) -> String {
    switch (status, membership) {
    case (.active, .basic): return "Perform basic API calls..."
    case (.active, .premium): return "Perform premium API calls..."
    case (.inactive, .basic): return "Skipping..."
    case (.inactive, .premium): return "Skipping..."
    }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "Removing a "
          , syntaxHighlightedCodeSnippet Swift "case"
          , text " in the "
          , syntaxHighlightedCodeSnippet Swift "switch"
          , text " results in a compile error:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeSwiftAlt : UnindexedSlideModel
safeSwiftAlt =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Swift
      ( Dict.fromList [ (4, Deletion), (5, Addition) ] )
      Dict.empty []
      """
func doWork(status: Status, membership: Membership) -> String {
    switch (status, membership) {
    case (.active, .basic): return "Perform basic API calls..."
    case (.active, .premium): return "Perform premium API calls..."
    case (.inactive, .basic): return "Skipping..."
    case (.inactive, _): return "Skipping..."
    }
}
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingSwift
      ( div []
        [ p []
          [ text "The Swift compiler even accounts for wildcards when checking exhaustiveness:" ]
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
module Exhaustiveness exposing (..)

type Status = Active | Inactive
type Membership = Basic | Premium

doWork : Status -> Membership -> String
doWork status membership =
  case (status, membership) of
    (Active, Basic) -> "Perform basic API calls..."
    (Active, Premium) -> "Perform premium API calls..."
    (Inactive, Basic) -> "Skipping..."
    (Inactive, Premium) -> "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Exhaustivess is a fundamental aspect of Elm and is extremely comprehensive:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmInvalid : UnindexedSlideModel
safeElmInvalid =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList [ (11, Deletion) ] )
      ( Dict.fromList [ (7, [ ColumnEmphasis Error 2 4 ] ) ] )
      [ CodeBlockError 6 8
        [ div []
          [ text "This "
          , code [] [ text "case" ]
          , text " does not have branches for all possibilities:"
          ]
        , div []
          [ text "Missing possibilities include: "
          , code [] [ text "( Inactive, Premium )" ]
          ]
        , div []
          [ text "I would have to crash if I saw one of those. Add branches for them!"
          ]
        , div []
          [ u [] [ text "Hint" ]
          , text ": ..."
          ]
        ]
      ]
      """
module Exhaustiveness exposing (..)

type Status = Active | Inactive
type Membership = Basic | Premium

doWork : Status -> Membership -> String
doWork status membership =
  case (status, membership) of
    (Active, Basic) -> "Perform basic API calls..."
    (Active, Premium) -> "Perform premium API calls..."
    (Inactive, Basic) -> "Skipping..."
    (Inactive, Premium) -> "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "Removing a branch in the "
          , syntaxHighlightedCodeSnippet Elm "case"
          , text " results in a compile error:"
          ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


safeElmAlt : UnindexedSlideModel
safeElmAlt =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList [ (10, Deletion), (11, Addition) ] )
      Dict.empty []
      """
module Exhaustiveness exposing (..)

type Status = Active | Inactive
type Membership = Basic | Premium

doWork : Status -> Membership -> String
doWork status membership =
  case (status, membership) of
    (Active, Basic) -> "Perform basic API calls..."
    (Active, Premium) -> "Perform premium API calls..."
    (Inactive, Basic) -> "Skipping..."
    (Inactive, _) -> "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "The Elm compiler accounts for wildcards when checking exhaustiveness:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }


unsafeElm : UnindexedSlideModel
unsafeElm =
  let
    codeBlock : Html msg
    codeBlock =
      syntaxHighlightedCodeBlock Elm
      ( Dict.fromList [ (10, Deletion), (11, Addition) ] )
      Dict.empty []
      """
module Exhaustiveness exposing (..)

type Status = Active | Inactive
type Membership = Basic | Premium

doWork : Status -> Membership -> String
doWork status membership =
  case (status, membership) of
    (Active, Basic) -> "Perform basic API calls..."
    (Active, Premium) -> "Perform premium API calls..."
    (Inactive, _) -> "Skipping..."
    _ -> "Skipping..."
"""
  in
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheadingElm
      ( div []
        [ p []
          [ text "As with the other languages, wildcards should be used with care:" ]
        , div [] [ codeBlock ]
        ]
      )
    )
  }
