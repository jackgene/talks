module Deck.Slide.ExampleApplication exposing
  ( heading, slides
  , implementationCompleteDistribution, implementationCompleteEventSourcing
  )

import Char
import Css exposing
  ( Color, Style
  -- Container
  , bottom, borderRadius, borderSpacing, boxShadow5, display, height, left
  , margin2, maxWidth, overflow, paddingTop, position, right, textOverflow
  , top, width
  -- Content
  , backgroundColor, backgroundImage, color, fontSize, opacity, textAlign
  , verticalAlign
  -- Units
  , em, num, pct, rgba, vw, zero
  -- Alignment & Positions
  , absolute, relative
  -- Transform
  -- Other values
  , center, ellipsis, hidden, linearGradient, none, noWrap, stop, whiteSpace
  )
import Css.Transitions exposing (easeInOut, transition)
import Deck.Slide.Common exposing (..)
import Deck.Slide.MarbleDiagram exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Dict exposing (Dict)
import Html.Styled exposing (Html, br, div, p, table, td, text, th, tr)
import Html.Styled.Attributes exposing (css)
import Set
import WordCloud exposing (WordCounts)


-- Constants
heading : String
heading = "Word Cloud as a Functional Reactive Stream"


-- View
-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Building an Application by Composing Operations"
      ( div []
        [ p []
          [ text "Now that we have had a look at some common operators, we will next look at how we can compose operations to build an application." ]
        , p []
          [ text "Let’s build a application that is simple, but not trivially so: A word cloud." ]
        ]
      )
    )
  }


collecting : UnindexedSlideModel
collecting =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Exposing the Word Counts to the Front End"
      ( div []
        [ p []
          [ text "Finally, we need to make the word counts available to some sort of front end. "
          , text "A naïve WebSocket endpoint in Pekko HTTP might look like:"
          ]
        , div []
          [ syntaxHighlightedCodeBlock Scala Dict.empty Dict.empty []
      """
path("/word-counts") {
  handleWebSocketMessages(
    Flow.fromSinkAndSource(
      Sink.ignore,
      wordCounts.map { (counts: Map[String, Int]) =>
        TextMessage(counts.toJson.compactPrint)
      }
    )
  )
}
"""
          ]
        , p []
          [ text "Full source: https://github.com/jackgene/reactive-word-cloud-scala"
          ]
        ]
      )
    )
  }


type alias StepAdjustedHorizontalPosition =
  { base : HorizontalPosition
  , leftEmAdjustmentByStep : Dict Int Float
  }


type alias SlideLayout =
  { leftEm : Float
  , marginWidthEm : Float
  }


leftEmAfter : HorizontalPosition -> Float
leftEmAfter pos = pos.leftEm + pos.widthEm


horizontalPosition : StepAdjustedHorizontalPosition -> Int -> HorizontalPosition
horizontalPosition { base, leftEmAdjustmentByStep } step =
  { base
  | leftEm =
    base.leftEm + (Maybe.withDefault 0 (Dict.get step leftEmAdjustmentByStep))
  }


chatMessagesBasePos : HorizontalPosition
chatMessagesBasePos =
  { leftEm = 0
  , widthEm = 20
  }


mapNormalizeTextBasePos : HorizontalPosition
mapNormalizeTextBasePos =
  { leftEm = leftEmAfter chatMessagesBasePos
  , widthEm = 8.75
  }


normalizedTextBasePos : HorizontalPosition
normalizedTextBasePos =
  { leftEm = leftEmAfter mapNormalizeTextBasePos
  , widthEm = 18
  }


flatMapConcatSplitIntoWordsBasePos : HorizontalPosition
flatMapConcatSplitIntoWordsBasePos =
  { leftEm = leftEmAfter normalizedTextBasePos
  , widthEm = 9.25
  }


