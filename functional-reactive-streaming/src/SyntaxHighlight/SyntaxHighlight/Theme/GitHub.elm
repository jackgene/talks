module SyntaxHighlight.Theme.GitHub exposing (theme)

import Css exposing (rgb, rgba)
import Dict
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- GitHub inspired theme
theme : Theme
theme =
  { default = noEmphasis (rgb 0x24 0x29 0x2e) (rgb 0xff 0xff 0xff)
  , selection = backgroundColor (rgb 0xff 0xfb 0xdd)
  , addition = backgroundColor (rgb 0xea 0xff 0xea)
  , deletion = backgroundColor (rgb 0xff 0xec 0xec)
  , error = squigglyUnderline (rgba 255 0 0 0.75) noStyle
  , warning = squigglyUnderline (rgba 255 255 0 0.75) noStyle
  , comment = textColor (rgb 0x96 0x98 0x96)
  , number = textColor (rgb 0x00 0x5c 0xc5)
  , string = textColor (rgb 0xdf 0x50 0x00)
  , keyword = textColor (rgb 0xd7 0x3a 0x49)
  , declarationKeyword = textColor (rgb 0x00 0x86 0xb3)
  , builtIn = textColor (rgb 0x00 0x86 0xb3)
  , functionDeclaration = textColor (rgb 0x63 0xa3 0x5c)
  , literal = textColor (rgb 0x00 0x5c 0xc5)
  , functionArgument = textColor (rgb 0x79 0x5d 0xa3)

  , namespace = noStyle
  , operator = noStyle
  , typeDeclaration = noStyle
  , typeReference = noStyle
  , functionReference = noStyle
  , fieldDeclaration = noStyle
  , fieldReference = noStyle
  , annotation = noStyle
  , other = Dict.empty
  , gutter = noStyle
  }
