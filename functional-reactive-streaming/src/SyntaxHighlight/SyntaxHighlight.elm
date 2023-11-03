module SyntaxHighlight exposing (toBlockHtml, toInlineHtml)

{-| Syntax highlighting in Elm.

## Html view

@docs toBlockHtml, toInlineHtml


## Helpers

@docs Highlight, highlightLines


## Languages

Error while parsing should not happen. If it happens, please [open an issue](https://github.com/pablohirafuji/elm-syntax-highlight/issues) with the code that gives the error and the language.

@docs css, elm, javascript, python, xml


## Themes

@docs useTheme

-}

import Html.Styled exposing (Html)
import SyntaxHighlight.Model as Model exposing (Theme)
import SyntaxHighlight.View as View


type alias Block = Model.Block
type alias Line = Model.Line


{-| Transform a highlighted code into a Html block.
The `Maybe Int` argument is for showing or not line count and, if so, starting from what number.
-}
toBlockHtml : Model.Theme -> Maybe Int -> Block -> Html msg
toBlockHtml theme maybeStart lines =
    View.toBlockHtml theme maybeStart lines


{-| Transform a highlighted code into inline Html.

    import SyntaxHighlight exposing (elm, toInlineHtml)

    info : Html msg
    info =
        p []
            [ text "This function signature "
            , elm "isEmpty : String -> Bool"
                |> Result.map toInlineHtml
                |> Result.withDefault
                    (code [] [ text "isEmpty : String -> Bool" ])
            , text " means that a String argument is taken, then a Bool is returned."
            ]

-}
toInlineHtml : Model.Theme -> Line -> Html msg
toInlineHtml theme line =
    View.toInlineHtml theme line
