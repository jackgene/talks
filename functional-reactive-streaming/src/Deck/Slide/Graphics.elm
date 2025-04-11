module Deck.Slide.Graphics exposing
  ( coverBackgroundGraphic, numberedDisc, languageScalaLogoBig
  , languageGoLogo, languageKotlinLogo, languagePythonLogo
  , languageScalaLogo, languageSwiftLogo, languageTypeScriptLogo
  )

import Css exposing (fontSize, px)
import Deck.Slide.Common exposing
  ( numberFontFamily, themeBackgroundColor, themeForegroundColor
  , textWithShadow
  )
import Svg.Styled exposing (..)
import Svg.Styled.Attributes as Attributes exposing
  ( class, css, d, id, transform
  -- Units
  , gradientUnits
  -- Container
  , height, viewBox, width
  -- Dimensions & Positions
  , offset, points, r, rx, x1, x2, y, y1, y2
  -- Lines
  -- Fills
  , clipRule, fill, fillRule, gradientTransform
  -- Color
  , stopColor
  -- Alignment
  , alignmentBaseline, textAnchor
  )


coverBackgroundGraphic : Svg msg
coverBackgroundGraphic = languageScalaLogoBig


numberedDisc : String -> Float -> List (Attribute msg) -> Svg msg
numberedDisc num fontSizePct attributes =
  svg
  ( viewBox "-50 -50 100 100" :: attributes )
  [ circle [ r "50", css [ Css.fill themeBackgroundColor ] ] []
  , text_
    [ alignmentBaseline "middle", textAnchor "middle", y "5"
    , css [ numberFontFamily, textWithShadow, Css.fill themeForegroundColor, fontSize (px fontSizePct) ]
    ]
    [ text num ]
  ]


languageGoLogo : Svg msg
languageGoLogo =
  svg [ height "1.5vw", viewBox "0 -15 205.4 92", Attributes.style "enable-background:new 0 0 205.4 76.7;" ]
  [ style [] [ text " .st0{fill:#00ACD7;} " ]
  , g []
    [ g []
      [ g []
        [ g []
          [ path
            [ class "st0"
            , d "M15.5,23.2c-0.4,0-0.5-0.2-0.3-0.5l2.1-2.7c0.2-0.3,0.7-0.5,1.1-0.5h35.7c0.4,0,0.5,0.3,0.3,0.6l-1.7,2.6 c-0.2,0.3-0.7,0.6-1,0.6L15.5,23.2z"
            ]
            []
          ]
        ]
      ]
    , g []
      [ g []
        [ g []
          [ path
            [ class "st0"
            , d "M0.4,32.4c-0.4,0-0.5-0.2-0.3-0.5l2.1-2.7c0.2-0.3,0.7-0.5,1.1-0.5h45.6c0.4,0,0.6,0.3,0.5,0.6l-0.8,2.4 c-0.1,0.4-0.5,0.6-0.9,0.6L0.4,32.4z"
            ]
            []
          ]
        ]
      ]
    , g []
      [ g []
        [ g []
          [ path
            [ class "st0"
            , d "M24.6,41.6c-0.4,0-0.5-0.3-0.3-0.6l1.4-2.5c0.2-0.3,0.6-0.6,1-0.6h20c0.4,0,0.6,0.3,0.6,0.7L47.1,41 c0,0.4-0.4,0.7-0.7,0.7L24.6,41.6z"
            ]
            []
          ]
        ]
      ]
    , g []
      [ g []
        [ g []
          [ g []
            [ path
              [ class "st0"
              , d "M128.4,21.4c-6.3,1.6-10.6,2.8-16.8,4.4c-1.5,0.4-1.6,0.5-2.9-1c-1.5-1.7-2.6-2.8-4.7-3.8 c-6.3-3.1-12.4-2.2-18.1,1.5c-6.8,4.4-10.3,10.9-10.2,19c0.1,8,5.6,14.6,13.5,15.7c6.8,0.9,12.5-1.5,17-6.6 c0.9-1.1,1.7-2.3,2.7-3.7c-3.6,0-8.1,0-19.3,0c-2.1,0-2.6-1.3-1.9-3c1.3-3.1,3.7-8.3,5.1-10.9c0.3-0.6,1-1.6,2.5-1.6 c5.1,0,23.9,0,36.4,0c-0.2,2.7-0.2,5.4-0.6,8.1c-1.1,7.2-3.8,13.8-8.2,19.6c-7.2,9.5-16.6,15.4-28.5,17 c-9.8,1.3-18.9-0.6-26.9-6.6c-7.4-5.6-11.6-13-12.7-22.2c-1.3-10.9,1.9-20.7,8.5-29.3c7.1-9.3,16.5-15.2,28-17.3 c9.4-1.7,18.4-0.6,26.5,4.9c5.3,3.5,9.1,8.3,11.6,14.1C130,20.6,129.6,21.1,128.4,21.4z"
              ]
              []
            ]
          , g []
            [ path
              [ class "st0"
              , d "M161.5,76.7c-9.1-0.2-17.4-2.8-24.4-8.8c-5.9-5.1-9.6-11.6-10.8-19.3c-1.8-11.3,1.3-21.3,8.1-30.2 c7.3-9.6,16.1-14.6,28-16.7c10.2-1.8,19.8-0.8,28.5,5.1c7.9,5.4,12.8,12.7,14.1,22.3c1.7,13.5-2.2,24.5-11.5,33.9 c-6.6,6.7-14.7,10.9-24,12.8C166.8,76.3,164.1,76.4,161.5,76.7z M185.3,36.3c-0.1-1.3-0.1-2.3-0.3-3.3 c-1.8-9.9-10.9-15.5-20.4-13.3c-9.3,2.1-15.3,8-17.5,17.4c-1.8,7.8,2,15.7,9.2,18.9c5.5,2.4,11,2.1,16.3-0.6 C180.5,51.3,184.8,44.9,185.3,36.3z"
              ]
              []
            ]
          ]
        ]
      ]
    ]
  ]


