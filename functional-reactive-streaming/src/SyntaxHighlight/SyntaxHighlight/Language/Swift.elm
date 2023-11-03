module SyntaxHighlight.Language.Swift exposing (parseTokensReversed)

import Parser exposing (Error, keyword, oneOf, symbol)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


swift : CLikeCommon.Language
swift =
  { functionDeclarationKeyword = "func"
  , keywords =
    Set.fromList
    [ "Any"
    , "Protocol"
    , "Self"
    , "Type"
    , "as"
    , "as?"
    , "as!"
    , "associatedtype"
    , "associativity"
    , "break"
    , "case"
    , "catch"
    , "continue"
    , "convenience"
    , "default"
    , "defer"
    , "deinit"
    , "didSet"
    , "do"
    , "dynamic"
    , "else"
    , "extension"
    , "fallthrough"
    , "fileprivate"
    , "final"
    , "for"
    , "get"
    , "guard"
    , "if"
    , "import"
    , "in"
    , "indirect"
    , "infix"
    , "init"
    , "inout"
    , "internal"
    , "is"
    , "lazy"
    , "left"
    , "let"
    , "mutating"
    , "none"
    , "nonmutating"
    , "open"
    , "operator"
    , "optional"
    , "override"
    , "postfix"
    , "precedence"
    , "prefix"
    , "private"
    , "public"
    , "repeat"
    , "required"
    , "rethrows"
    , "return"
    , "right"
    , "self"
    , "set"
    , "static"
    , "struct"
    , "subscript"
    , "super"
    , "switch"
    , "throw"
    , "throws"
    , "try"
    , "typealias"
    , "unowned"
    , "var"
    , "weak"
    , "where"
    , "while"
    , "willSet"
    ]
  , declarationKeywords = Set.fromList [ "let", "var"
    -- Remove
    , "class", "enum", "import", "protocol", "struct" ]
  , literalKeywords =
    Set.fromList [ "true", "false", "nil" ]
  , builtIns =
    Set.fromList
    [ "Bool", "Character", "String"
    , "Int", "Int8", "Int16", "Int32", "Int64"
    , "UInt", "UInt8", "UInt16", "UInt32", "UInt64"
    , "Float", "Double"
    ]
  , valueTypeAnnotationOperator = ':'
  , functionTypeAnnotation = symbol " ->"
  , typeCheckCastOperator = oneOf [ keyword "as" ]
  , typeCheckCastKeywords = Set.fromList [ "as", "is" ]
  , typeReferenceSymbols = oneOf []
  , typeReferenceGroupingSymbols =
    [ (symbol "[", symbol "]")
    , (symbol "(", symbol ")")
    , (symbol "<", symbol ">")
    ]
  , typeReferenceInGroupSymbols = oneOf [ symbol ":", symbol ",", symbol " " ]
  , annotation = symbol "@"
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed swift