rawWordsBasePos : HorizontalPosition
rawWordsBasePos =
  { leftEm = leftEmAfter flatMapConcatSplitIntoWordsBasePos
  , widthEm = 12
  }


filterIsValidWordBasePos : HorizontalPosition
filterIsValidWordBasePos =
  { leftEm = leftEmAfter rawWordsBasePos
  , widthEm = 8
  }


validatedWordsBasePos : HorizontalPosition
validatedWordsBasePos =
  { leftEm = leftEmAfter filterIsValidWordBasePos
  , widthEm = 12
  }


runningFoldUpdateWordsForSenderBasePos : HorizontalPosition
runningFoldUpdateWordsForSenderBasePos =
  { leftEm = leftEmAfter validatedWordsBasePos
  , widthEm = 12
  }


wordsBySendersBasePos : HorizontalPosition
wordsBySendersBasePos =
  { leftEm = leftEmAfter runningFoldUpdateWordsForSenderBasePos
  , widthEm = 20
  }


mapCountSendersForWordBasePos : HorizontalPosition
mapCountSendersForWordBasePos =
  { leftEm = leftEmAfter wordsBySendersBasePos
  , widthEm = 11.5
  }


senderCountsByWordBasePos : HorizontalPosition
senderCountsByWordBasePos =
  { leftEm = leftEmAfter mapCountSendersForWordBasePos
  , widthEm = 14.5
  }


magnifiedWidthEm : Float
magnifiedWidthEm = leftEmAfter normalizedTextBasePos


magnifiedMarginWidthEm : HorizontalPosition -> HorizontalPosition -> Float
magnifiedMarginWidthEm left right =
  (magnifiedWidthEm - leftEmAfter right + left.leftEm) / 2


slideLayoutForStreams : HorizontalPosition -> HorizontalPosition -> SlideLayout
slideLayoutForStreams leftPos rightPos =
  let
    marginWidthEm : Float
    marginWidthEm = magnifiedMarginWidthEm leftPos rightPos
  in
  { leftEm = leftPos.leftEm - marginWidthEm
  , marginWidthEm = marginWidthEm
  }


implementation1Layout : SlideLayout
implementation1Layout =
  slideLayoutForStreams chatMessagesBasePos chatMessagesBasePos


implementation2Layout : SlideLayout
implementation2Layout =
  slideLayoutForStreams chatMessagesBasePos normalizedTextBasePos


implementation3Layout : SlideLayout
implementation3Layout =
  slideLayoutForStreams normalizedTextBasePos rawWordsBasePos


implementation4Layout : SlideLayout
implementation4Layout =
  slideLayoutForStreams rawWordsBasePos validatedWordsBasePos


implementation5Layout : SlideLayout
implementation5Layout =
  slideLayoutForStreams validatedWordsBasePos wordsBySendersBasePos


implementation6Layout : SlideLayout
implementation6Layout =
  slideLayoutForStreams wordsBySendersBasePos senderCountsByWordBasePos


chatMessagesPos : StepAdjustedHorizontalPosition
chatMessagesPos =
  { base = chatMessagesBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (2, -implementation3Layout.marginWidthEm)
    ]
  }


mapNormalizeTextPos : StepAdjustedHorizontalPosition
mapNormalizeTextPos =
  { base = mapNormalizeTextBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (0, implementation1Layout.marginWidthEm)
    , (2, -implementation3Layout.marginWidthEm)
    ]
  }


normalizedTextPos : StepAdjustedHorizontalPosition
normalizedTextPos =
  { base = normalizedTextBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (0, implementation1Layout.marginWidthEm)
    , (3, -implementation4Layout.marginWidthEm)
    ]
  }


flatMapConcatSplitIntoWordsPos : StepAdjustedHorizontalPosition
flatMapConcatSplitIntoWordsPos =
  { base = flatMapConcatSplitIntoWordsBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (3, -implementation4Layout.marginWidthEm)
    ]
  }


