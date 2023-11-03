module SyntaxHighlight.Language.Elm exposing (parseTokensReversed)

import Char
import Set exposing (Set)
import Parser exposing
  ( Parser, oneOf, zeroOrMore, oneOrMore, ignore, symbol, keyword, (|.), (|=)
  , source, keep, Count(..), Error, map, andThen, delayedCommit, repeat, succeed
  )
import SyntaxHighlight.Language.Common exposing
  ( Delimiter, isWhitespace, isSpace, isLineBreak, delimited, escapable
  , isEscapable, addThen, consThen, thenIgnore, number
  )
import SyntaxHighlight.Model exposing (Token, TokenType(..))


parseTokensReversed : String -> Result Error (List Token)
parseTokensReversed =
  Parser.run
  ( map
    ( List.reverse >> List.concat )
    ( repeat zeroOrMore (lineStart []) )
  )


lineStart : List Token -> Parser (List Token)
lineStart revTokens =
  oneOf
  [ whitespaceOrComment succeed revTokens
  , variable |> andThen (lineStartVariable revTokens)
  , stringLiteral |> addThen functionBody revTokens
  , functionBodyContent |> consThen functionBody revTokens
  ]


lineStartVariable : List Token -> String -> Parser (List Token)
lineStartVariable revTokens n =
  if n == "module" || n == "import" then
    moduleDeclaration (( DeclarationKeyword, n ) :: revTokens)
  else if n == "port" then
    portDeclaration (( DeclarationKeyword, n ) :: revTokens)
  else if n == "type" then
    functionBody (( DeclarationKeyword, n ) :: revTokens) -- TODO
  else if isKeyword n then
    functionBody (( Keyword, n ) :: revTokens)
  else
    functionSignature (( FunctionDeclaration, n ) :: revTokens)


-- Module Declaration
moduleDeclaration : List Token -> Parser (List Token)
moduleDeclaration revTokens =
  oneOf
  [ whitespaceOrComment moduleDeclaration revTokens
  , symbol "("
    |> map (always ( Normal, "(" ))
    |> consThen modDecParentheses revTokens
  , oneOf
    [ commentChar |> map ((,) Normal)
    , keyword "exposing"
      |> map (always ( Keyword, "exposing" ))
    , keyword "as"
      |> map (always ( Keyword, "as" ))
    , keep oneOrMore modDecIsNotRelevant
      |> map ((,) Normal)
    ]
    |> consThen moduleDeclaration revTokens
  , succeed revTokens
  ]


modDecIsNotRelevant : Char -> Bool
modDecIsNotRelevant c =
  not (isWhitespace c || isCommentChar c || c == '(')


modDecParentheses : List Token -> Parser (List Token)
modDecParentheses revTokens =
  oneOf
  [ whitespaceOrComment modDecParentheses revTokens
  , symbol ")"
    |> map (always ( Normal, ")" ))
    |> consThen moduleDeclaration revTokens
  , oneOf
    [ infixParser
    , commentChar |> map ((,) Normal)
    , keep oneOrMore (\c -> c == ',' || c == '.')
      |> map ((,) Normal)
    , ignore (Exactly 1) Char.isUpper
      |> thenIgnore zeroOrMore mdpIsNotRelevant
      |> source
      |> map ((,) TypeDeclaration)
    , keep oneOrMore mdpIsNotRelevant
      |> map ((,) FunctionReference)
    ]
    |> consThen modDecParentheses revTokens
  , symbol "("
    |> map (always ( Normal, "(" ))
    |> consThen (modDecParNest 0) revTokens
  , succeed revTokens
  ]


mdpIsNotRelevant : Char -> Bool
mdpIsNotRelevant c =
  not (isWhitespace c || isCommentChar c || c == '(' || c == ')' || c == ',' || c == '.')


modDecParNest : Int -> List Token -> Parser (List Token)
modDecParNest nestLevel revTokens =
  oneOf
  [ whitespaceOrComment (modDecParNest nestLevel) revTokens
  , symbol "("
    |> map (always ( Normal, "(" ))
    |> andThen (\n -> modDecParNest (nestLevel + 1) (n :: revTokens))
  , symbol ")"
    |> map (always ( Normal, ")" ))
    |> andThen
      (\n ->
        if nestLevel == 0 then
          modDecParentheses (n :: revTokens)
        else
          modDecParNest (nestLevel - 1) (n :: revTokens)
      )
  , oneOf
    [ commentChar |> map ((,) Normal)
    , keep oneOrMore (not << mdpnIsSpecialChar)
      |> map ((,) Normal)
    ]
    |> consThen (modDecParNest nestLevel) revTokens
  , succeed revTokens
  ]


