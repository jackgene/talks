module Main exposing (..)

import Css exposing
  ( Style, absolute, bottom, em, fontFamily, fontSize, height, left, margin2
  , overflow, pc, position, rgb, right, sansSerif, scroll, top, width, zero
  )
import Dict exposing (Dict)
import Examples exposing (..)
import Html.Styled as Html exposing
  ( Attribute, Html
  , br, div, fieldset, input, label, legend, option, select, text
  )
import Html.Styled.Attributes exposing (checked, css, selected, type_, value)
import Html.Styled.Events exposing (on, onCheck, targetValue)
import Http exposing (decodeUri)
import Json.Decode as Json
import Navigation exposing (Location)
import Parser
import Regex exposing (HowMany(..), regex)
import Set exposing (Set)
import SyntaxHighlight.Model exposing (Block, ColumnEmphasisType(..), LineEmphasis(..), Theme)
import SyntaxHighlight exposing (toBlockHtml)
import SyntaxHighlight.Language as Language
import SyntaxHighlight.Line as Line
import SyntaxHighlight.Theme as Theme
import SyntaxHighlight.Theme.Common exposing
  ( bold, noEmphasis, noStyle, textColor )


-- Model
type alias SourceCode =
  { language : String
  , text : String
  , parser : String -> Result Parser.Error Block
  }


type alias NamedTheme =
  { name : String
  , definition : Theme
  }


type alias HighlightedToken =
  { comment : Bool
  , namespace : Bool
  , keyword : Bool
  , declarationKeyword : Bool
  , builtIn : Bool
  , operator : Bool
  , number : Bool
  , string : Bool
  , literal : Bool
  , typeDeclaration : Bool
  , typeReference : Bool
  , functionDeclaration : Bool
  , functionReference : Bool
  , functionArgument : Bool
  , fieldDeclaration : Bool
  , fieldReference : Bool
  , annotation : Bool
  }


type alias Model =
  { sourceCode : SourceCode
  , sourceCodesByLanguage : Dict String SourceCode
  , addAndRemovedLines : Set Int
  , firstLine : Maybe Int
  , theme : NamedTheme
  , highlightedToken : HighlightedToken
  }


-- Constants
highlightTokensThemeName : String
highlightTokensThemeName = "Highlight Tokens"


darcula : NamedTheme
darcula = NamedTheme "Darcula" Theme.darcula


themesByName : Dict String NamedTheme
themesByName =
  Dict.fromList
  ( List.map
    ( \theme -> (theme.name, theme) )
    [ darcula
    , NamedTheme "GitHub" Theme.gitHub
    , NamedTheme "Monokai" Theme.monokai
    , NamedTheme "OneDark" Theme.oneDark
    ]
  )


defaultTypeScriptSourceCode : SourceCode
defaultTypeScriptSourceCode =
  SourceCode "TypeScript" typeScriptExample Language.typeScript


defaultSourceCodesByLanguage : Dict String SourceCode
defaultSourceCodesByLanguage =
  Dict.fromList
  ( List.map
    ( \code -> (code.language, code) )
    [ SourceCode "CSS" cssExample Language.typeScript
    , SourceCode "Elm" elmExample Language.elm
    , SourceCode "Go" goExample Language.go
    , SourceCode "Kotlin" kotlinExample Language.kotlin
    , SourceCode "Python" pythonExample Language.python
    , SourceCode "Swift" swiftExample Language.swift
    , defaultTypeScriptSourceCode
    , SourceCode "XML" xmlExample Language.xml
    ]
  )


-- Common
themeByName : HighlightedToken -> String -> Maybe NamedTheme
themeByName highlightedToken name =
  if name /= highlightTokensThemeName then Dict.get name themesByName
  else
    Just
    ( NamedTheme highlightTokensThemeName
      ( tokenHighlightingTheme highlightedToken )
    )


