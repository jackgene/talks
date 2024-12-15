module SyntaxHighlight.Language.Kotlin exposing (parseTokensReversed)

import Parser exposing (Error, keyword, oneOf, symbol)
import Set
import SyntaxHighlight.Language.CLikeCommon as CLikeCommon
import SyntaxHighlight.Model exposing (Token, TokenType(..))


kotlin : CLikeCommon.Language
kotlin =
  { functionDeclarationKeyword = "fun"
  , keywords =
    Set.fromList
    [ "as"
    , "as?"
    , "break"
    , "by"
    , "catch"
    , "constructor"
    , "continue"
    , "delegate"
    , "do"
    , "dynamic"
    , "else"
    , "field"
    , "file"
    , "for"
    , "get"
    , "if"
    , "import"
    , "in", "!in"
    , "init"
    , "interface"
    , "is", "!is"
    , "object"
    , "param"
    , "private"
    , "property"
    , "protected"
    , "public"
    , "receiver"
    , "return"
    , "static"
    , "set"
    , "setparam"
    , "super"
    , "this"
    , "throw"
    , "to"
    , "try"
    , "typealias"
    , "typeof"
    , "val"
    --, "value"
    , "var"
    , "when"
    , "where"
    , "while"
    ]
  , declarationKeywords = Set.fromList [ "val", "var"
    -- Remove
    , "class", "data", "abstract", "enum", "import", "package"
    , "actual", "annotation", "companion", "const", "crossinline", "expect", "external", "final", "infix"
    , "inline", "inner", "internal", "lateinit", "noinline", "open", "operator", "out", "override", "reified"
    , "sealed", "suspend", "tailrec", "vararg"
    ]
  , literalKeywords =
    Set.fromList
    [ "true", "false", "null"
    , "field", "it"
    ]
  , builtIns =
    Set.fromList
    [ "Any", "Array"
    , "Boolean", "Char"--, "String"
    , "Byte", "Short", "Int", "Long"
    , "UByte", "UShort", "UInt", "ULong"
    , "Float", "Double"
    , "BooleanArray", "CharArray", "StringArray"
    , "ByteArray", "ShortArray", "IntArray", "LongArray"
    , "UByteArray", "UShortArray", "UIntArray", "ULongArray"
    , "FloatArray", "DoubleArray"
    ]
  , valueTypeAnnotationOperator = ':'
  , functionTypeAnnotation = symbol ":"
  , typeCheckCastOperator = oneOf [ keyword "as", keyword "!is" ]
  , typeCheckCastKeywords = Set.fromList [ "as", "is" ]
  , typeReferenceSymbols = oneOf []
  , typeReferenceGroupingSymbols = [ (symbol "<", symbol ">") ]
  , typeReferenceInGroupSymbols = oneOf [ symbol ",", symbol " " ]
  , annotation = symbol "@"
  }


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed = CLikeCommon.parseTokensReversed kotlin
