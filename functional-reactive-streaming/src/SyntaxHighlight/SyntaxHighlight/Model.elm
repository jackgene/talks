module SyntaxHighlight.Model exposing (..)

import Css exposing (Style)
import Dict exposing (Dict)


type alias Block = List Line


type alias Line =
  { tokens : List Token
  , emphasis : Maybe LineEmphasis
  , columnEmphases : List ColumnEmphasis
  }


type alias Token = ( TokenType, String )


type TokenType
  -- General
  = Normal
  | Comment
  | LineBreak
  -- Programming Language
  | Namespace
  | Keyword
  | DeclarationKeyword -- For backward compatibility
  | BuiltIn
  | Operator
  | LiteralNumber
  | LiteralString
  | LiteralKeyword
  | TypeDeclaration
  | TypeReference
  | FunctionDeclaration
  | FunctionReference
  | FunctionArgument
  | FieldDeclaration
  | FieldReference
  | Annotation
  -- Miscellaneous
  | Other String


{-| LineEmphasis type.

  - `Selected` will highlight the line in a way to differentiate it from the rest, like github's yellow background.
  - `Addition` will highlight in a manner that gives the ideia of new content added.
  - `Deleletion` will highlight in a manner that gives the ideia of removed content.

The specific styles will depend on the chosen `Theme`.

-}
type LineEmphasis
  = Selection
  | Addition
  | Deletion


type alias ColumnEmphasis =
  { emphasis : ColumnEmphasisType
  , start : Int
  , length : Int
  }


type ColumnEmphasisType
  = Error
  | Warning


type alias Theme =
  { default : Style
  , selection : Style
  , addition : Style
  , deletion : Style
  , error : Style
  , warning : Style
  , comment : Style
  , namespace : Style
  , keyword : Style
  , declarationKeyword : Style
  , builtIn : Style
  , operator : Style
  , number : Style
  , string : Style
  , literal : Style
  , typeDeclaration : Style
  , typeReference : Style
  , functionDeclaration : Style
  , functionReference : Style
  , functionArgument : Style
  , fieldDeclaration : Style
  , fieldReference : Style
  , annotation : Style
  , other : Dict String Style
  , gutter : Style
  }
