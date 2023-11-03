module Deck.Slide.SectionCover exposing (..)

import Deck.Slide.Common exposing (UnindexedSlideModel, baseSlideModel)
import Deck.Slide.Template exposing (sectionCoverSlideView)


introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 1 "Introduction" )
  }


operators : UnindexedSlideModel
operators =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 2 "Operators" )
  }


application : UnindexedSlideModel
application =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 3 "Example Application" )
  }


additionalConsiderations : UnindexedSlideModel
additionalConsiderations =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 4 "Additional Considerations" )
  }


questions : UnindexedSlideModel
questions =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 5 "Audience Questions" )
  , eventsWsPath = Just "question"
  }


thankYou : UnindexedSlideModel
thankYou =
  { baseSlideModel
  | view = ( \_ _ -> sectionCoverSlideView 6 "Thank You" )
  }