languageKotlinLogo : Svg msg
languageKotlinLogo =
  svg [ height "2.5vw", viewBox "0 -6 64 72", Attributes.style "enable-background:new 0 0 60 60;" ]
  [ g []
    [ linearGradient
      [ id "kotlinLinearGradient-1"
      , gradientUnits "userSpaceOnUse"
      , x1 "15.9594", y1 "-13.0143", x2 "44.3068", y2 "15.3332"
      , gradientTransform "matrix(1 0 0 -1 0 61)"
      ]
      [ stop [ offset "9.677000e-02", Attributes.style "stop-color:#0095D5" ] []
      , stop [ offset "0.3007", Attributes.style "stop-color:#238AD9" ] []
      , stop [ offset "0.6211", Attributes.style "stop-color:#557BDE" ] []
      , stop [ offset "0.8643", Attributes.style "stop-color:#7472E2" ] []
      , stop [ offset "1", Attributes.style "stop-color:#806EE3" ] []
      ]
    , polygon
      [ Attributes.style "fill:url(#kotlinLinearGradient-1);", points "0,60 30.1,29.9 60,60 " ]
      []
    , linearGradient
      [ id "kotlinLinearGradient-2"
      , gradientUnits "userSpaceOnUse"
      , x1 "4.2092", y1 "48.9409", x2 "20.6734", y2 "65.405"
      , gradientTransform "matrix(1 0 0 -1 0 61)"
      ]
      [ stop [ offset "0.1183", Attributes.style "stop-color:#0095D5" ] []
      , stop [ offset "0.4178", Attributes.style "stop-color:#3C83DC" ] []
      , stop [ offset "0.6962", Attributes.style "stop-color:#6D74E1" ] []
      , stop [ offset "0.8333", Attributes.style "stop-color:#806EE3" ] []
      ]
    , polygon [ Attributes.style "fill:url(#kotlinLinearGradient-2);", points "0,0 30.1,0 0,32.5 " ] []
    , linearGradient
      [ id "kotlinLinearGradient-3"
      , gradientUnits "userSpaceOnUse"
      , x1 "-10.1017", y1 "5.8362", x2 "45.7315", y2 "61.6694"
      , gradientTransform "matrix(1 0 0 -1 0 61)"
      ]
      [ stop [ offset "0.1075", Attributes.style "stop-color:#C757BC" ] []
      , stop [ offset "0.2138", Attributes.style "stop-color:#D0609A" ] []
      , stop [ offset "0.4254", Attributes.style "stop-color:#E1725C" ] []
      , stop [ offset "0.6048", Attributes.style "stop-color:#EE7E2F" ] []
      , stop [ offset "0.743", Attributes.style "stop-color:#F58613" ] []
      , stop [ offset "0.8232", Attributes.style "stop-color:#F88909" ] []
      ]
    , polygon [ Attributes.style "fill:url(#kotlinLinearGradient-3);", points "30.1,0 0,31.7 0,60 30.1,29.9 60,0 " ] []
    ]
  ]


