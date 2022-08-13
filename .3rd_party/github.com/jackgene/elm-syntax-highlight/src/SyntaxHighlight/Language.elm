module SyntaxHighlight.Language exposing
  ( elm, go, kotlin, python, swift, typeScript, xml )

import Parser
import SyntaxHighlight.Language.Elm as Elm
import SyntaxHighlight.Language.Go as Go
import SyntaxHighlight.Language.Kotlin as Kotlin
import SyntaxHighlight.Language.Python as Python
import SyntaxHighlight.Language.Swift as Swift
import SyntaxHighlight.Language.TypeScript as TypeScript
import SyntaxHighlight.Language.Xml as Xml
import SyntaxHighlight.Model exposing (..)


{-| Parse Elm syntax.
-}
elm : String -> Result Parser.Error Block
elm = Elm.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse Go syntax.
-}
go : String -> Result Parser.Error Block
go = Go.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse Kotlin syntax.
-}
kotlin : String -> Result Parser.Error Block
kotlin = Kotlin.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse Python syntax.
-}
python : String -> Result Parser.Error Block
python = Python.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse Swift syntax.
-}
swift : String -> Result Parser.Error Block
swift = Swift.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse TypeScript syntax.
-}
typeScript : String -> Result Parser.Error Block
typeScript = TypeScript.parseTokensReversed >> Result.map reverseAndBreakIntoLines


{-| Parse XML syntax.
-}
xml : String -> Result Parser.Error Block
xml = Xml.parseTokensReversed >> Result.map reverseAndBreakIntoLines


reverseAndBreakIntoLines : List Token -> Block
reverseAndBreakIntoLines revTokens =
  let
    (tailLines, headTokens, _) =
      List.foldl
      ( \(token) (lineAccum, tokenAccum, maybeLastTokenType) ->
        case token of
          (LineBreak, _) ->
            ( (tokensToLine tokenAccum) :: lineAccum
            , [ token ]
            , Nothing
            )

          (tokenType, tokenText) as token ->
            if Just tokenType == maybeLastTokenType then
              case tokenAccum of
                -- Concat same syntax sequence to reduce html elements.
                (_, headTokenText) :: tailTokens ->
                  ( lineAccum
                  , (tokenType, tokenText ++ headTokenText) :: tailTokens
                  , maybeLastTokenType
                  )

                _ ->
                  ( lineAccum
                  , token :: tokenAccum
                  , maybeLastTokenType
                  )

            else
              ( lineAccum
              , token :: tokenAccum
              , Just tokenType
              )
      )
      ([], [], Nothing)
      revTokens
  in (tokensToLine headTokens) :: tailLines


tokensToLine : List Token -> Line
tokensToLine tokens =
  { tokens = tokens
  , emphasis = Nothing
  , columnEmphases = []
  }
