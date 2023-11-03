module SyntaxHighlight.Language.Scala exposing (parseTokensReversed)

import Parser exposing (Error, keyword, oneOf, symbol)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


scala : CLikeCommon.Language
scala =
  { functionDeclarationKeyword = "def"
  , keywords =
    Set.fromList
    [ "asInstanceOf"
    , "break"
    , "case"
    , "catch"
    , "constructor"
    , "continue"
    , "do"
    , "else"
    , "extends"
    , "finally"
    , "for"
    , "forSome"
    , "if"
    , "implements"
    , "implicit"
    , "isInstanceOf"
    , "match"
    , "private"
    , "protected"
    , "public"
    , "return"
    , "super"
    , "this"
    , "throw"
    , "try"
    , "typealias"
    , "type"
    , "while"
    , "with"
    , "yield"
    ]
  , declarationKeywords = Set.fromList
    [ "lazy", "val", "var"
    -- Remove
    , "def", "class", "abstract", "enum", "import", "package"
    , "annotation", "final", "object", "override"
    , "sealed", "tailrec", "trait", "type", "vararg"
    ]
  , literalKeywords =
    Set.fromList [ "true", "false", "null" ]
  , builtIns =
    Set.fromList
    [ "Any", "AnyRef"
    , "Boolean", "Char", "String"
    , "Byte", "Short", "Int", "Long"
    , "Float", "Double"
    , "Array", "List", "Seq", "Set", "Option"
    ]
  , valueTypeAnnotationOperator = ':'
  , functionTypeAnnotation = symbol ":"
  , typeCheckCastOperator = oneOf [ keyword "asInstanceOf", keyword "isInstanceOf" ]
  , typeCheckCastKeywords = Set.fromList [ "asInstanceOf", "isInstanceOf" ]
  , typeReferenceSymbols = oneOf []
  , typeReferenceGroupingSymbols = [ (symbol "[", symbol "]") ]
  , typeReferenceInGroupSymbols = oneOf [ symbol ",", symbol " " ]
  , annotation = symbol "@"
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed scala