languagePythonLogo : Svg msg
languagePythonLogo =
  svg [ height "2.5vw", viewBox "0 0 256 255" ]
  [ defs []
    [ linearGradient
      [ x1 "12.9593594%", y1 "12.0393928%", x2 "79.6388325%", y2 "78.2008538%", id "pythonLinearGradient-1" ]
      [ stop [ stopColor "#387EB8", offset "0%" ] [], stop [ stopColor "#366994", offset "100%" ] [] ]
    , linearGradient [ x1 "19.127525%", y1 "20.5791813%", x2 "90.7415328%", y2 "88.4290372%", id "pythonLinearGradient-2" ]
      [ stop [ stopColor "#FFE052", offset "0%" ] [], stop [ stopColor "#FFC331", offset "100%" ] [] ]
    ]
  , g []
    [ path
      [ d "M126.915866,0.0722755491 C62.0835831,0.0722801733 66.1321288,28.1874648 66.1321288,28.1874648 L66.2044043,57.3145115 L128.072276,57.3145115 L128.072276,66.0598532 L41.6307171,66.0598532 C41.6307171,66.0598532 0.144551098,61.3549438 0.144551098,126.771315 C0.144546474,192.187673 36.3546019,189.867871 36.3546019,189.867871 L57.9649915,189.867871 L57.9649915,159.51214 C57.9649915,159.51214 56.8001363,123.302089 93.5968379,123.302089 L154.95878,123.302089 C154.95878,123.302089 189.434218,123.859386 189.434218,89.9830604 L189.434218,33.9695088 C189.434218,33.9695041 194.668541,0.0722755491 126.915866,0.0722755491 L126.915866,0.0722755491 L126.915866,0.0722755491 Z M92.8018069,19.6589497 C98.9572068,19.6589452 103.932242,24.6339846 103.932242,30.7893845 C103.932246,36.9447844 98.9572068,41.9198193 92.8018069,41.9198193 C86.646407,41.9198239 81.6713721,36.9447844 81.6713721,30.7893845 C81.6713674,24.6339846 86.646407,19.6589497 92.8018069,19.6589497 L92.8018069,19.6589497 L92.8018069,19.6589497 Z"
      , fill "url(#pythonLinearGradient-1)"
      ]
      []
    , path
      [ d "M128.757101,254.126271 C193.589403,254.126271 189.540839,226.011081 189.540839,226.011081 L189.468564,196.884035 L127.600692,196.884035 L127.600692,188.138693 L214.042251,188.138693 C214.042251,188.138693 255.528417,192.843589 255.528417,127.427208 C255.52844,62.0108566 219.318366,64.3306589 219.318366,64.3306589 L197.707976,64.3306589 L197.707976,94.6863832 C197.707976,94.6863832 198.87285,130.896434 162.07613,130.896434 L100.714182,130.896434 C100.714182,130.896434 66.238745,130.339138 66.238745,164.215486 L66.238745,220.229038 C66.238745,220.229038 61.0044225,254.126271 128.757101,254.126271 L128.757101,254.126271 L128.757101,254.126271 Z M162.87116,234.539597 C156.715759,234.539597 151.740726,229.564564 151.740726,223.409162 C151.740726,217.253759 156.715759,212.278727 162.87116,212.278727 C169.026563,212.278727 174.001595,217.253759 174.001595,223.409162 C174.001618,229.564564 169.026563,234.539597 162.87116,234.539597 L162.87116,234.539597 L162.87116,234.539597 Z"
      , fill "url(#pythonLinearGradient-2)"
      ]
      []
    ]
  ]


