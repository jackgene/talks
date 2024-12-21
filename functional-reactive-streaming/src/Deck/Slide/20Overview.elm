module Deck.Slide.Overview exposing ( slides )

import Deck.Slide.Common exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Html.Styled exposing (Html, b, div, p, text, ul)


heading : String
heading = "What is Functional Reactive Streaming?"


introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "It Is Functional, It Is Reactive, It Is Streaming"
      ( div []
        [ p []
          [ b [] [ text "Functional" ]
          , text ": Based on functional programming principles, allowing you to leverage its associated benefits"
          ]
        , p []
          [ b [] [ text "Reactive" ]
          , text ": Built on an asynchronous architecture, and is efficient with execution resources, and in turn memory resources"
          ]
        , p []
          [ b [] [ text "Streaming" ]
          , text ": Models application input/output events as streams of messages"
          ]
        ]
      )
    )
  }


functional : UnindexedSlideModel
functional =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Functional: Based on Functional Programming Principles"
      ( div []
        [ ul []
          [ li []
            [ text "Application is implemented by applying operations on immutable messages, making it easy to reason about" ]
          , li []
            [ text "The operators are based on functional collection processing primitives, such as "
            , syntaxHighlightedCodeSnippet Scala "map[B](A => B)"
            , text ", and "
            , syntaxHighlightedCodeSnippet Scala "filter(A => Boolean)"
            , text ", and are functionally pure"
            ]
          , li []
            [ text "As long as only pure functions are applied to these operators, the application too will be functionally pure" ]
          , li []
            [ text "Error handling is done by returning discriminated union types such as "
            , syntaxHighlightedCodeSnippet Scala "_: Try[T]"
            , text " or "
            , syntaxHighlightedCodeSnippet Scala "_: Either[A, B]"
            , text " from the "
            , syntaxHighlightedCodeSnippet Scala "scala.util"
            , text " package"
            ]
          , li []
            [ text "Not a silver bullet: Programmers get the most out of it when they conform to functional programming practices" ]
          ]
        ]
      )
    )
  }


reactive : UnindexedSlideModel
reactive =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Reactive: Built on an Asynchronous Architecture"
      ( div []
        [ ul []
          [ li [] [ text "“Reactive” because it is based on the “Reactor Design Pattern”" ]
          , li [] [ text "Popularized by the unexpected success of server-side JavaScript, making people realize it is possible for a single thread to handle considerable load" ]
          , li [] [ text "Strives to minimize the number of threads to the degree of parallelism needed (typically equal to the number of available CPU cores)" ]
          , li [] [ text "Functions should be non-blocking: That is, they only consume a thread when they need the CPU, yield when CPU is not needed" ]
          , li [] [ text "Again, not a silver bullet: Programmers are required to understand and follow asynchronous programming practices" ]
          ]
        ]
      )
    )
  }


streaming : UnindexedSlideModel
streaming =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Streaming: Models Application Events as Message Streams"
      ( div []
        [ ul []
          [ li [] [ text "Streams (known as Sources in Pekko Streams) behave a lot like iterators, but with one key difference: elements come to be asynchronously - an element can come immediately after the last element, or it can come days later" ]
          , li [] [ text "May have an infinite number of elements, are processed lazily on demand, possibly concurrently" ]
          , li []
            [ text "Processed by applying operations using operators such as "
            , syntaxHighlightedCodeSnippet Scala "map[B](A => B)"
            , text ", and "
            , syntaxHighlightedCodeSnippet Scala "filter(A => Boolean)"
            ]
          , li [] [ text "Operators are the foundation of functional reactive streaming" ]
          ]
        ]
      )
    )
  }


slides : List UnindexedSlideModel
slides =
  [ introduction, functional, reactive, streaming ]