applyHashState : String -> Model -> Model
applyHashState hash model =
  let
    hashParams : Dict String String
    hashParams =
      Dict.fromList
      ( List.filterMap
        ( \eqDelimKeyVal ->
          case Regex.split (AtMost 2) (regex "=") eqDelimKeyVal of
            key :: uriEncodedValue :: _ ->
              Maybe.map
              ( \value -> (key, value) )
              ( decodeUri uriEncodedValue )
            _ -> Nothing
        )
        ( String.split "&" (String.dropLeft 1 hash) )
      )

    sourceCode : SourceCode
    sourceCode =
      Maybe.withDefault defaultTypeScriptSourceCode
      ( Maybe.andThen
        ( \languageName -> Dict.get languageName defaultSourceCodesByLanguage )
        ( Dict.get "language" hashParams )
      )

    tokens : Set String
    tokens =
      Maybe.withDefault Set.empty
      ( Maybe.map
        ( Set.fromList << String.split "|" )
        ( Dict.get "tokens" hashParams )
      )

    highlightedToken : HighlightedToken
    highlightedToken =
      { comment = Set.member "comm" tokens
      , namespace = Set.member "ns" tokens
      , keyword = Set.member "kw" tokens
      , declarationKeyword = Set.member "dkw" tokens
      , builtIn = Set.member "bltn" tokens
      , operator = Set.member "op" tokens
      , number = Set.member "num" tokens
      , string = Set.member "str" tokens
      , literal = Set.member "lit" tokens
      , typeDeclaration = Set.member "typd" tokens
      , typeReference = Set.member "typ" tokens
      , functionDeclaration = Set.member "fncd" tokens
      , functionReference = Set.member "fnc" tokens
      , functionArgument = Set.member "arg" tokens
      , fieldDeclaration = Set.member "fldd" tokens
      , fieldReference = Set.member "fld" tokens
      , annotation = Set.member "ann" tokens
      }

    theme : NamedTheme
    theme =
      Maybe.withDefault darcula
      ( Maybe.andThen
        ( themeByName highlightedToken )
        ( Dict.get "theme" hashParams )
      )
  in
  { model
  | sourceCode = sourceCode
  , theme = theme
  , highlightedToken = highlightedToken
  }


-- Init
emptyHighlightedToken : HighlightedToken
emptyHighlightedToken =
  HighlightedToken
  False False False False False False False False False
  False False False False False False False False


init : Location -> (Model, Cmd Msg)
init location =
  ( applyHashState location.hash
    { sourceCode = defaultTypeScriptSourceCode
    , sourceCodesByLanguage = defaultSourceCodesByLanguage
    , addAndRemovedLines = Set.empty
    , firstLine = Just 1
    , theme = darcula
    , highlightedToken = emptyHighlightedToken
    }
  , Cmd.none
  )


-- Update
type Msg
  = LanguageByName String
  | ToggleAddRemove Bool
  | ThemeByName String
  | TokenHighlightingState (HighlightedToken -> Bool -> HighlightedToken) Bool
  | NewLocation Location


tokenHighlightingTheme : HighlightedToken -> Theme
tokenHighlightingTheme token =
  let
    highlight : Style
    highlight = bold (textColor (rgb 128 0 0))
  in
  { default = noEmphasis (rgb 144 144 144) (rgb 240 240 240)
  , selection = noStyle
  , addition = noStyle
  , deletion = noStyle
  , error = noStyle
  , warning = noStyle
  , comment = if token.comment then highlight else noStyle
  , namespace = if token.namespace then highlight else noStyle
  , keyword = if token.keyword then highlight else noStyle
  , declarationKeyword = if token.declarationKeyword then highlight else noStyle
  , builtIn = if token.builtIn then highlight else noStyle
  , operator = if token.operator then highlight else noStyle
  , number = if token.number then highlight else noStyle
  , string = if token.string then highlight else noStyle
  , literal = if token.literal then highlight else noStyle
  , typeDeclaration = if token.typeDeclaration then highlight else noStyle
  , typeReference = if token.typeReference then highlight else noStyle
  , functionDeclaration = if token.functionDeclaration then highlight else noStyle
  , functionArgument = if token.functionArgument then highlight else noStyle
  , functionReference = if token.functionReference then highlight else noStyle
  , fieldDeclaration = if token.fieldDeclaration then highlight else noStyle
  , fieldReference = if token.fieldReference then highlight else noStyle
  , annotation = if token.annotation then highlight else noStyle
  , other = Dict.empty
  , gutter = noEmphasis (rgb 120 120 120) (rgb 224 224 224)
  }


