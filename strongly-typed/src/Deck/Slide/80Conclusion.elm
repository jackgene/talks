module Deck.Slide.Conclusion exposing
  ( introduction, enableStricterTypeChecking, codeGeneration, preCompileChecks, testing )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Dict exposing (Dict)
import Html.Styled exposing (Html, b, div, p, text, ul)


heading : String
heading = "Strong Typing & Quality Software"


introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Alternate Ways To Prevent Runtime Errors"
      ( div []
        [ ul []
          [ li [] [ text "Enable Stricter Type Checking" ]
          , li [] [ text "Use Code Generation" ]
          , li [] [ text "Additional Pre-compile Checks" ]
          , li [] [ text "Automated Testing" ]
          ]
        ]
      )
    )
  }


enableStricterTypeChecking : UnindexedSlideModel
enableStricterTypeChecking =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Enable Stricter Type Checking"
      ( div []
        [ p []
          [ text "Simplest solution: Have the compiler perform stricter type checks:"
          , ul []
            [ li []
              [ b [] [ text "Python" ]
              , text " - Different type checkers take different flags: "
              , ul []
                [ li []
                  [ text "mypy: "
                  , syntaxHighlightedCodeSnippet XML "--disallow-any-generics --disallow-untyped-calls ..."
                  ]
                , li []
                  [ text "Pyre: "
                  , syntaxHighlightedCodeSnippet XML "--strict"
                  ]
                , li []
                  [ text "Pyright: "
                  , syntaxHighlightedCodeSnippet TypeScript """ "typeCheckingMode": "strict" """
                  , text " in "
                  , syntaxHighlightedCodeSnippet XML "pyrightconfig.json"
                  ]
                ]
              ]
            , li []
              [ b [] [ text "TypeScript" ]
              , text " - "
              , syntaxHighlightedCodeSnippet XML "tsc --strict --noUncheckedIndexedAccess"
              ]
            ]
          ]
        ]
      )
    )
  }


codeGeneration : UnindexedSlideModel
codeGeneration =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Use Code Generation"
      ( div []
        [ p []
          [ text "Mainly for Go, using "
          , syntaxHighlightedCodeSnippet XML "go generate"
          , text "."
          ]
        , p []
          [ text "The Stringer tool ("
          , syntaxHighlightedCodeSnippet XML "golang.org/x/tools/cmd/stringer"
          , text ") generates the following function that forces a compile error should the original source change:"
          ]
        , syntaxHighlightedCodeBlock Go Dict.empty Dict.empty []
          """
func _() {
    // An "invalid array index" compiler error signifies that the
    // constant values have changed.
    // Re-run the stringer command to generate them again.
    var x [1]struct{}
    _ = x[Active-0]
    _ = x[Inactive-1]
}
"""
        ]
      )
    )
  }


preCompileChecks : UnindexedSlideModel
preCompileChecks =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Additional Pre-compile Checks"
      ( div []
        [ p []
          [ text "Linters and additional type checkers augment the type system:"
          , ul []
            [ li []
              [ text "golangci-lint (github.com/golangci/golangci-lint) highlights such issues as unhandled errors"
              ]
            , li []
              [ text "go-sumtype (github.com/BurntSushi/go-sumtype) adds exhaustiveness checking"
              ]
            , li []
              [ text "TypeScript ESLint’s "
              , syntaxHighlightedCodeSnippet XML "no-explicit-any"
              , text " rule disallows the use of "
              , syntaxHighlightedCodeSnippet TypeScript "any"
              ]
            , li []
              [ text "SwiftLint can disallow “force” operators: "
              , syntaxHighlightedCodeSnippet Swift "as!"
              , text ", "
              , syntaxHighlightedCodeSnippet Swift "try!"
              , text ", and unsafe unwraps"
              ]
            , li [] [ text "Static analysis tools find potential sources of bugs" ]
            ]
          ]
        ]
      )
    )
  }


testing : UnindexedSlideModel
testing =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Automated Testing"
      ( div []
        [ p [] [ text "The canonical way to find bugs before running a program." ]
        , p []
          [ text "Picks up where the type checker leaves off:"
          , ul []
            [ li []
              [ text "Always test "
              , syntaxHighlightedCodeSnippet Go "nil"
              , text " input to Go functions that take pointer parameters"
              ]
            , li []
              [ text "Always mock error conditions in dependencies, and verify that code under test handles them correctly" ]
            , li []
              [ text "Fuzz and property-based testing probabilistically catch corner case errors" ]
            ]
          ]
        ]
      )
    )
  }
