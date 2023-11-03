module SyntaxHighlight.Theme.Monokai exposing (theme)

import Css exposing (rgb, rgba)
import Dict
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


-- Monokai inspired theme
theme : Theme
theme =
  { default = noEmphasis (rgb 0xf8 0xf8 0xf2) (rgb 0x23 0x24 0x1f)
  , selection = backgroundColor (rgb 0x34 0x34 0x34)
  , addition = backgroundColor (rgb 0x00 0x38 0x00)
  , deletion = backgroundColor (rgb 0x38 0x00 0x00)
  , error = squigglyUnderline (rgba 255 0 0 0.75) noStyle
  , warning = squigglyUnderline (rgba 255 255 0 0.75) noStyle
  , comment = textColor (rgb 0x75 0x71 0x5e)
  , number = textColor (rgb 0xae 0x81 0xff)
  , string = textColor (rgb 0xe6 0xdb 0x74)
  , keyword = textColor (rgb 0xf9 0x26 0x72)
  , declarationKeyword = textColor (rgb 0x66 0xd9 0xef)
  , builtIn = textColor (rgb 0x66 0xd9 0xef)
  , functionDeclaration = textColor (rgb 0xa6 0xe2 0x2e)
  , literal = textColor (rgb 0xae 0x81 0xff)
  , functionArgument = textColor (rgb 0xfd 0x97 0x1f)

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