mdpnIsSpecialChar : Char -> Bool
mdpnIsSpecialChar c =
  isLineBreak c || isCommentChar c || c == '(' || c == ')'



-- Port Declaration
portDeclaration : List Token -> Parser (List Token)
portDeclaration revTokens =
  oneOf
  [ whitespaceOrComment portDeclaration revTokens
  , variable |> andThen (portDeclarationHelp revTokens)
  , functionBody revTokens
  ]


portDeclarationHelp : List Token -> String -> Parser (List Token)
portDeclarationHelp revTokens str =
  if str == "module" then
    moduleDeclaration (( DeclarationKeyword, str ) :: revTokens)
  else
    functionSignature (( FunctionDeclaration, str ) :: revTokens)


-- Type Declaration



-- Function Signature
functionSignature : List Token -> Parser (List Token)
functionSignature revTokens =
  oneOf
  [ symbol ":"
    |> map (always ( Operator, ":" ))
    |> consThen fnSigContent revTokens
  , whitespaceOrComment functionSignature revTokens
  , functionBody revTokens
  ]


fnSigContent : List Token -> Parser (List Token)
fnSigContent revTokens =
  oneOf
  [ whitespaceOrComment fnSigContent revTokens
  , fnSigContentHelp |> consThen fnSigContent revTokens
  , succeed revTokens
  ]


fnSigContentHelp : Parser Token
fnSigContentHelp =
  oneOf
  [ symbol "()" |> map (always ( TypeReference, "()" ))
  , symbol "->" |> map (always ( Operator, "->" ))
  , keep oneOrMore (\c -> c == '(' || c == ')' || c == '-' || c == ',')
    |> map ((,) Normal)
  , ignore (Exactly 1) Char.isUpper
    |> thenIgnore zeroOrMore fnSigIsNotRelevant
    |> source
    |> map ((,) TypeReference)
  , keep oneOrMore fnSigIsNotRelevant |> map ((,) Normal)
  ]


fnSigIsNotRelevant : Char -> Bool
fnSigIsNotRelevant c =
  not (isWhitespace c || c == '(' || c == ')' || c == '-' || c == ',')



-- Function Body
functionBody : List Token -> Parser (List Token)
functionBody revTokens =
  oneOf
    [ whitespaceOrComment functionBody revTokens
    , stringLiteral |> addThen functionBody revTokens
    , functionBodyContent |> consThen functionBody revTokens
    , succeed revTokens
    ]


functionBodyContent : Parser Token
functionBodyContent =
  oneOf
  [ number |> source |> map ((,) LiteralNumber)
  , symbol "()" |> map (always ( Operator, "()" ))
  , infixParser
  , basicSymbol |> map ((,) Operator)
  , groupSymbol |> map ((,) Operator)
  , capitalized |> map ((,) TypeReference)
  , variable
    |> map
      (\n ->
        if isKeyword n then
          ( Keyword, n )
        else
          ( Normal, n )
      )
  , weirdText |> map ((,) Normal)
  ]


isKeyword : String -> Bool
isKeyword str =
  Set.member str keywordSet


keywordSet : Set String
keywordSet =
  Set.fromList
  [ "alias"
  , "as"
  , "case"
  , "else"
  , "if"
  , "in"
  , "let"
  , "of"
  , "then"
  , "where"
  ]


basicSymbol : Parser String
basicSymbol =
  keep oneOrMore isBasicSymbol


isBasicSymbol : Char -> Bool
isBasicSymbol c =
  Set.member c basicSymbols


basicSymbols : Set Char
basicSymbols =
  Set.fromList
  [ '|'
  , '.'
  , '='
  , '\\'
  , '/'
  , '('
  , ')'
  , '-'
  , '>'
  , '<'
  , ':'
  , '+'
  , '!'
  , '$'
  , '%'
  , '&'
  , '*'
  ]


groupSymbol : Parser String
groupSymbol =
  keep oneOrMore isGroupSymbol


isGroupSymbol : Char -> Bool
isGroupSymbol c =
  Set.member c groupSymbols


