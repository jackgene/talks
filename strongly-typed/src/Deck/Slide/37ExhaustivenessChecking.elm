module Deck.Slide.ExhaustivenessChecking exposing
  ( introduction
  , unsafeGoPrep, unsafeGo
  , safePython, safePythonInvalid
  , safeTypeScript, safeTypeScriptInvalid
  , safeKotlin, safeKotlinInvalid
  , safeSwiftPrep, safeSwift, safeSwiftInvalid, safeSwiftAlt
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
heading = TypeSystemProperties.heading ++ ": Exhaustiveness Checking"

subheadingGo : String
subheadingGo = "Go Does Not Have Exhaustiveness Checking"

subheadingPython : String
subheadingPython = "Python Can Have Exhaustiveness Checking"

subheadingTypeScript : String
subheadingTypeScript = "TypeScript Can Have Exhaustiveness Checking"

subheadingKotlin : String
subheadingKotlin = "Kotlin Can Have Exhaustiveness Checking"

subheadingSwift : String
subheadingSwift = "Swift Can Have Exhaustiveness Checking"


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
func (_ Active) isStatus() {}

type Inactive struct{}
func (_ Inactive) isStatus() {}
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
      [ CodeBlockError 8 0
        [ div []
          [ text "missing return at end of function" ]
        ]
      ]
      """
package exhaustiveness
import "strongly-typed-go/exhaustiveness/status"

func DoWork(s status.AccountStatus) string {
    switch s.(type) {
    case status.Active: return "Perform API calls, ..."
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
        case AccountStatus.Active: print("Perform API calls, ...")
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
        case AccountStatus.Active: print("Perform API calls, ...")
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
    case AccountStatus.ACTIVE: return "Perform API calls, ...";
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
    case AccountStatus.ACTIVE: return "Perform API calls, ...";
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
        AccountStatus.Active -> "Perform API calls, ..."
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
        AccountStatus.Active -> "Perform API calls, ..."
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
    case myrx
    case gold
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
    case (.active, .myrx): return "Perform MyRx API calls, ..."
    case (.active, .gold): return "Perform Gold API calls, ..."
    case (.inactive, .myrx): return "Skipping..."
    case (.inactive, .gold): return "Skipping..."
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
          [ text "switch must be exhaustive: add missing case: '(.inactive, .gold)"
          ]
        ]
      ]
      """
func doWork(status: Status, membership: Membership) -> String {
    switch (status, membership) {
    case (.active, .myrx): return "Perform MyRx API calls, ..."
    case (.active, .gold): return "Perform Gold API calls, ..."
    case (.inactive, .myrx): return "Skipping..."
    case (.inactive, .gold): return "Skipping..."
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
    case (.active, .myrx): return "Perform MyRx API calls, ..."
    case (.active, .gold): return "Perform Gold API calls, ..."
    case (.inactive, .myrx): return "Skipping..."
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
