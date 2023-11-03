module WordCloud exposing (WordCounts, empty, wordCounts, topWords)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import WebSocket


webSocketUrl : String
webSocketUrl = "ws://localhost:9673?debug=true"


type alias ChatMessage =
  { sender : String
  , recipient : String
  , text : String
  }


type alias ExtractedWord =
  { word : String
  , isValid : Bool
  , wordsBySender : Dict String (List String)
  , countsByWord : Dict String Int
  }


type alias Event =
  { chatMessage : ChatMessage
  , normalizedText : String
  , words : List ExtractedWord
  }


type alias WordCounts =
  { history : List Event
  , countsByWord : Dict String Int
  }


chatMessageDecoder : Decoder ChatMessage
chatMessageDecoder =
  Decode.map3 ChatMessage
  ( Decode.field "s" Decode.string )
  ( Decode.field "r" Decode.string )
  ( Decode.field "t" Decode.string )


extractedWordDecoder : Decoder ExtractedWord
extractedWordDecoder =
  Decode.map4 ExtractedWord
  ( Decode.field "word" Decode.string )
  ( Decode.field "isValid" Decode.bool )
  ( Decode.field "wordsBySender" ( Decode.dict ( Decode.list Decode.string ) ) )
  ( Decode.field "countsByWord" ( Decode.dict Decode.int ) )


chatMessageAndTokensDecoder : Decoder Event
chatMessageAndTokensDecoder =
  Decode.map3 Event
  ( Decode.field "chatMessage" chatMessageDecoder )
  ( Decode.field "normalizedText" Decode.string )
  ( Decode.field "words" ( Decode.list extractedWordDecoder ) )


wordCountsDecoder : Decoder WordCounts
wordCountsDecoder =
  Decode.map2 WordCounts
  ( Decode.field "history" ( Decode.list chatMessageAndTokensDecoder ) )
  ( Decode.field "countsByWord" ( Decode.dict Decode.int ) )


empty : WordCounts
empty =
  { history = []
  , countsByWord = Dict.empty
  }


wordCounts : (Maybe WordCounts -> msg) -> Sub msg
wordCounts tagger =
  Sub.map
  ( tagger << Result.toMaybe )
  ( WebSocket.listen webSocketUrl ( Decode.decodeString wordCountsDecoder ) )


topWords : Int -> WordCounts -> List (String, Int)
topWords n wordCounts =
  Dict.toList wordCounts.countsByWord
  |> List.sortBy ( \(_, count) -> -count )
  |> List.take n