groupSymbols : Set Char
groupSymbols =
  Set.fromList
  [ ','
  , '['
  , ']'
  , '{'
  , '}'
  ]


capitalized : Parser String
capitalized =
  ignore (Exactly 1) Char.isUpper
  |> thenIgnore zeroOrMore isVariableChar
  |> source


variable : Parser String
variable =
  ignore (Exactly 1) Char.isLower
  |> thenIgnore zeroOrMore isVariableChar
  |> source


isVariableChar : Char -> Bool
isVariableChar c =
  not (isWhitespace c || isBasicSymbol c || isGroupSymbol c || isStringLiteralChar c)


weirdText : Parser String
weirdText =
  keep oneOrMore isVariableChar



-- Infix
infixParser : Parser Token
infixParser =
  delayedCommit (symbol "(")
    (delayedCommit (ignore oneOrMore isInfixChar) (symbol ")"))
    |> source
    |> map ((,) FunctionReference)


isInfixChar : Char -> Bool
isInfixChar c =
  Set.member c infixSet


infixSet : Set Char
infixSet =
  Set.fromList
  [ '+'
  , '-'
  , '/'
  , '*'
  , '='
  , '.'
  , '$'
  , '<'
  , '>'
  , ':'
  , '&'
  , '|'
  , '^'
  , '?'
  , '%'
  , '#'
  , '@'
  , '~'
  , '!'
  , ','
  ]


-- String/Char literals
stringLiteral : Parser (List Token)
stringLiteral =
  oneOf
    [ tripleDoubleQuote
    , doubleQuote
    , quote
    ]


doubleQuote : Parser (List Token)
doubleQuote =
  delimited stringDelimiter


stringDelimiter : Delimiter Token
stringDelimiter =
  { start = "\""
  , end = "\""
  , isNestable = False
  , defaultMap = ((,) (LiteralString))
  , innerParsers = [ lineBreakList, elmEscapable ]
  , isNotRelevant = \c -> not (isLineBreak c || isEscapable c)
  }


tripleDoubleQuote : Parser (List Token)
tripleDoubleQuote =
  delimited
    { stringDelimiter
    | start = "\"\"\""
    , end = "\"\"\""
    }


quote : Parser (List Token)
quote =
  delimited
    { stringDelimiter
    | start = "'"
    , end = "'"
    }


isStringLiteralChar : Char -> Bool
isStringLiteralChar c =
  c == '"' || c == '\''



-- Comments
comment : Parser (List Token)
comment =
  oneOf
  [ inlineComment
  , multilineComment
  ]


inlineComment : Parser (List Token)
inlineComment =
  symbol "--"
  |> thenIgnore zeroOrMore (not << isLineBreak)
  |> source
  |> map ((,) Comment >> List.singleton)


multilineComment : Parser (List Token)
multilineComment =
  delimited
  { start = "{-"
  , end = "-}"
  , isNestable = True
  , defaultMap = ((,) Comment)
  , innerParsers = [ lineBreakList ]
  , isNotRelevant = \c -> not (isLineBreak c)
  }


commentChar : Parser String
commentChar =
  keep (Exactly 1) isCommentChar


isCommentChar : Char -> Bool
isCommentChar c =
  c == '-' || c == '{'


-- Helpers
whitespaceOrComment : (List Token -> Parser (List Token)) -> List Token -> Parser (List Token)
whitespaceOrComment continueFunction revTokens =
  oneOf
  [ space |> consThen continueFunction revTokens
  , lineBreak
    |> consThen (checkContext continueFunction) revTokens
  , comment |> addThen continueFunction revTokens
  ]


checkContext : (List Token -> Parser (List Token)) -> List Token -> Parser (List Token)
checkContext continueFunction revTokens =
  oneOf
  [ whitespaceOrComment continueFunction revTokens
  , succeed revTokens
  ]


space : Parser Token
space =
  keep oneOrMore isSpace
  |> map ((,) Normal)


lineBreak : Parser Token
lineBreak =
  keep (Exactly 1) isLineBreak
  |> map ((,) LineBreak)


lineBreakList : Parser (List Token)
lineBreakList =
  repeat oneOrMore lineBreak


elmEscapable : Parser (List Token)
elmEscapable =
  escapable
  |> source
  |> map ((,) Operator)
  |> repeat oneOrMore
