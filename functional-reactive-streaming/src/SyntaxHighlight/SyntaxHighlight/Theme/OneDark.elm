module SyntaxHighlight.Theme.OneDark exposing (theme)

import Css exposing (rgb, rgba)
import Dict
import SyntaxHighlight.Model exposing (Theme)
import SyntaxHighlight.Theme.Common exposing (..)


{-
   Author: Baransu (https://github.com/Baransu)
   Atom One Dark inspired theme
   https://github.com/atom/one-dark-syntax

   base:    #282c34
   mono-1:  #abb2bf
   mono-2:  #818896
   mono-3:  #5c6370
   hue-1:   #56b6c2
   hue-2:   #61aeee
   hue-3:   #c678dd
   hue-4:   #98c379
   hue-5:   #e06c75
   hue-5-2: #be5046
   hue-6:   #d19a66
   hue-6-2: #e6c07b
-}
theme : Theme
theme =
  { default = noEmphasis (rgb 0xab 0xb2 0xbf) (rgb 0x28 0x2c 0x34)
  , selection = backgroundColor (rgba 229 231 235 0.1)
  , addition = backgroundColor (rgba 40 124 82 0.4)
  , deletion = backgroundColor (rgba 136 64 67 0.4)
  , error = squigglyUnderline (rgba 255 0 0 0.75) noStyle
  , warning = squigglyUnderline (rgba 255 255 0 0.75) noStyle
  , comment = italic (textColor (rgb 0x5c 0x63 0x70))
  , number = textColor (rgb 0xd1 0x9a 0x66)
  , string = textColor (rgb 0x98 0xc3 0x79)
  , keyword = textColor (rgb 0xc6 0x78 0xdd)
  , declarationKeyword = textColor (rgb 0xc6 0x78 0xdd)
  , builtIn = textColor (rgb 0xc6 0x78 0xdd)
  , functionDeclaration = textColor (rgb 0x61 0xae 0xee)
  , literal = textColor (rgb 0xd1 0x9a 0x66)
  , functionArgument = textColor (rgb 0xab 0xb2 0xbf)

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