hashOf : String -> String -> HighlightedToken -> String
hashOf languageName themeName tokens =
  "#language=" ++ languageName ++
  "&theme=" ++ themeName ++
  ( if themeName /= highlightTokensThemeName then ""
    else
      "&tokens=" ++
      ( String.join "|"
        ( ( if tokens.comment then [ "comm" ] else [] )
        ++( if tokens.namespace then [ "ns" ] else [] )
        ++( if tokens.keyword then [ "kw" ] else [] )
        ++( if tokens.declarationKeyword then [ "dkw" ] else [] )
        ++( if tokens.builtIn then [ "bltn" ] else [] )
        ++( if tokens.operator then [ "op" ] else [] )
        ++( if tokens.number then [ "num" ] else [] )
        ++( if tokens.string then [ "str" ] else [] )
        ++( if tokens.literal then [ "lit" ] else [] )
        ++( if tokens.typeDeclaration then [ "typd" ] else [] )
        ++( if tokens.typeReference then [ "typ" ] else [] )
        ++( if tokens.functionDeclaration then [ "fncd" ] else [] )
        ++( if tokens.functionReference then [ "fnc" ] else [] )
        ++( if tokens.functionArgument then [ "arg" ] else [] )
        ++( if tokens.fieldDeclaration then [ "fldd" ] else [] )
        ++( if tokens.fieldReference then [ "fld" ] else [] )
        ++( if tokens.annotation then [ "ann" ] else [] )
        )
      )
  )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LanguageByName languageName ->
      ( model
      , Navigation.newUrl
        (hashOf languageName model.theme.name model.highlightedToken)
      )

    ToggleAddRemove highlightAddRemove ->
      ( { model
        | addAndRemovedLines =
          if not highlightAddRemove then Set.empty else Set.fromList [ 5 ]
        }
      , Cmd.none
      )

    ThemeByName themeName ->
      ( model
      , Navigation.newUrl
        (hashOf model.sourceCode.language themeName model.highlightedToken)
      )

    TokenHighlightingState updateHighlightedToken highlight ->
      let
        currentTheme : NamedTheme
        currentTheme = model.theme

        newHighlightedToken : HighlightedToken
        newHighlightedToken = updateHighlightedToken model.highlightedToken highlight
      in
      ( { model
        | highlightedToken = newHighlightedToken
        , theme =
          { currentTheme
          | definition = tokenHighlightingTheme newHighlightedToken
          }
        }
      , Navigation.newUrl (hashOf model.sourceCode.language currentTheme.name newHighlightedToken)
      )

    NewLocation location ->
      ( applyHashState location.hash model
      , Cmd.none
      )


-- View
onChange : (String -> msg) -> Attribute msg
onChange tagger = on "change" (Json.map tagger targetValue)


optionsView : String -> List String -> List (Html Msg)
optionsView current =
  List.map
  ( \item ->
    option
    [ selected (current == item), value item ]
    [ text item ]
  )


--numberInput : String -> Int -> (Int -> Msg) -> Html Msg
--numberInput labelText defaultVal msg =
--  label []
--  [ text labelText
--  , input
--    [ type_ "number"
--    , onInput (msg << Result.withDefault 0 << String.toInt)
--    , defaultValue (toString defaultVal)
--    ]
--    []
--  ]


booleanInput : String -> Bool -> (Bool -> Msg) -> Html Msg
booleanInput labelText currentChecked msg =
  label []
  [ text labelText
  , input
    [ type_ "checkbox"
    , checked currentChecked
    , onCheck msg
    ]
    []
  ]


highlightTokenFormFieldView : String -> Bool -> (HighlightedToken -> Bool -> HighlightedToken) -> Html Msg
highlightTokenFormFieldView tokenName currentChecked updateHighlightedToken =
  div []
  [ label []
    [ input
      [ type_ "checkbox"
      , checked currentChecked
      , onCheck (TokenHighlightingState updateHighlightedToken)
      ]
      []
    , text tokenName
    ]
  ]


highlightTokenFormView : HighlightedToken -> Html Msg
highlightTokenFormView tokens =
  fieldset [ css [ margin2 (em 0.5) zero ] ]
  [ legend [] [ text "Tokens to Highlight" ]
  , highlightTokenFormFieldView "Comment" tokens.comment
    ( \tokens value -> { tokens | comment = value } )
  , highlightTokenFormFieldView "Namespace" tokens.namespace
    ( \tokens value -> { tokens | namespace = value } )
  , highlightTokenFormFieldView "Keyword" tokens.keyword
    ( \tokens value -> { tokens | keyword = value } )
  , highlightTokenFormFieldView "Declaration Keyword" tokens.declarationKeyword
    ( \tokens value -> { tokens | declarationKeyword = value } )
  , highlightTokenFormFieldView "Built-In" tokens.builtIn
    ( \tokens value -> { tokens | builtIn = value } )
  , highlightTokenFormFieldView "Operator" tokens.operator
    ( \tokens value -> { tokens | operator = value } )
  , highlightTokenFormFieldView "Number" tokens.number
    ( \tokens value -> { tokens | number = value } )
  , highlightTokenFormFieldView "String" tokens.string
    ( \tokens value -> { tokens | string = value } )
  , highlightTokenFormFieldView "Literal" tokens.literal
    ( \tokens value -> { tokens | literal = value } )
  , highlightTokenFormFieldView "Type Declaration" tokens.typeDeclaration
    ( \tokens value -> { tokens | typeDeclaration = value } )
  , highlightTokenFormFieldView "Type Reference" tokens.typeReference
    ( \tokens value -> { tokens | typeReference = value } )
  , highlightTokenFormFieldView "Function Declaration" tokens.functionDeclaration
    ( \tokens value -> { tokens | functionDeclaration = value } )
  , highlightTokenFormFieldView "Function Reference" tokens.functionReference
    ( \tokens value -> { tokens | functionReference = value } )
  , highlightTokenFormFieldView "Function Argument" tokens.functionArgument
    ( \tokens value -> { tokens | functionArgument = value } )
  , highlightTokenFormFieldView "Field Declaration" tokens.fieldDeclaration
    ( \tokens value -> { tokens | fieldDeclaration = value } )
  , highlightTokenFormFieldView "Field Reference" tokens.fieldReference
    ( \tokens value -> { tokens | fieldReference = value } )
  , highlightTokenFormFieldView "Annotation" tokens.annotation
    ( \tokens value -> { tokens | annotation = value } )
  ]