rawWordsPos : StepAdjustedHorizontalPosition
rawWordsPos =
  { base = rawWordsBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (4, -implementation5Layout.marginWidthEm)
    ]
  }


filterIsValidWordPos : StepAdjustedHorizontalPosition
filterIsValidWordPos =
  { base = filterIsValidWordBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (2, implementation3Layout.marginWidthEm)
    , (4, -implementation5Layout.marginWidthEm)
    ]
  }


validatedWordsPos : StepAdjustedHorizontalPosition
validatedWordsPos =
  { base = validatedWordsBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (2, implementation3Layout.marginWidthEm)
    ]
  }


runningFoldUpdateWordsForSenderPos : StepAdjustedHorizontalPosition
runningFoldUpdateWordsForSenderPos =
  { base = runningFoldUpdateWordsForSenderBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (3, implementation4Layout.marginWidthEm)
    , (5, -implementation6Layout.marginWidthEm)
    ]
  }


wordsBySendersPos : StepAdjustedHorizontalPosition
wordsBySendersPos =
  { base = wordsBySendersBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (3, implementation4Layout.marginWidthEm)
    ]
  }


mapCountSendersForWordPos : StepAdjustedHorizontalPosition
mapCountSendersForWordPos =
  { base = mapCountSendersForWordBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (4, implementation5Layout.marginWidthEm)
    ]
  }


senderCountsByWordPos : StepAdjustedHorizontalPosition
senderCountsByWordPos =
  { base = senderCountsByWordBasePos
  , leftEmAdjustmentByStep =
    Dict.fromList
    [ (4, implementation5Layout.marginWidthEm)
    ]
  }


streamElementView : HorizontalPosition -> Color -> Float -> Bool -> List (Html msg) -> Html msg
streamElementView pos color opacityNum scaleChanged rows =
  div
  [ css
    [ position absolute, left (em pos.leftEm), borderRadius (em 0.75)
    , backgroundColor white, opacity (num 1)
    , transition
      ( if scaleChanged then []
        else [ Css.Transitions.left3 transitionDurationMs 0 easeInOut ]
      )
    ]
  ]
  [ table
    [ css
      [ width (em pos.widthEm)
      , borderSpacing zero, borderRadius (em 0.75)
      , backgroundColor color, opacity (num opacityNum)
      , boxShadow5 zero (em 0.5) (em 0.5) (em -0.25) (rgba 0 0 0 0.25)
      ]
    ]
    rows
  ]


firstName : String -> String
firstName fullName =
  fullName
  |> String.words
  |> List.head
  |> Maybe.withDefault ""


