module SyntaxHighlight.Theme.Darcula exposing (theme)

import Css exposing (Style, rgb, rgba)
import Dict
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- JetBrains Darcula inspired theme
theme : Theme
theme =
  let
    keyword : Style
    keyword = textColor (rgb 199 119 62)
  in
  { default = noEmphasis (rgb 163 183 198) (rgb 43 43 43)
  , selection = backgroundColor (rgb 50 50 50)
  , addition = backgroundColor (rgb 42 53 47)
  , deletion = strikeThrough (rgb 163 183 198) (backgroundColor (rgb 53 42 47))
  , error = squigglyUnderline (rgba 236 70 66 0.75) noStyle --(rgb 188 63 60)
  , warning = squigglyUnderline (rgba 218 218 156 0.75) noStyle --(rgb 174 174 128)
  , comment = textColor (rgb 120 120 120)
  , namespace = textColor (rgb 175 191 126)
  , keyword = keyword
  , declarationKeyword = keyword
  , builtIn = textColor (rgb 136 136 198)
  , operator = noStyle
  , number = textColor (rgb 104 151 187)
  , string = textColor (rgb 106 135 89)
  , literal = keyword
  , typeDeclaration = noStyle
  , typeReference = textColor (rgb 111 175 189)
  , functionDeclaration = textColor (rgb 230 177 99)
  , functionArgument = noStyle
  , functionReference = textColor (rgb 176 157 121)
  , fieldDeclaration = textColor (rgb 152 118 170)
  , fieldReference = textColor (rgb 152 118 170)
  , annotation = textColor (rgb 187 181 41)
  , other = Dict.empty
  , gutter = noEmphasis (rgb 96 99 102) (rgb 49 51 53)
  }