view : Model -> Html Msg
view model =
  div [ css [ fontFamily sansSerif ] ]
  [ div
    [ css
      [ position absolute
      , top (pc 1), width (pc 16), height (pc 1), left (pc 1)
      ]
    ]
    ( label []
      [ text "Language: "
      , select [ onChange LanguageByName ]
        (optionsView model.sourceCode.language (Dict.keys defaultSourceCodesByLanguage))
      ]
    ::br [] []
    ::label []
      [ text "Theme: "
      , select [ onChange ThemeByName ]
        (optionsView model.theme.name ((Dict.keys themesByName) ++ [ highlightTokensThemeName ]))
      ]
    ::br [] []
    ::( if model.theme.name /= highlightTokensThemeName then []
        else [ highlightTokenFormView model.highlightedToken ]
      )
    ++[ booleanInput "Add/Remove Lines: " (not (Set.isEmpty model.addAndRemovedLines)) ToggleAddRemove ]
    )
  , div
    [ css
      [ position absolute
      , top (pc 1), right (pc 1), bottom (pc 1), left (pc 18)
      , overflow scroll
      , fontSize (em 1.5)
      ]
    ]
    [ let
        sourceCodeRes : Result Parser.Error (Html Msg)
        sourceCodeRes =
          Result.map
          ( \block ->
            let
              lineEmphasizedBlock : Block
              lineEmphasizedBlock =
                List.concatMap
                ( \(idx, line) ->
                  if not (Set.member (idx + 1) model.addAndRemovedLines) then [ line ]
                  else
                    ( Line.emphasizeLines Deletion 0 1 [ line ]
                    ++Line.emphasizeLines Addition 0 1 [ line ]
                    )
                )
                ( List.indexedMap (,) block )

              emphasizedBlock : Block
              emphasizedBlock =
                if Set.isEmpty model.addAndRemovedLines then lineEmphasizedBlock
                else
                  Line.emphasizeColumns
                  [ { emphasis = Error, start = 0, length = 6 }
                  ] 0
                  ( Line.emphasizeColumns
                    [ { emphasis = Warning, start = 0, length = 3 }
                    ]
                    7 lineEmphasizedBlock
                  )
            in
            toBlockHtml model.theme.definition (Just 1) emphasizedBlock
          )
          ( model.sourceCode.parser model.sourceCode.text )
      in
        case sourceCodeRes of
          Ok sourceCodeBlock -> sourceCodeBlock
          Err error ->
            text
            ( "(" ++ toString error.row ++ ":" ++ toString error.col ++ ") " ++
              case error.problem of
              Parser.BadOneOf _ -> "BadOneOf ..."
              Parser.BadInt -> "BadInt"
              Parser.BadFloat -> "BadFloat"
              Parser.BadRepeat -> "BadRepeat"
              Parser.ExpectingEnd -> "Expectingend"
              Parser.ExpectingSymbol s -> "ExpectingSymbol " ++ s
              Parser.ExpectingKeyword s -> "ExpectingKeyword " ++ s
              Parser.ExpectingVariable -> "ExpectingVariable."
              Parser.ExpectingClosing s -> "ExpectingClosing " ++ s
              Parser.Fail s -> "Fail " ++ s
            )
    ]
  ]


main : Program Never Model Msg
main =
  Navigation.program NewLocation
  { init = init
  , update = update
  , subscriptions = always Sub.none
  , view = Html.toUnstyled << view
  }