implementationDiagramView : WordCounts -> Int -> Float -> Float -> Bool -> Html msg
implementationDiagramView counts step fromLeftEm scale scaleChanged =
  let
    diagramWidthEm : Float
    diagramWidthEm = leftEmAfter senderCountsByWordBasePos

    visibleWidthEm : Float
    visibleWidthEm = diagramWidthEm / scale

    visibleHeightEm : Float
    visibleHeightEm = 56 / scale

    chatMessageHeightEm : Float
    chatMessageHeightEm = 5.5

    extractedWordHeightEm : Float
    extractedWordHeightEm = 3.85

    truncatedTextStyle : Style
    truncatedTextStyle =
      Css.batch
      [ overflow hidden, maxWidth zero -- Not really sure why this works
      , whiteSpace noWrap, textOverflow ellipsis
      ]
  in
  div -- diagram frame
  [ css
    [ position relative
    , height (vw 32)
    , overflow hidden
    ]
  ]
  [ div -- diagram view box
    [ css
      [ position relative
      , height (em visibleHeightEm)
      , fontSize (em (scale * 38.75 / diagramWidthEm))
      , overflow hidden
      , transition
        [ Css.Transitions.fontSize3 transitionDurationMs 0 easeInOut
        , Css.Transitions.opacity3 transitionDurationMs 0 easeInOut
        , Css.Transitions.top3 transitionDurationMs 0 easeInOut
        ]
      ]
    ]
    [ div
      [ css
        [ position absolute
        , right (em (visibleWidthEm + fromLeftEm + 0.25))
        , transition
          ( if scaleChanged then []
            else [ Css.Transitions.right3 transitionDurationMs 0 easeInOut ]
          )
        ]
      ]
      [ div [] -- stream lines and operations
        [ streamLineView (horizontalPosition chatMessagesPos step) visibleHeightEm
        , operationView
          (horizontalPosition mapNormalizeTextPos step) scaleChanged
          [ "map(", "\xA0 normalizeText", ")" ]
        , streamLineView (horizontalPosition normalizedTextPos step) visibleHeightEm
        , operationView
          (horizontalPosition flatMapConcatSplitIntoWordsPos step) scaleChanged
          [ "flatMapConcat(", "\xA0 splitIntoWords", ")" ]
        , streamLineView (horizontalPosition rawWordsPos step) visibleHeightEm
        , operationView
          (horizontalPosition filterIsValidWordPos step) scaleChanged
          [ "filter(", "\xA0 isValidWord", ")" ]
        , streamLineView (horizontalPosition validatedWordsPos step) visibleHeightEm
        , operationView
          (horizontalPosition runningFoldUpdateWordsForSenderPos step) scaleChanged
          [ "scan(", "\xA0\xA0Map(),", ")(", "\xA0 updateWordsForSender", ")" ]
        , streamLineView (horizontalPosition wordsBySendersPos step) visibleHeightEm
        , operationView
          (horizontalPosition mapCountSendersForWordPos step) scaleChanged
          [ "map(", "\xA0 countSendersForWords", ")" ]
        , streamLineView (horizontalPosition senderCountsByWordPos step) visibleHeightEm
        ]
      , div [] -- chat messages
        ( let
            (chatMessageDivs, lastDivTopEm, divCount) =
              counts.history |> List.foldr
              ( \event (accumDivs, topEm, eventIdx) ->
                if eventIdx > 3 && topEm > visibleHeightEm + 10 then
                  ( ( div [ css [ display none ] ] [] ) :: accumDivs
                  , topEm
                  , eventIdx + 1
                  )
                else
                  let
                    extractedWordsHeightEm : Float
                    extractedWordsHeightEm =
                      toFloat (List.length event.words) * extractedWordHeightEm
  
                    bigSmallOffsetEm : Float
                    bigSmallOffsetEm = 0.875
  
                    chatMessageTopEm : Float
                    chatMessageTopEm =
                      if step < 2 then 0
                      else max 0 (extractedWordsHeightEm - chatMessageHeightEm + bigSmallOffsetEm)
  
                    chatMessageOpacityNum : Float
                    chatMessageOpacityNum = (max 0 ((16 - topEm) * 0.05)) + 0.2
  
                    elementColor : Color
                    elementColor =
                      String.uncons event.chatMessage.sender
                      |> Maybe.map ( \(c, _) -> rem (Char.toCode c + 1) 3 )
                      |> Maybe.withDefault -1
                      |> partitionColor
                  in
                  ( ( div -- per chat message
                      [ css
                        [ position absolute, top (em topEm), paddingTop (em 0.3)
                        , transition
                          ( if scaleChanged then []
                            else
                              [ Css.Transitions.opacity3 transitionDurationMs 0 easeInOut
                              , Css.Transitions.top3 transitionDurationMs 0 easeInOut
                              ]
                          )
                        ]
                      ]
                      [ div
                        [ css
                          [ position absolute, top (em chatMessageTopEm)
                          , transition
                            ( if scaleChanged then []
                              else [ Css.Transitions.top3 transitionDurationMs 0 easeInOut ]
                            )
                          ]
                        ]
                        [ streamElementView -- per chat message - chat message
                          ( horizontalPosition chatMessagesPos step )
                          elementColor chatMessageOpacityNum scaleChanged
                          [ tr []
                            [ th [ css [ width (em 5.4), textAlign right, verticalAlign top ] ] [ text "sender:" ]
                            , td [] [ text (firstName event.chatMessage.sender) ]
                            ]
                          , tr []
                            [ th [ css [ textAlign right, verticalAlign top ] ] [ text "recipient:" ]
                            , td [] [ text event.chatMessage.recipient ]
                            ]
                          , tr []
                            [ th [ css [ textAlign right, verticalAlign top ] ] [ text "text:" ]
                            , td [ css [ truncatedTextStyle ] ] [ text event.chatMessage.text ]
                            ]
                          ]
                        , div [ css [ position absolute, top (em bigSmallOffsetEm) ] ]
                          [ streamElementView -- per chat message - sender and normalized text
                            ( horizontalPosition normalizedTextPos step )
                            elementColor chatMessageOpacityNum scaleChanged
                            [ tr []
                              [ th [ css [ width (em 4.5), textAlign right, verticalAlign top ] ] [ text "sender:" ]
                              , td [] [ text (firstName event.chatMessage.sender) ]
                              ]
                            , tr []
                              [ th [ css [ textAlign right, verticalAlign top ] ] [ text "text:" ]
                              , td [ css [ truncatedTextStyle ] ] [ text event.normalizedText ]
                              ]
                            ]
                          ]
                        ]
                      , div -- per chat message - extracted words
                        [ css
                          [ position absolute
                          , left (em rawWordsPos.base.leftEm)
                          , transition
                            ( if scaleChanged then []
                              else [ Css.Transitions.left3 transitionDurationMs 0 easeInOut ]
                            )
                          ]
                        ]
                        ( event.words |> List.indexedMap
                          ( \wordIdx extractedWord ->
                            let
                              wordTopOffsetEm : Float
                              wordTopOffsetEm =
                                if List.length event.words > 1 then 0 else bigSmallOffsetEm
  
                              wordOpacityNum : Float
                              wordOpacityNum =
                                chatMessageOpacityNum * ((max 0 (5 - toFloat wordIdx)) / 10 + 0.5)
  
                              shiftPos : HorizontalPosition -> HorizontalPosition
                              shiftPos pos =
                                { pos | leftEm = pos.leftEm - rawWordsBasePos.leftEm }
  
                              wordRows : List (Html msg)
                              wordRows =
                                [ tr []
                                  [ th [ css [ width (em 4.5), textAlign right, verticalAlign top ] ] [ text "sender:" ]
                                  , td [] [ text (firstName event.chatMessage.sender) ]
                                  ]
                                , tr []
                                  [ th [ css [ textAlign right, verticalAlign top ] ] [ text "word:" ]
                                  , td [ css [ truncatedTextStyle ] ] [ text extractedWord.word ]
                                  ]
                                ]
                            in
                            div -- per extracted word
                            [ css [ position absolute, top (em (toFloat wordIdx * 3.75)) ] ]
                            [ div [ css [ position absolute, top (em wordTopOffsetEm) ] ]
                              [ streamElementView -- per extracted word - raw word
                                ( shiftPos ( horizontalPosition rawWordsPos step ) )
                                elementColor wordOpacityNum scaleChanged wordRows
                              ]
                            , div []
                              ( if not extractedWord.isValid then []
                                else
                                  [ div [ css [ position absolute, top (em wordTopOffsetEm) ] ]
                                    [ streamElementView -- per extracted word - valid word
                                      ( shiftPos ( horizontalPosition validatedWordsPos step ) )
                                      elementColor wordOpacityNum scaleChanged wordRows
                                    ]
                                  , streamElementView -- aggregates - words by sender
                                    ( shiftPos ( horizontalPosition wordsBySendersPos step ) )
                                    elementColor wordOpacityNum scaleChanged
                                    ( ( tr []
                                        [ th [ css [ width (em 7) ] ] [ text "sender" ]
                                        , th [] [ text "words" ]
                                        ]
                                      )
                                    ::( List.reverse
                                        ( Tuple.first
                                          ( counts.history |> List.foldr
                                            ( \{ chatMessage } (wordsBySenderTrs, senders) ->
                                              let
                                                sender : String
                                                sender = chatMessage.sender
                                              in
                                              if Set.member sender senders then (wordsBySenderTrs, senders)
                                              else
                                                ( ( tr []
                                                    [ td [ css [ textAlign center, verticalAlign top ] ] [ text (firstName sender) ]
                                                    , td [ css [ textAlign center, verticalAlign top ] ]
                                                      [ text
                                                        ( String.join ", "
                                                          ( Maybe.withDefault []
                                                            ( Dict.get sender extractedWord.wordsBySender )
                                                          )
                                                        )
                                                      ]
                                                    ]
                                                  ) :: wordsBySenderTrs
                                                , Set.insert sender senders
                                                )
                                            )
                                            ( [], Set.empty )
                                          )
                                        )
                                      )
                                    )
                                  , streamElementView -- aggregates - sender counts by word
                                    ( shiftPos ( horizontalPosition senderCountsByWordPos step ) )
                                    elementColor wordOpacityNum scaleChanged
                                    ( ( tr []
                                        [ th [] [ text "word" ]
                                        , th [ css [ width (em 6) ] ] [ text "senders" ]
                                        ]
                                      )
                                    ::( let
                                          words : List String
                                          words =
                                            counts.history
                                            |> List.concatMap ( \histElem -> histElem.words |> List.reverse )
                                            |> List.map .word
                                        in
                                        List.reverse
                                        ( Tuple.first
                                          ( List.foldr
                                            ( \word (nodes, displayedWords) ->
                                              let
                                                count : Int
                                                count = Maybe.withDefault 0 (Dict.get word extractedWord.countsByWord)
                                              in
                                              if count == 0 || Set.member word displayedWords then (nodes, displayedWords)
                                              else
                                                ( ( tr []
                                                    [ td [ css [ textAlign center, verticalAlign top ] ] [ text word ]
                                                    , td [ css [ textAlign center, verticalAlign top ] ] [ text (toString count) ]
                                                    ]
                                                  ) :: nodes
                                                , Set.insert word displayedWords
                                                )
                                            )
                                            ( [], Set.empty )
                                            words
                                          )
                                        )
                                      )
                                    )
                                  ]
                              )
                            ]
                          )
                          |> List.reverse
                        )
                      ]
                    ) :: accumDivs
                  , topEm + chatMessageTopEm + chatMessageHeightEm
                  , eventIdx + 1
                  )
              )
              -- Initial value
              ( [ div
                  [ css
                    [ position absolute, top (em -chatMessageHeightEm)
                    , transition
                      [ Css.Transitions.opacity3 transitionDurationMs 0 easeInOut
                      , Css.Transitions.top3 transitionDurationMs 0 easeInOut
                      ]
                    ]
                  ] []
                ]
              , 0.0
              , 0
              )

            bottomOpacityNum : Float
            bottomOpacityNum = (max 0 ((2 - divCount) * 0.4)) + 0.2
          in
          ( div
            [ css
              [ position absolute, top (em lastDivTopEm), backgroundColor darkGray
              , transition [ Css.Transitions.top3 transitionDurationMs 0 easeInOut ]
              ]
            ]
            [ streamElementView -- aggregates - words by sender
              ( horizontalPosition wordsBySendersPos step ) darkGray bottomOpacityNum scaleChanged
              [ tr []
                [ th [ css [ width (em 7) ] ] [ text "sender" ]
                , th [] [ text "words" ]
                ]
              ]
            , streamElementView -- aggregates - sender counts by word
              ( horizontalPosition senderCountsByWordPos step ) darkGray bottomOpacityNum scaleChanged
              [ tr []
                [ th [] [ text "word" ]
                , th [ css [ width (em 6) ] ] [ text "senders" ]
                ]
              ]
            ]
          ) :: chatMessageDivs
        )
      ]
    ]
  , div -- fade out
    [ css
      [ position absolute, bottom zero, height (vw 10), width (pct 100)
      , backgroundImage (linearGradient (stop (rgba 255 255 255 0)) (stop white) [])
      ]
    ]
    []
  ]


