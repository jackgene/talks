module SyntaxHighlight.View exposing (toBlockHtml, toInlineHtml)

import Css exposing
  ( Style, property
  -- Container
  , borderRight2, display, height, left, margin, marginRight, overflowX
  , paddingBottom, paddingRight, position, top, width
  -- Scalars
  , ch, em, pct, px, zero
  -- Other values
  , absolute, before, hidden, inlineBlock, relative, right, solid, textAlign
  )
import Css.Transitions exposing (easeInOut, transition)
import Html.Styled as Html exposing (Html, Attribute, text, span, code, div, pre)
import Html.Styled.Attributes exposing (class, css)
import SyntaxHighlight.Model exposing (..)


-- Html
lineHeightEm : Float
lineHeightEm = 1.25


transitionDurationMs : Float
transitionDurationMs = 500


toBlockHtml : Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
  pre
  [ css
    [ position relative
    , width (pct 100)
    , height (em (0.05 + lineHeightEm * toFloat (List.length lines)))
    , margin zero, theme.default
    , transition [ Css.Transitions.height3 500 0 easeInOut ]
    ]
  , class "elmsh"
  ]
  ( let
      numberedLines : List (Int, Line)
      numberedLines = List.indexedMap (,) lines

      (deletionLines, nonDeletionLines) =
        List.partition
        ( \(_, line) -> line.emphasis == Just Deletion )
        numberedLines
    in
    case maybeStart of
      Nothing ->
        List.map
        ( \(idx, line) ->
          div
          [ css
            [ position absolute, top (em (lineHeightEm * toFloat idx)), width (pct 100)
            , transition
              ( if line.emphasis == Just Deletion then []
                else [ Css.Transitions.top3 transitionDurationMs 0 easeInOut ]
              )
            ]
          ]
          ( lineView theme line )
        )
        ( nonDeletionLines ++ deletionLines )

      Just start ->
        ( List.indexedMap
          ( \displayIdx (idx, line) ->
            numberedLineView theme start (start - 1 + List.length lines) idx displayIdx line
          )
          nonDeletionLines
        ++List.map
          ( \(idx, line) ->
            numberedLineView theme start (start - 1 + List.length lines) idx 0 line
          )
          deletionLines
        )
  )


numberedLineView : Theme -> Int -> Int -> Int -> Int -> Line -> Html msg
numberedLineView theme start end index displayedIndex { tokens, emphasis, columnEmphases } =
  let
    gutterWidth : Float
    gutterWidth = toFloat (floor (logBase 10 (toFloat end))) + 2
  in
  div
  ( css
    [ before
      [ property "content"
        ( if emphasis == Just Deletion then "\" \""
          else "\"" ++ (toString (start + displayedIndex)) ++ "\""
        )
      , display inlineBlock, width (ch gutterWidth)
      , marginRight (ch 1), paddingRight (ch 1), paddingBottom (em (lineHeightEm - 1.15))
      , borderRight2 (px 1) solid
      , textAlign right
      , theme.gutter
      ]
    , position absolute, top (em ((0.075 + lineHeightEm) * toFloat index)), width (pct 100)
    , transition
      ( if emphasis == Just Deletion then []
        else [ Css.Transitions.top3 transitionDurationMs 0 easeInOut ]
      )
    ]
  ::( case emphasis of
        Just emphasis -> lineEmphasisStyleAttributes theme emphasis
        Nothing -> [ css [ theme.default ] ]
    )
  )
  ( ( if List.isEmpty columnEmphases then List.repeat 2 ( span [ css [ errorSpanStyle, width zero ] ] [] )
      else List.map (errorSpanView theme gutterWidth) columnEmphases
    )
  ++( tokensView theme tokens )
  )


toInlineHtml : Theme -> Line -> Html msg
toInlineHtml theme line =
  code [ css [ theme.default ], class "elmsh" ] (lineView theme line)


lineView : Theme -> Line -> List (Html msg)
lineView theme {tokens, emphasis} =
  case emphasis of
    Nothing -> tokensView theme tokens
    Just emphasis ->
      [ div
        ( lineEmphasisStyleAttributes theme emphasis )
        ( tokensView theme tokens )
      ]


lineEmphasisStyleAttributes : Theme -> LineEmphasis -> List (Attribute msg)
lineEmphasisStyleAttributes theme emphasis =
  case emphasis of
    Selection -> [ class "elmsh-sel", css [ theme.selection ] ]
    Addition -> [ class "elmsh-add", css [ theme.addition ] ]
    Deletion -> [ class "elmsh-del", css [ theme.deletion ] ]


tokensView : Theme -> List Token -> List (Html msg)
tokensView theme tokens =
  List.map (tokenView theme) tokens


tokenView : Theme -> Token -> Html msg
tokenView theme (tokenType, text) =
  if tokenType == Normal then Html.text text
  else
    span
    [ css
      [ case tokenType of
          Comment -> theme.comment
          Keyword -> theme.keyword
          DeclarationKeyword -> theme.declarationKeyword
          BuiltIn -> theme.builtIn
          Operator -> theme.operator
          LiteralNumber -> theme.number
          LiteralString -> theme.string
          LiteralKeyword -> theme.literal
          TypeDeclaration -> theme.typeDeclaration
          TypeReference -> theme.typeReference
          FunctionDeclaration -> theme.functionDeclaration
          FunctionReference -> theme.functionReference
          FunctionArgument -> theme.functionArgument
          FieldDeclaration -> theme.fieldDeclaration
          FieldReference -> theme.fieldReference
          Annotation -> theme.annotation
          _ -> theme.default
      ]
    , class (classByTokenType tokenType)
    ]
    [ Html.text text ]


errorSpanView : Theme -> Float -> ColumnEmphasis -> Html msg
errorSpanView theme gutterWidth { emphasis, start, length } =
  span
  [ css
    [ errorSpanStyle
    , ( case emphasis of
          Error -> theme.error
          Warning -> theme.warning
      )
    , width (ch (toFloat length - 0.25))
    , left (ch (gutterWidth + 2.25 + toFloat start))
    ]
  ]
  [ text (String.repeat length " ") ]


errorSpanStyle : Style
errorSpanStyle =
  Css.batch
  [ position absolute, height (em lineHeightEm), overflowX hidden
  , transition [ Css.Transitions.width3 transitionDurationMs 0 easeInOut ]
  ]


classByTokenType : TokenType -> String
classByTokenType tokenType =
  "elmsh" ++
  ( case tokenType of
      Normal -> ""
      Comment -> "-comm"
      Namespace -> "-ns"
      Keyword -> "-kw"
      DeclarationKeyword -> "-dkw"
      BuiltIn -> "-bltn"
      Operator -> "-op"
      LiteralNumber -> "-num"
      LiteralString -> "-str"
      LiteralKeyword -> "-lit"
      TypeDeclaration -> "-typd"
      TypeReference -> "-typ"
      FunctionDeclaration -> "-fncd"
      FunctionReference -> "-fnc"
      FunctionArgument -> "-arg"
      FieldDeclaration -> "-fldd"
      FieldReference -> "-fld"
      Annotation -> "-ann"
      _ -> ""
  )