languageScalaLogoWithSize : String -> Svg msg
languageScalaLogoWithSize size =
  svg [ width size, height size, viewBox "0 0 256 416" ]
  [ defs []
    [ linearGradient
      [ x1 "0%", y1 "50%", x2 "100%", y2 "50%", id "scalaLinearGradient-1" ]
      [ stop [ stopColor "#4F4F4F", offset "0%" ] [], stop [ stopColor "#000000", offset "100%" ] [] ]
    , linearGradient
      [ x1 "0%", y1 "50%", x2 "100%", y2 "50%", id "scalaLinearGradient-2" ]
      [ stop [ stopColor "#C40000", offset "0%" ] [], stop [ stopColor "#FF0000", offset "100%" ] [] ]
    ]
  , g []
    [ path
      [ d "M0,288 L0,256 C0,250.606222 116.376889,241.571556 192.199111,224 L192.199111,224 C228.828444,232.490667 256,242.968889 256,256 L256,256 L256,288 C256,301.024 228.828444,311.509333 192.199111,320 L192.199111,320 C116.376889,302.424889 0,293.390222 0,288"
      , fill "url(#scalaLinearGradient-1)"
      , transform "translate(128.000000, 272.000000) scale(1, -1) translate(-128.000000, -272.000000) "
      ]
      []
    , path
      [ d "M0,160 L0,128 C0,122.606222 116.376889,113.571556 192.199111,96 L192.199111,96 C228.828444,104.490667 256,114.968889 256,128 L256,128 L256,160 C256,173.024 228.828444,183.509333 192.199111,192 L192.199111,192 C116.376889,174.424889 0,165.390222 0,160"
      , fill "url(#scalaLinearGradient-1)"
      , transform "translate(128.000000, 144.000000) scale(1, -1) translate(-128.000000, -144.000000) "
      ]
      []
    , path
      [ d "M0,224 L0,128 C0,136 256,152 256,192 L256,192 L256,288 C256,248 0,232 0,224"
      , fill "url(#scalaLinearGradient-2)"
      , transform "translate(128.000000, 208.000000) scale(1, -1) translate(-128.000000, -208.000000) "
      ]
      []
    , path
      [ d "M0,96 L0,0 C0,8 256,24 256,64 L256,64 L256,160 C256,120 0,104 0,96"
      , fill "url(#scalaLinearGradient-2)"
      , transform "translate(128.000000, 80.000000) scale(1, -1) translate(-128.000000, -80.000000) "
      ]
      []
    , path
      [ d "M0,352 L0,256 C0,264 256,280 256,320 L256,320 L256,416 C256,376 0,360 0,352"
      , fill "url(#scalaLinearGradient-2)"
      , transform "translate(128.000000, 336.000000) scale(1, -1) translate(-128.000000, -336.000000) "
      ]
      []
    ]
  ]


languageScalaLogo : Svg msg
languageScalaLogo = languageScalaLogoWithSize "2.5vw"


languageScalaLogoBig : Svg msg
languageScalaLogoBig = languageScalaLogoWithSize "121vw"