implementationDiagramSlide : Int -> String -> String -> String -> String -> Bool -> Float -> Float -> Bool -> UnindexedSlideModel
implementationDiagramSlide step diagramHeading subheading introText code showCode fromLeft scale scaleChanged =
  { baseSlideModel
  | animationFrames = if scaleChanged then always 30 else always 0
  , view =
    ( \page model ->
      standardSlideView page diagramHeading subheading
      ( div []
        [ p [ css [ margin2 (em 0.5) zero ] ] [ text introText ]
        , implementationDiagramView
          model.wordCloud step fromLeft scale
          (scaleChanged && model.animationFramesRemaining > 0)
        , slideOutCodeBlock code showCode
        ]
      )
    )
  , eventsWsPath = Just "word-cloud"
  }


leftEmCentering : HorizontalPosition -> HorizontalPosition -> Float
leftEmCentering left right =
  (left.leftEm - (magnifiedWidthEm - leftEmAfter right + left.leftEm) / 2)


detailedMagnification : Float
detailedMagnification = leftEmAfter senderCountsByWordBasePos / magnifiedWidthEm


implementation1ChatMessages : Bool -> UnindexedSlideModel
implementation1ChatMessages showCode =
  implementationDiagramSlide 0 heading
  "Source Events"
  "We start with the source event messages - actual Zoom chat messages:"
  """
val chatMessages: Source[ChatMessage, _] = Consumer
  .plainSource(
    ConsumerSettings(
      system, new StringDeserializer, new StringDeserializer
    ) .withBootstrapServers("localhost:9092")
      .withGroupId("word-cloud-app")
      .withProperty("auto.offset.reset", "earliest"),
    Subscriptions.topics("word-cloud.chat-message")
  )
  .map(_.value.parseJson.convertTo[ChatMessage])
""" showCode
  implementation1Layout.leftEm detailedMagnification False


