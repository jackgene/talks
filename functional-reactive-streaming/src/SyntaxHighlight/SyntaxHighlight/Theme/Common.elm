module SyntaxHighlight.Theme.Common exposing (..)

import Css exposing
  ( Color, Style
  -- Content
  , fontStyle, fontWeight, textDecoration3
  -- Other values
  , lineThrough, solid, underline, wavy
  )


noStyle : Style
noStyle = Css.batch []


noEmphasis : Color -> Color -> Style
noEmphasis text background = Css.batch [ textColor text, backgroundColor background ]


textColor : Color -> Style
textColor text = Css.color text


backgroundColor : Color -> Style
backgroundColor background = Css.backgroundColor background


italic : Style -> Style
italic style = Css.batch [ style, fontStyle Css.italic ]


bold : Style -> Style
bold style = Css.batch [ style, fontWeight Css.bold ]


strikeThrough : Color -> Style -> Style
strikeThrough color style =
  Css.batch
  [ style
  , textDecoration3 lineThrough solid color
  ]


squigglyUnderline : Color -> Style -> Style
squigglyUnderline color style =
  Css.batch
  [ style
  , textDecoration3 underline wavy color
  ]
