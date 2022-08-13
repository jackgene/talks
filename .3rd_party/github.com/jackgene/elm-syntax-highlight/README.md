# Elm Syntax Highlight
Syntax highlighting in Elm. [Demo](https://pablohirafuji.github.io/elm-syntax-highlight/).


## Themes
You can define the theme either by copying and pasting the theme styles into your `.css` file or using the `useTheme` helper.

### Copying and pasting the theme
The theme and required styles can be found [here](https://pablohirafuji.github.io/elm-syntax-highlight/themes.html).

### Using `useTheme` helper
Place the `useTheme` function with your chosen theme anywhere on your view.

```elm
import SyntaxHighlight exposing (useTheme, monokai, elm, toBlockHtml)

view : Model -> Html msg
view model =
    div []
        [ useTheme monokai
        , elm model.elmCode
            |> Result.map (toBlockHtml (Just 1))
            |> Result.withDefault
                (pre [] [ code [] [ text model.elmCode ]])
        ]
```


## Building
Symlink the included murmur3 library into `elm-stuff`:
```
mkdir -p elm-stuff/packages/Skinney/murmur3
ln -s ../../../../extras/Skinney/murmur3/2.0.6 elm-stuff/packages/Skinney/murmur3 
```
(This is an elm-css requirement, and this step needs to be done because the original murmur3 files have been removed from where it was originally hosted)

Then run `elm make`:
```
elm make --yes
```

## Thanks
Thank you Evan for bringing joy to the frontend.