implementation2MapNormalizeWords : Bool -> UnindexedSlideModel
implementation2MapNormalizeWords showCode =
  implementationDiagramSlide 1 heading
  "Normalizing Message Text"
  "The message text is normalized, retaining the sender:"
  """
val NonLetterPattern: Regex = ""\"[^\\p{L}]+""\".r
def normalizeText(msg: ChatMessage): SenderAndText =
  SenderAndText(
    msg.sender,
    NonLetterPattern.replaceAllIn(msg.text, " ")
      .trim
      .toLowerCase
  )
""" showCode
  implementation2Layout.leftEm detailedMagnification False


implementation3FlatMapConcatSplitIntoWords : Bool -> UnindexedSlideModel
implementation3FlatMapConcatSplitIntoWords showCode =
  implementationDiagramSlide 2 heading
  "Splitting Message Text Into Words"
  "The normalized text is split into words:"
  """
import org.apache.pekko.NotUsed
import org.apache.pekko.stream.scaladsl.Source

def splitIntoWords(
  senderAndText: SenderAndText
): Source[SenderAndWord, NotUsed] = Source(
  senderAndText.text
    .split(" ")
    .map(SenderAndWord(senderAndText.sender, _))
    .reverse
)
""" showCode
  implementation3Layout.leftEm
  detailedMagnification False


