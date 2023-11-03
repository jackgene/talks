module SyntaxHighlight.Line exposing (emphasizeColumns, emphasizeLines)

{-| A parsed highlighted line.

## Helpers

@docs highlightLines

-}

import SyntaxHighlight.Model exposing (..)


emphasizeLines : LineEmphasis -> Int -> Int -> Block -> Block
emphasizeLines emphasis start end lines =
  let
    length =
      List.length lines

    adjStart =
      if start >= 0 then start
      else length + start

    adjEnd =
      if end >= 0 then end
      else length + end
  in
  List.indexedMap
  ( \index line ->
    if index < adjStart || index >= adjEnd then line
    else { line | emphasis = Just emphasis }
  )
  lines


emphasizeColumns : List ColumnEmphasis -> Int -> Block -> Block
emphasizeColumns emphases index lines =
  let
    length =
      List.length lines

    adjIndex =
      if index >= 0 then index
      else length + index
  in
  List.indexedMap
  ( \index line ->
    if index /= adjIndex then line
    else { line | columnEmphases = emphases }
  )
  lines
