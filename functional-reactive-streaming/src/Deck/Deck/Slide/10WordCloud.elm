module Deck.Slide.WordCloud exposing (wordCloud)

import Css exposing
  ( Color, Style
  -- Container
  , bottom, display, displayFlex, height, left, listStyle, overflow, padding2, position, right, width
  -- Content
  , alignItems, color, flexWrap, fontSize, justifyContent, lineHeight, opacity
  -- Units
  , em, num, vw, zero
  -- Alignment & Positions
  , absolute, relative
  -- Transform
  -- Other values
  , block, center, hidden, none, wrap
  )
import Css.Transitions exposing (easeInOut, transition)
import Deck.Slide.Common exposing (..)
import Deck.Slide.Graphics exposing (wordSubmitterAppQrCode)
import Deck.Slide.Template exposing (standardSlideView)
import Dict exposing (Dict)
import Html.Styled exposing (Html, div, text, ul)
import Html.Styled.Attributes exposing (css, title)
import WordCloud exposing (WordCounts)


-- Constants
maxWordDisplayCount : Int
maxWordDisplayCount = 11


-- View
-- Slides
wordCloud : String -> String -> UnindexedSlideModel
wordCloud heading subheading =
  { baseSlideModel
  | view =
    ( \page model ->
      standardSlideView page heading subheading
      ( div []
        [ div
          [ css
            [ position absolute
            , bottom (vw 4), right (vw 2.5), width (vw 58)
            , fontSize (em 0.8)
            ]
          ]
          [ div [ css [ position absolute, bottom (em 1.375), left zero] ] [ text "Submit words at http://wordcloud.jackleow.com" ]
          , div [ css [ position absolute, bottom zero, right zero] ] [ wordSubmitterAppQrCode "20vw" ]
          ]
        , div
          [ css
            [ height (vw (if Dict.isEmpty model.wordCloud.countsByWord then 20 else 0))
            , overflow hidden
            , transition
              [ Css.Transitions.opacity3 transitionDurationMs 0 easeInOut
              , Css.Transitions.height3 transitionDurationMs 0 easeInOut
              ]
            ]
          ]
          [ ul []
            [ li [] [ text "Think of up to three words you associate with Functional Reactive Streaming" ]
            , li [] [ text "Send it in at the link below" ]
            , li [] [ text "Send as many words as you want, but only the last three words will be counted" ]
            ]
          ]
        , div
          [ css
            ( if Dict.isEmpty model.wordCloud.countsByWord then [ display none ]
              else [ display block, height (vw 32), overflow hidden ]
            )
          ]
          -- From https://alvaromontoro.com/blog/67945/create-a-tag-cloud-with-html-and-css
          [ ul
            [ css
              [ displayFlex, flexWrap wrap, position relative
              , listStyle none, alignItems center, justifyContent center, lineHeight (vw 2)
              ]
            ]
            ( let
                topWordsAndCounts : List (String, Int)
                topWordsAndCounts = WordCloud.topWords maxWordDisplayCount model.wordCloud

                maxCount : Float
                maxCount =
                  Maybe.withDefault 0.0
                  ( Maybe.map (toFloat << Tuple.second) (List.head topWordsAndCounts) )
              in
              ( List.map
                ( \(word, count) ->
                  let
                    percentage : Float
                    percentage = toFloat count / maxCount
                  in
                  li []
                  [ div
                    [ css
                      [ padding2 (em 0.125) (em 0.25)
                      , color themeForegroundColor, opacity (num (percentage * 0.75 + 0.25))
                      , fontSize (em (3.6 * (percentage * 0.75 + 0.25)))
                      , transition [ Css.Transitions.fontSize3 transitionDurationMs 0 easeInOut ]
                      ]
                    , title (toString count)
                    ]
                    [ text word ]
                  ]
                )
                ( List.sort topWordsAndCounts )
              )
            )
          ]
        ]
      )
    )
  , eventsWsPath = Just "word-cloud"
  }
