module SyntaxHighlight.Language.Xml exposing (parseTokensReversed)

import Char
import Parser exposing
  ( Parser, oneOf, zeroOrMore, oneOrMore, ignore, (|.), source, keep, Count(..)
  , Error, map, andThen, repeat, succeed, symbol
  )
import SyntaxHighlight.Language.Common exposing
  ( Delimiter, addThen, consThen, delimited, isWhitespace, isSpace, isLineBreak
  , thenIgnore, consThenRevConcat
  )
import SyntaxHighlight.Model exposing (Token, TokenType(..))


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed =
  Parser.run
  ( map
    ( List.reverse >> List.concat )
    ( repeat zeroOrMore mainLoop )
  )


mainLoop : Parser (List Token)
mainLoop =
  oneOf
  [ whitespace |> map List.singleton
  , comment
  , keep oneOrMore ( \c -> c /= '<' && c /= '>' && not (isLineBreak c) )
    |> map ( \c -> [ ( Normal, c ) ] )
  , symbol ">" |> map ( \_ -> [ ( FunctionDeclaration, ">" ) ] )
  , openTag
  ]


openTag : Parser (List Token)
openTag =
  ( ignore oneOrMore ((==) '<')
  |. oneOf
    [ ignore (Exactly 1) ( \c -> c == '/' || c == '!' )
    , Parser.succeed ()
    ]
  )
  |> source
  |> map ( \c -> [ ( FunctionDeclaration, c ) ] )
  |> andThen tag


tag : List Token -> Parser (List Token)
tag revTokens =
  oneOf
  [ ignore (Exactly 1) isStartTagChar
    |> thenIgnore zeroOrMore isTagChar
    |> source
    |> map ( \tag -> ( FunctionDeclaration, tag ) )
    |> andThen
      ( \n ->
        repeat zeroOrMore attributeLoop
        |> consThenRevConcat (n :: revTokens)
      )
  , succeed revTokens
  ]


isStartTagChar : Char -> Bool
isStartTagChar c =
  Char.isUpper c || Char.isLower c || Char.isDigit c


isTagChar : Char -> Bool
isTagChar c =
  isStartTagChar c || c == '-'


attributeLoop : Parser (List Token)
attributeLoop =
  oneOf
    [ keep oneOrMore isAttributeChar
      |> map ( \attr -> ( FunctionReference, attr ) )
      |> consThen attributeConfirm []
    , whitespace |> map List.singleton
    , keep oneOrMore ( \c -> not (isWhitespace c) && c /= '>' )
      |> map ( \c -> [ ( Normal, c ) ] )
    ]


isAttributeChar : Char -> Bool
isAttributeChar c =
  isTagChar c || c == '_'


attributeConfirm : List Token -> Parser (List Token)
attributeConfirm revTokens =
  oneOf
    [ whitespace
      |> consThen attributeConfirm revTokens
    , keep (Exactly 1) ((==) '=')
      |> map ( \c -> ( Operator, c ) )
      |> consThen attributeValueLoop revTokens
    , succeed revTokens
    ]


attributeValueLoop : List Token -> Parser (List Token)
attributeValueLoop revTokens =
  oneOf
    [ whitespace
      |> consThen attributeValueLoop revTokens
    , attributeValue
      |> addThen succeed revTokens
    , succeed revTokens
    ]



-- Attribute Value
attributeValue : Parser (List Token)
attributeValue =
  oneOf
  [ doubleQuote
  , quote
  , ignore oneOrMore (\c -> not (isWhitespace c) && c /= '>')
    |> source
    |> map ( \c -> [ ( LiteralNumber, c ) ] )
  ]


doubleQuote : Parser (List Token)
doubleQuote =
  delimited doubleQuoteDelimiter


doubleQuoteDelimiter : Delimiter Token
doubleQuoteDelimiter =
  { start = "\""
  , end = "\""
  , isNestable = False
  , defaultMap = ( \c -> ( LiteralString, c ) )
  , innerParsers = [ lineBreakList ]
  , isNotRelevant = not << isLineBreak
  }


quote : Parser (List Token)
quote =
  delimited
    { doubleQuoteDelimiter
    | start = "'"
    , end = "'"
    }



-- Comment
comment : Parser (List Token)
comment =
  delimited
    { doubleQuoteDelimiter
    | start = "<!--"
    , end = "-->"
    , defaultMap = ( \c -> ( Comment, c ) )
    }



-- Helpers
whitespace : Parser Token
whitespace =
  oneOf
  [ keep oneOrMore isSpace
    |> map ( \ws -> ( Normal, ws ) )
  , lineBreak
  ]


lineBreak : Parser Token
lineBreak =
  keep (Exactly 1) isLineBreak
  |> map ( \c -> ( LineBreak, c ) )


lineBreakList : Parser (List Token)
lineBreakList =
  repeat oneOrMore lineBreak
