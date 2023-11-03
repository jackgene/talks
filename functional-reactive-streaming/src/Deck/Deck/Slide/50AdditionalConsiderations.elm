module Deck.Slide.AdditionalConsiderations exposing
  ( distributedDeployment, eventSourcing )

import Deck.Slide.Common exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Html.Styled exposing (Html, div, p, text, ul)


heading : String
heading = "Additional Considerations"


distributedDeployment : UnindexedSlideModel
distributedDeployment =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Considerations for Distributed Deployment"
      ( div []
        [ p []
          [ text "It is common to scale an application by running it on multiple machines, allowing us to speed it up through parallelism. "
          , text "With streaming applications, the problem is that message ordering cannot be guaranteed across machines."
          ]
        , p []
          [ text "This means that when message ordering does not matter, the application is to easy to distribute. "
          , text "When ordering matters for the entire stream, is it impossible to. "
          , text "Most applications are somewhere in between: Order matters, but within sub-groups."
          ]
        ]
      )
    )
  }


eventSourcing : UnindexedSlideModel
eventSourcing =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Application Source of Truth Considerations"
      ( div []
        [ p []
          [ text "What should we use as the source of truth of the word cloud application?" ]
        , p []
          [ text "Our initial inclination may be to use the sender-words pairs. "
          , text "But consider if we want to make the following word cloud changes:"
          , ul []
            [ li [] [ text "Accept each sender’s last 7 words" ]
            , li [] [ text "Add or remove stop words" ]
            ]
          ]
        , p []
          [ text "We would not have the information to update the application state, without requiring users to resend their words. "
          , text "If instead, we use the chat messages as the source of truth, "
          , text "we could then rebuild the application state by replaying the events with the new set of rules. "
          , text "This is “Event Sourcing.”"
          ]
        ]
      )
    )
  }