implementation4FilterIsValidWord : Bool -> UnindexedSlideModel
implementation4FilterIsValidWord showCode =
  implementationDiagramSlide 3 heading
  "Removing Invalid Words"
  "Invalid words are filtered out:"
  """
val MinWordLen: Int = 3
val MaxWordLen: Int = 15
val StopWords: Set[String] = Set(
  "about", "above", "after", "again", "against", "all", "and", //...
)
def isValidWord(senderAndWord: SenderAndWord): Boolean =
  val wordLen: Int = senderAndWord.word.length
  MinWordLen <= wordLen && wordLen <= MaxWordLen
    && !StopWords.contains(senderAndWord.word)
""" showCode
  (leftEmCentering rawWordsPos.base validatedWordsPos.base)
  detailedMagnification False


implementation5RunningFoldUpdateWordsForSender : Bool -> UnindexedSlideModel
implementation5RunningFoldUpdateWordsForSender showCode =
  implementationDiagramSlide 4 heading
  "Determine Words for Each Sender"
  "For each sender, retain their most recent three words:"
  """
val MaxWordsPerSender: Int = 3
def updateWordsForSender(
  wordsBySender: Map[String, Seq[String]],
  senderAndWord: SenderAndWord,
): Map[String, Seq[String]] =
  val oldWords: Seq[String] =
    wordsBySender.getOrElse(senderAndWord.sender, Seq())
  val newWords: Seq[String] =
    (senderAndWord.word +: oldWords).distinct
      .take(MaxWordsPerSender)
  wordsBySender + (senderAndWord.sender -> newWords)
""" showCode
  (leftEmCentering validatedWordsPos.base wordsBySendersPos.base)
  detailedMagnification False