languageSwiftLogo : Svg msg
languageSwiftLogo =
  svg [ height "2.5vw", viewBox "0 0 256 256" ]
  [ linearGradient
    [ id "a"
    , gradientUnits "userSpaceOnUse"
    , x1 "-1845.501", y1 "1255.639", x2 "-1797.134", y2 "981.338"
    , gradientTransform "rotate(180 -846.605 623.252)"
    ]
    [ stop [ offset "0", stopColor "#faae42" ] [], stop [ offset "1", stopColor "#ef3e31" ] [] ]
  , path
    [ fill "url(#a)"
    , d "M56.9 0h141.8c6.9 0 13.6 1.1 20.1 3.4 9.4 3.4 17.9 9.4 24.3 17.2 6.5 7.8 10.8 17.4 12.3 27.4.6 3.7.7 7.4.7 11.1V197.4c0 4.4-.2 8.9-1.1 13.2-2 9.9-6.7 19.2-13.5 26.7-6.7 7.5-15.5 13.1-25 16.1-5.8 1.8-11.8 2.6-17.9 2.6-2.7 0-142.1 0-144.2-.1-10.2-.5-20.3-3.8-28.8-9.5-8.3-5.6-15.1-13.4-19.5-22.4-3.8-7.7-5.7-16.3-5.7-24.9V56.9C.2 48.4 2 40 5.7 32.4c4.3-9 11-16.9 19.3-22.5C33.5 4.1 43.5.7 53.7.2c1-.2 2.1-.2 3.2-.2z"
    ]
    []
  , linearGradient
    [ id "b"
    , gradientUnits "userSpaceOnUse"
    , x1 "130.612", y1 "4.136", x2 "95.213", y2 "204.893"
    ]
    [ stop [ offset "0", stopColor "#e39f3a" ] [], stop [ offset "1", stopColor "#d33929" ] [] ]
  , path
    [ fill "url(#b)"
    , d "M216 209.4c-.9-1.4-1.9-2.8-3-4.1-2.5-3-5.4-5.6-8.6-7.8-4-2.7-8.7-4.4-13.5-4.6-3.4-.2-6.8.4-10 1.6-3.2 1.1-6.3 2.7-9.3 4.3-3.5 1.8-7 3.6-10.7 5.1-4.4 1.8-9 3.2-13.7 4.2-5.9 1.1-11.9 1.5-17.8 1.4-10.7-.2-21.4-1.8-31.6-4.8-9-2.7-17.6-6.4-25.7-11.1-7.1-4.1-13.7-8.8-19.9-14.1-5.1-4.4-9.8-9.1-14.2-14.1-3-3.5-5.9-7.2-8.6-11-1.1-1.5-2.1-3.1-3-4.7L0 121.2V56.7C0 25.4 25.3 0 56.6 0h50.5l37.4 38c84.4 57.4 57.1 120.7 57.1 120.7s24 27 14.4 50.7z"
    ]
    []
  , path
    [ fill "#FFF"
    , d "M144.7 38c84.4 57.4 57.1 120.7 57.1 120.7s24 27.1 14.3 50.8c0 0-9.9-16.6-26.5-16.6-16 0-25.4 16.6-57.6 16.6-71.7 0-105.6-59.9-105.6-59.9C91 192.1 135.1 162 135.1 162c-29.1-16.9-91-97.7-91-97.7 53.9 45.9 77.2 58 77.2 58-13.9-11.5-52.9-67.7-52.9-67.7 31.2 31.6 93.2 75.7 93.2 75.7C179.2 81.5 144.7 38 144.7 38z"
    ]
    []
  ]


languageTypeScriptLogo : Svg msg
languageTypeScriptLogo =
  svg [ height "2.5vw", viewBox "0 0 512 512" ]
  [ rect [ width "512", height "512", rx "50", fill "#3178c6" ] []
  , path
    [ d "m317 407v50c8.1 4.2 18 7.3 29 9.4s23 3.1 35 3.1c12 0 23-1.1 34-3.4 11-2.3 20-6.1 28-11 8.1-5.3 15-12 19-21s7.1-19 7.1-32c0-9.1-1.4-17-4.1-24s-6.6-13-12-18c-5.1-5.3-11-10-18-14s-15-8.2-24-12c-6.6-2.7-12-5.3-18-7.9-5.2-2.6-9.7-5.2-13-7.8-3.7-2.7-6.5-5.5-8.5-8.4-2-3-3-6.3-3-10 0-3.4 0.89-6.5 2.7-9.3s4.3-5.1 7.5-7.1c3.2-2 7.2-3.5 12-4.6 4.7-1.1 9.9-1.6 16-1.6 4.2 0 8.6 0.31 13 0.94 4.6 0.63 9.3 1.6 14 2.9 4.7 1.3 9.3 2.9 14 4.9 4.4 2 8.5 4.3 12 6.9v-47c-7.6-2.9-16-5.1-25-6.5s-19-2.1-31-2.1c-12 0-23 1.3-34 3.8s-20 6.5-28 12c-8.1 5.4-14 12-19 21-4.7 8.4-7 18-7 30 0 15 4.3 28 13 38 8.6 11 22 19 39 27 6.9 2.8 13 5.6 19 8.3s11 5.5 15 8.4c4.3 2.9 7.7 6.1 10 9.5 2.5 3.4 3.8 7.4 3.8 12 0 3.2-0.78 6.2-2.3 9s-3.9 5.2-7.1 7.2-7.1 3.6-12 4.8c-4.7 1.1-10 1.7-17 1.7-11 0-22-1.9-32-5.7-11-3.8-21-9.5-30-17zm-84-123h64v-41h-179v41h64v183h51z"
    , clipRule "evenodd"
    , fill "#fff"
    , fillRule "evenodd"
    , Attributes.style "fill:#fff"
    ]
    []
  ]
