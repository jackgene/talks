module Deck.Common exposing (..)

import Array exposing (Array)
import Html.Styled exposing (Html)
import Navigation exposing (Location)
import Time exposing (Time)
import WordCloud


-- Constants
typingSpeedMultiplier : Int
typingSpeedMultiplier = 3


-- Messages
type Msg
  = Next
  | Last
  | NewLocation Location
  | Event String
  | NewWordCounts WordCloud.WordCounts
  | TranscriptionText String
  | TranscriptionUpdated Time
  | TranscriptionClearingTick Time
  | AnimationTick
  | NoOp


-- Model
type alias SlideModel =
  { active : Model -> Bool
  , update : Msg -> Model -> (Model, Cmd Msg)
  , view : Model -> Html Msg
  , index : Int
  , eventsWsPath : Maybe String
  , animationFrames : Model -> Int
  }


type Slide = Slide SlideModel


type alias Navigation =
  { nextSlideIndex : Int
  , lastSlideIndex : Int
  }


type alias Model =
  { eventsWsUrl : Maybe String
  , activeNavigation : Array Navigation
  , currentSlide : Slide
  , animationFramesRemaining : Int
  , wordCloud : WordCloud.WordCounts
  , questions : Array String
  , transcription : { text : String, updated : Time }
  }
