module Deck.Slide.SyntaxHighlight exposing (..)

import Css exposing
  ( Style
  -- Container
  , border3, display, left, marginTop, padding2, position, right, top
  -- Content
  , backgroundColor, color, fontSize, opacity
  -- Units
  , em, num, vw
  -- Alignments & Positions
  , absolute
  -- Other values
  , inlineBlock, none, relative, rgb, rgba, solid
  )
import Css.Transitions exposing (easeInOut, transition)
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing
  ( languageGoLogo, languageKotlinLogo, languagePythonLogo, languageSwiftLogo
  , languageTypeScriptLogo
  )
import Dict exposing (Dict)
import Html.Styled exposing (Attribute, Html, div, text)
import Parser
import Svg.Styled exposing (Svg, svg)
import Svg.Styled.Attributes exposing (css)
import SyntaxHighlight
import SyntaxHighlight.Language as Language
import SyntaxHighlight.Line as Line
import SyntaxHighlight.Model exposing
  ( Block, Line, Theme
  , ColumnEmphasis, ColumnEmphasisType(..), LineEmphasis(..)
  )
import SyntaxHighlight.Theme exposing (darcula)
import SyntaxHighlight.Theme.Common exposing (noEmphasis)


-- Constants
syntaxTheme : Theme
syntaxTheme =
  { darcula
  | default = Css.batch [ noEmphasis (rgb 163 183 198) (rgb 43 43 43), codeFontFamily ]
  }


-- Model
type alias CodeBlockError msg =
  { line : Int
  , column : Int
  , content : List (Html msg)
  }


type Language = Go | Kotlin | Python | Swift | TypeScript | XML


-- Functions
syntaxHighlightedCodeBlock : Language -> Dict Int LineEmphasis -> Dict Int (List ColumnEmphasis) -> List (CodeBlockError msg) -> String -> Html msg
syntaxHighlightedCodeBlock language lineEmphases columnEmphases errors source =
  Result.withDefault (text "Error Parsing Source")
  ( let
      parser : String -> Result Parser.Error Block
      parser =
        case language of
          Go -> Language.go
          Kotlin -> Language.kotlin
          Python -> Language.python
          Swift -> Language.swift
          TypeScript -> Language.typeScript
          XML -> Language.xml
    in
    Result.map
    ( \block ->
      let
        lineEmhasizedBlock : Block
        lineEmhasizedBlock =
          Dict.foldl
          ( \line lineEm accumBlock ->
            Line.emphasizeLines lineEm line (line+1) accumBlock
          )
          block
          lineEmphases

        fullyEmphasizedBlock : Block
        fullyEmphasizedBlock =
          Dict.foldl
          ( \line colEms accumBlock ->
            Line.emphasizeColumns colEms line accumBlock
          )
          lineEmhasizedBlock
          columnEmphases

        codeBlock : Html msg
        codeBlock = SyntaxHighlight.toBlockHtml syntaxTheme (Just 1) fullyEmphasizedBlock

        emptyPlaceholder : Html msg
        emptyPlaceholder = div [ css [ display none ] ] []

        codeFontSizeVw : Float
        codeFontSizeVw = 1.935

        languageLogo : Svg msg
        languageLogo =
          case language of
            Go -> languageGoLogo
            Kotlin -> languageKotlinLogo
            Python -> languagePythonLogo
            Swift -> languageSwiftLogo
            TypeScript -> languageTypeScriptLogo
            XML -> svg [] []
      in
      div
      [ css [ position relative, marginTop (em -0.75), fontSize (vw codeFontSizeVw) ] ]
      ( [ if language == Go then codeBlock else emptyPlaceholder
        , if language == Kotlin then codeBlock else emptyPlaceholder
        , if language == Python then codeBlock else emptyPlaceholder
        , if language == Swift then codeBlock else emptyPlaceholder
        , if language == TypeScript then codeBlock else emptyPlaceholder
        , div
          [ css
            [ position absolute, top (em 0.625), right (em 0.5), opacity (num 0.875) ]
          ]
          [ languageLogo ]
        ]
      ++( if List.isEmpty errors then
            List.repeat 3 (div [ css [ opacity (num 0) ] ] [])
          else
            List.map
            ( \{line, column, content} ->
                div
                [ css
                  [ display inlineBlock, position absolute
                  , top (vw (codeFontSizeVw * 1.325 * (toFloat line + 1) + 0.125))
                  , left (vw (codeFontSizeVw * 0.6125 * (toFloat column) + 5))
                  , padding2 (em 0.0625) (em 0.125), border3 (em 0.1) solid (rgb 209 71 21)
                  , fontSize (em 0.75), color (rgb 209 71 21), backgroundColor (rgba 192 160 160 9.5)
                  , transition
                    [ Css.Transitions.opacity3 transitionDurationMs (transitionDurationMs / 2) easeInOut ]
                  ]
                ]
                content
            )
            errors
          )
      )
    )
    ( parser (String.trim source) )
  )


syntaxHighlightedCodeSnippet : Language -> String -> Html msg
syntaxHighlightedCodeSnippet language source =
  Result.withDefault (text "Error Parsing Source")
  ( let
      parser : String -> Result Parser.Error Block -- TODO line parser in syntax highlight library? This or the next TODO
      parser =
        case language of
          Go -> Language.go
          Kotlin -> Language.kotlin
          Python -> Language.python
          Swift -> Language.swift
          TypeScript -> Language.typeScript
          XML -> Language.xml
    in
    Result.map
    ( \block ->
      SyntaxHighlight.toInlineHtml syntaxTheme
      ( Maybe.withDefault
        ( Line [] Nothing [] ) -- TODO make empty line a constant in the syntax highlight library
        ( List.head block )
      )
    )
    ( parser (String.trim source) )
  )
