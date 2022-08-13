module SyntaxHighlight.Language.TypeScript exposing (parseTokensReversed)

import Parser exposing (Error, oneOf, symbol)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


typescript : CLikeCommon.Language
typescript =
  { functionDeclarationKeyword = "function"
  , keywords =
    Set.fromList
    -- JavaScript
    [ "break"
    , "case"
    , "catch"
    , "continue"
    , "debugger"
    , "default"
    , "delete"
    , "do"
    , "else"
    , "enum"
    , "export"
    , "extends"
    , "finally"
    , "for"
    , "if"
    , "implements"
    , "import"
    , "in"
    , "instanceof"
    , "interface"
    , "new"
    , "package"
    , "private"
    , "protected"
    , "public"
    , "return"
    , "switch"
    , "this"
    , "throw"
    , "try"
    , "typeof"
    , "void"
    , "while"
    , "with"
    , "yield"
    -- TypeScript
    , "as"
    , "export"
    , "is"
    , "from"
    , "import"
    , "readonly"
    ]
  , declarationKeywords = Set.fromList [ "var", "const", "let" ]
  , literalKeywords =
    Set.fromList
    [ "true"
    , "false"
    , "null"
    , "undefined"
    , "NaN"
    , "Infinity"
    ]
  , builtIns = Set.fromList [ "any", "bigint", "boolean", "null", "number", "string", "undefined" ]
  , valueTypeAnnotationOperator = ':'
  , functionTypeAnnotation = symbol ":"
  , typeCheckCastOperator = oneOf []
  , typeCheckCastKeywords = Set.fromList [ "as", "in", "instanceof" ]
  , typeReferenceSymbols = oneOf [ symbol "|", symbol "&", symbol " " ]
  , typeReferenceGroupingSymbols = [ (symbol "<", symbol ">") ]
  , typeReferenceInGroupSymbols = oneOf [ symbol "," ]
  , annotation = symbol "@"
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed typescript