implementation6MapCountSendersForWord : Bool -> UnindexedSlideModel
implementation6MapCountSendersForWord showCode =
  implementationDiagramSlide 5 heading
  "Count Senders for Each Word"
  "For each word, count the number of senders:"
  """
def countSendersForWords(
  wordsBySender: Map[String, Seq[String]]
): Map[String, Int] = wordsBySender.toSeq
  .flatMap {
    case (sender: String, words: Seq[String]) =>
      words.map(_ -> sender)
  }
  .groupMap(_._1)(_._2)
  .view.mapValues(_.size).toMap()
""" showCode
  (leftEmCentering wordsBySendersPos.base senderCountsByWordPos.base)
  detailedMagnification False


implementation7Complete : Bool -> UnindexedSlideModel
implementation7Complete showCode =
  implementationDiagramSlide 6 heading
  "Tying It All Together"
  "Composing all the operations into a single flow:"
  """
val wordCounts = chatMessages
  .map(normalizeText)
  .flatMapConcat(splitIntoWords)
  .filter(isValidWord)
  .scan(Map())(updateWordsForSender)
  .map(countSendersForWords)
""" showCode
  0.0 1.0 True


implementationCompleteDistribution : Bool -> UnindexedSlideModel
implementationCompleteDistribution showCode =
  implementationDiagramSlide 6
  "Additional Considerations"
  "Considerations for Distributed Deployment"
  "Observe that some events can be re-ordered without changing the final outcome:"
  "" showCode
  0.0 1.0 True


implementationCompleteEventSourcing : Bool -> UnindexedSlideModel
implementationCompleteEventSourcing showCode =
  implementationDiagramSlide 6
  "Additional Considerations"
  "Application Source of Truth Considerations"
  "Observe that information is lost as it flows through the system:"
  "" showCode
  0.0 1.0 True


slides : List UnindexedSlideModel
slides =
  ( introduction
  ::( [ implementation1ChatMessages
      , implementation2MapNormalizeWords
      , implementation3FlatMapConcatSplitIntoWords
      , implementation4FilterIsValidWord
      , implementation5RunningFoldUpdateWordsForSender
      , implementation6MapCountSendersForWord
      , implementation7Complete
      ]
      |> List.concatMap ( \slide -> [ slide False, slide True, slide False ] )
    )
  ++[ collecting ]
  )
