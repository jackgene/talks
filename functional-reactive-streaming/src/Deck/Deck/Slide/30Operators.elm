module Deck.Slide.Operators exposing (slides)

import Css exposing
  ( Color, Style
  -- Container
  , height, left, position, top, width
  -- Content
  -- Units
  , em, vw, zero
  -- Alignment & Positions
  , absolute, relative
  -- Other values
  )
import Deck.Common exposing (Msg)
import Deck.Slide.Common exposing (..)
import Deck.Slide.MarbleDiagram exposing (..)
import Deck.Slide.SyntaxHighlight exposing (..)
import Deck.Slide.Template exposing (standardSlideView)
import Dict
import Html.Styled exposing (Html, div, i, p, text, ul)
import Html.Styled.Attributes exposing (css)


-- Constants
heading : String
heading = "A Detailed Look at the Operators"


-- Slides
introduction : UnindexedSlideModel
introduction =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "An Overview of the Most Common and Useful Operators"
      ( div []
        [ p []
          [ text "There are functional reactive streaming implementations for all major languages, all conforming to \"the functional reactive streaming API\" at a high level." ]
        , p []
          [ text "Each implementation is slightly different however, tailoring to the semantics of each language. " ]
        , p []
          [ text "Let’s have a closer look at seven common and useful operators." ]
        ]
      )
    )
  }


operator : String -> Html Msg -> Operand -> Operation -> Operand -> Bool -> String -> Bool -> UnindexedSlideModel
operator subheading textView input operation output animate code showCode =
  { baseSlideModel
  | view =
    ( \page _ ->
      standardSlideView page heading subheading
      ( div []
        [ div [ css [ position relative, top (em -1), height (vw 32) ] ]
          [ div
            [ css [ position absolute, left zero, width (vw 46) ] ]
            [ textView ]
          , div -- diagram frame
            [ css [ position absolute, top (em 1), left (vw 46), width (vw 40) ] ]
            [ diagramView input operation output animate ]
          ]
        , div [] [] -- prevent animation
        , slideOutCodeBlock code showCode
        ]
      )
    )
  }


operatorMap : Bool -> Bool -> UnindexedSlideModel
operatorMap showCode animate =
  operator "map: Transform Observable Elements"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.map(...)"
      , text " accepts a transformation function, and returns a new Observable of the transformed elements of the original Observable."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "Output and input have the same size" ]
        , li [] [ text "Output type can be anything (determined by transformation function)" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 1.5, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 2003
      , Element 2 Disc 2 4008
      , Element 3 Disc 0 6013
      , Element 4 Disc 1 8026
      , Element 5 Disc 2 10033
      , Element 6 Disc 0 12036
      , Element 7 Disc 1 14037
      , Element 8 Disc 2 16042
      , Element 9 Disc 0 18048
      , Element 10 Disc 1 20052
      , Element 11 Disc 2 22054
      , Element 12 Disc 0 24055
      , Element 13 Disc 1 26056
      , Element 14 Disc 2 28062
      , Element 15 Disc 0 30067
      , Element 16 Disc 1 32073
      , Element 17 Disc 2 34078
      , Element 18 Disc 0 36083
      , Element 19 Disc 1 38085
      , Element 20 Disc 2 40089
      , Element 21 Disc 0 42091
      , Element 22 Disc 1 44095
      , Element 23 Disc 2 46099
      , Element 24 Disc 0 48105
      , Element 25 Disc 1 50110
      , Element 26 Disc 2 52115
      , Element 27 Disc 0 54120
      , Element 28 Disc 1 56124
      , Element 29 Disc 2 58128
      , Element 30 Disc 0 60134
      , Element 31 Disc 1 62137
      , Element 32 Disc 2 64141
      , Element 33 Disc 0 66146
      , Element 34 Disc 1 68149
      , Element 35 Disc 2 70153
      , Element 36 Disc 0 72157
      , Element 37 Disc 1 74163
      , Element 38 Disc 2 76168
      , Element 39 Disc 0 78172
      , Element 40 Disc 1 80177
      , Element 41 Disc 2 82182
      , Element 42 Disc 0 84185
      , Element 43 Disc 1 86191
      , Element 44 Disc 2 88195
      , Element 45 Disc 0 90200
      , Element 46 Disc 1 92204
      , Element 47 Disc 2 94209
      , Element 48 Disc 0 96215
      , Element 49 Disc 1 98220
      , Element 50 Disc 2 100226
      , Element 51 Disc 0 102231
      , Element 52 Disc 1 104235
      , Element 53 Disc 2 106241
      , Element 54 Disc 0 108244
      , Element 55 Disc 1 110250
      , Element 56 Disc 2 112255
      , Element 57 Disc 0 114260
      , Element 58 Disc 1 116266
      , Element 59 Disc 2 118269
      , Element 60 Disc 0 120270
      , Element 61 Disc 1 122272
      , Element 62 Disc 2 124276
      , Element 63 Disc 0 126278
      , Element 64 Disc 1 128281
      , Element 65 Disc 2 130286
      , Element 66 Disc 0 132292
      , Element 67 Disc 1 134297
      , Element 68 Disc 2 136303
      , Element 69 Disc 0 138308
      , Element 70 Disc 1 140311
      , Element 71 Disc 2 142316
      , Element 72 Disc 0 144317
      , Element 73 Disc 1 146323
      , Element 74 Disc 2 148326
      , Element 75 Disc 0 150335
      , Element 76 Disc 1 152380
      , Element 77 Disc 2 154381
      , Element 78 Disc 0 156386
      , Element 79 Disc 1 158391
      , Element 80 Disc 2 160393
      , Element 81 Disc 0 162398
      , Element 82 Disc 1 164401
      , Element 83 Disc 2 166405
      , Element 84 Disc 0 168410
      , Element 85 Disc 1 170415
      , Element 86 Disc 2 172415
      , Element 87 Disc 0 174419
      , Element 88 Disc 1 176422
      , Element 89 Disc 2 178427
      , Element 90 Disc 0 180430
      , Element 91 Disc 1 182432
      , Element 92 Disc 2 184436
      , Element 93 Disc 0 186441
      , Element 94 Disc 1 188447
      , Element 95 Disc 2 190450
      , Element 96 Disc 0 192457
      , Element 97 Disc 1 194462
      , Element 98 Disc 2 196467
      , Element 99 Disc 0 198472
      , Element 100 Disc 1 200477
      , Element 101 Disc 2 202482
      , Element 102 Disc 0 204487
      , Element 103 Disc 1 206489
      , Element 104 Disc 2 208491
      , Element 105 Disc 0 210496
      , Element 106 Disc 1 212501
      , Element 107 Disc 2 214506
      , Element 108 Disc 0 216511
      , Element 109 Disc 1 218516
      , Element 110 Disc 2 220521
      , Element 111 Disc 0 222523
      , Element 112 Disc 1 224529
      , Element 113 Disc 2 226534
      , Element 114 Disc 0 228536
      , Element 115 Disc 1 230541
      , Element 116 Disc 2 232544
      , Element 117 Disc 0 234547
      , Element 118 Disc 1 236555
      , Element 119 Disc 2 238557
      , Element 120 Disc 0 240563
      , Element 121 Disc 1 242567
      , Element 122 Disc 2 244573
      , Element 123 Disc 0 246578
      , Element 124 Disc 1 248583
      , Element 125 Disc 2 250589
      , Element 126 Disc 0 252596
      , Element 127 Disc 1 254601
      , Element 128 Disc 2 256606
      , Element 129 Disc 0 258611
      , Element 130 Disc 1 260615
      , Element 131 Disc 2 262616
      , Element 132 Disc 0 264622
      , Element 133 Disc 1 266627
      , Element 134 Disc 2 268632
      , Element 135 Disc 0 270637
      , Element 136 Disc 1 272642
      , Element 137 Disc 2 274645
      , Element 138 Disc 0 276651
      , Element 139 Disc 1 278652
      , Element 140 Disc 2 280657
      , Element 141 Disc 0 282661
      , Element 142 Disc 1 284664
      , Element 143 Disc 2 286667
      , Element 144 Disc 0 288671
      , Element 145 Disc 1 290674
      , Element 146 Disc 2 292679
      , Element 147 Disc 0 294686
      , Element 148 Disc 1 296693
      , Element 149 Disc 2 298698
      , Element 150 Disc 0 300706
      , Element 151 Disc 1 302711
      , Element 152 Disc 2 304716
      , Element 153 Disc 0 306720
      , Element 154 Disc 1 308723
      , Element 155 Disc 2 310728
      , Element 156 Disc 0 312733
      , Element 157 Disc 1 314738
      , Element 158 Disc 2 316741
      , Element 159 Disc 0 318746
      , Element 160 Disc 1 320749
      , Element 161 Disc 2 322754
      , Element 162 Disc 0 324756
      , Element 163 Disc 1 326761
      , Element 164 Disc 2 328762
      , Element 165 Disc 0 330765
      , Element 166 Disc 1 332768
      , Element 167 Disc 2 334770
      , Element 168 Disc 0 336771
      , Element 169 Disc 1 338776
      , Element 170 Disc 2 340782
      , Element 171 Disc 0 342787
      , Element 172 Disc 1 344790
      , Element 173 Disc 2 346796
      , Element 174 Disc 0 348809
      , Element 175 Disc 1 350820
      , Element 176 Disc 2 352830
      , Element 177 Disc 0 354831
      , Element 178 Disc 1 356850
      , Element 179 Disc 2 358859
      , Element 180 Disc 0 360865
      , Element 181 Disc 1 362873
      , Element 182 Disc 2 364882
      , Element 183 Disc 0 366882
      , Element 184 Disc 1 368890
      , Element 185 Disc 2 370898
      , Element 186 Disc 0 372907
      , Element 187 Disc 1 374911
      , Element 188 Disc 2 376921
      , Element 189 Disc 0 378932
      , Element 190 Disc 1 380941
      , Element 191 Disc 2 382951
      , Element 192 Disc 0 384962
      , Element 193 Disc 1 386968
      , Element 194 Disc 2 388978
      , Element 195 Disc 0 390985
      , Element 196 Disc 1 392994
      , Element 197 Disc 2 394997
      , Element 198 Disc 0 397004
      , Element 199 Disc 1 399009
      , Element 200 Disc 2 401019
      , Element 201 Disc 0 403027
      , Element 202 Disc 1 405029
      , Element 203 Disc 2 407039
      , Element 204 Disc 0 409045
      , Element 205 Disc 1 411047
      , Element 206 Disc 2 413057
      , Element 207 Disc 0 415067
      , Element 208 Disc 1 417073
      , Element 209 Disc 2 419081
      , Element 210 Disc 0 421091
      , Element 211 Disc 1 423097
      , Element 212 Disc 2 425104
      , Element 213 Disc 0 427110
      , Element 214 Disc 1 429114
      , Element 215 Disc 2 431125
      , Element 216 Disc 0 433133
      , Element 217 Disc 1 435143
      , Element 218 Disc 2 437152
      , Element 219 Disc 0 439162
      , Element 220 Disc 1 441167
      , Element 221 Disc 2 443171
      , Element 222 Disc 0 445178
      , Element 223 Disc 1 447207
      , Element 224 Disc 2 449211
      , Element 225 Disc 0 451213
      , Element 226 Disc 1 453221
      , Element 227 Disc 2 455223
      , Element 228 Disc 0 457233
      , Element 229 Disc 1 459238
      , Element 230 Disc 2 461247
      , Element 231 Disc 0 463256
      , Element 232 Disc 1 465267
      , Element 233 Disc 2 467274
      , Element 234 Disc 0 469283
      , Element 235 Disc 1 471291
      , Element 236 Disc 2 473300
      , Element 237 Disc 0 475308
      , Element 238 Disc 1 477317
      , Element 239 Disc 2 479326
      , Element 240 Disc 0 481332
      , Element 241 Disc 1 483336
      , Element 242 Disc 2 485346
      , Element 243 Disc 0 487356
      , Element 244 Disc 1 489361
      , Element 245 Disc 2 491370
      , Element 246 Disc 0 493380
      , Element 247 Disc 1 495391
      , Element 248 Disc 2 497396
      , Element 249 Disc 0 499403
      , Element 250 Disc 1 501408
      , Element 251 Disc 2 503418
      , Element 252 Disc 0 505427
      , Element 253 Disc 1 507434
      , Element 254 Disc 2 509440
      , Element 255 Disc 0 511447
      , Element 256 Disc 1 513458
      , Element 257 Disc 2 515469
      , Element 258 Disc 0 517478
      , Element 259 Disc 1 519487
      , Element 260 Disc 2 521497
      , Element 261 Disc 0 523507
      , Element 262 Disc 1 525515
      , Element 263 Disc 2 527521
      , Element 264 Disc 0 529530
      , Element 265 Disc 1 531539
      , Element 266 Disc 2 533548
      , Element 267 Disc 0 535560
      , Element 268 Disc 1 537570
      , Element 269 Disc 2 539576
      , Element 270 Disc 0 541585
      , Element 271 Disc 1 543595
      , Element 272 Disc 2 545604
      , Element 273 Disc 0 547615
      , Element 274 Disc 1 549623
      , Element 275 Disc 2 551628
      , Element 276 Disc 0 553638
      , Element 277 Disc 1 555643
      , Element 278 Disc 2 557649
      , Element 279 Disc 0 559661
      , Element 280 Disc 1 561672
      , Element 281 Disc 2 563678
      , Element 282 Disc 0 565687
      , Element 283 Disc 1 567693
      , Element 284 Disc 2 569696
      , Element 285 Disc 0 571700
      , Element 286 Disc 1 573709
      , Element 287 Disc 2 575716
      , Element 288 Disc 0 577723
      , Element 289 Disc 1 579730
      , Element 290 Disc 2 581738
      , Element 291 Disc 0 583748
      , Element 292 Disc 1 585756
      , Element 293 Disc 2 587762
      , Element 294 Disc 0 589771
      , Element 295 Disc 1 591779
      , Element 296 Disc 2 593787
      , Element 297 Disc 0 595797
      , Element 298 Disc 1 597801
      , Element 299 Disc 2 599818
      ]
    }
  }
  { horizontalPosition = { leftEm = 4.5, widthEm = 7.5 }
  , operatorCode =
    [ "ops.map("
    , "\xA0\xA0lambda n: n*2"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 12, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Square 0 0
      , Element 2 Square 1 2003
      , Element 4 Square 2 4008
      , Element 6 Square 0 6013
      , Element 8 Square 1 8027
      , Element 10 Square 2 10034
      , Element 12 Square 0 12036
      , Element 14 Square 1 14037
      , Element 16 Square 2 16042
      , Element 18 Square 0 18048
      , Element 20 Square 1 20052
      , Element 22 Square 2 22054
      , Element 24 Square 0 24055
      , Element 26 Square 1 26056
      , Element 28 Square 2 28062
      , Element 30 Square 0 30067
      , Element 32 Square 1 32073
      , Element 34 Square 2 34078
      , Element 36 Square 0 36083
      , Element 38 Square 1 38085
      , Element 40 Square 2 40089
      , Element 42 Square 0 42091
      , Element 44 Square 1 44095
      , Element 46 Square 2 46099
      , Element 48 Square 0 48105
      , Element 50 Square 1 50110
      , Element 52 Square 2 52115
      , Element 54 Square 0 54120
      , Element 56 Square 1 56124
      , Element 58 Square 2 58128
      , Element 60 Square 0 60134
      , Element 62 Square 1 62137
      , Element 64 Square 2 64142
      , Element 66 Square 0 66146
      , Element 68 Square 1 68150
      , Element 70 Square 2 70153
      , Element 72 Square 0 72157
      , Element 74 Square 1 74164
      , Element 76 Square 2 76168
      , Element 78 Square 0 78172
      , Element 80 Square 1 80178
      , Element 82 Square 2 82182
      , Element 84 Square 0 84185
      , Element 86 Square 1 86191
      , Element 88 Square 2 88195
      , Element 90 Square 0 90200
      , Element 92 Square 1 92204
      , Element 94 Square 2 94209
      , Element 96 Square 0 96216
      , Element 98 Square 1 98220
      , Element 100 Square 2 100226
      , Element 102 Square 0 102231
      , Element 104 Square 1 104235
      , Element 106 Square 2 106241
      , Element 108 Square 0 108244
      , Element 110 Square 1 110250
      , Element 112 Square 2 112255
      , Element 114 Square 0 114260
      , Element 116 Square 1 116266
      , Element 118 Square 2 118269
      , Element 120 Square 0 120270
      , Element 122 Square 1 122272
      , Element 124 Square 2 124276
      , Element 126 Square 0 126278
      , Element 128 Square 1 128281
      , Element 130 Square 2 130286
      , Element 132 Square 0 132292
      , Element 134 Square 1 134298
      , Element 136 Square 2 136303
      , Element 138 Square 0 138308
      , Element 140 Square 1 140311
      , Element 142 Square 2 142316
      , Element 144 Square 0 144317
      , Element 146 Square 1 146323
      , Element 148 Square 2 148327
      , Element 150 Square 0 150335
      , Element 152 Square 1 152380
      , Element 154 Square 2 154381
      , Element 156 Square 0 156386
      , Element 158 Square 1 158391
      , Element 160 Square 2 160393
      , Element 162 Square 0 162398
      , Element 164 Square 1 164401
      , Element 166 Square 2 166405
      , Element 168 Square 0 168410
      , Element 170 Square 1 170415
      , Element 172 Square 2 172416
      , Element 174 Square 0 174419
      , Element 176 Square 1 176422
      , Element 178 Square 2 178427
      , Element 180 Square 0 180430
      , Element 182 Square 1 182432
      , Element 184 Square 2 184437
      , Element 186 Square 0 186441
      , Element 188 Square 1 188447
      , Element 190 Square 2 190450
      , Element 192 Square 0 192457
      , Element 194 Square 1 194462
      , Element 196 Square 2 196467
      , Element 198 Square 0 198473
      , Element 200 Square 1 200477
      , Element 202 Square 2 202482
      , Element 204 Square 0 204487
      , Element 206 Square 1 206489
      , Element 208 Square 2 208491
      , Element 210 Square 0 210496
      , Element 212 Square 1 212501
      , Element 214 Square 2 214506
      , Element 216 Square 0 216511
      , Element 218 Square 1 218516
      , Element 220 Square 2 220521
      , Element 222 Square 0 222523
      , Element 224 Square 1 224529
      , Element 226 Square 2 226534
      , Element 228 Square 0 228536
      , Element 230 Square 1 230541
      , Element 232 Square 2 232544
      , Element 234 Square 0 234547
      , Element 236 Square 1 236555
      , Element 238 Square 2 238557
      , Element 240 Square 0 240563
      , Element 242 Square 1 242568
      , Element 244 Square 2 244573
      , Element 246 Square 0 246578
      , Element 248 Square 1 248584
      , Element 250 Square 2 250590
      , Element 252 Square 0 252596
      , Element 254 Square 1 254601
      , Element 256 Square 2 256607
      , Element 258 Square 0 258611
      , Element 260 Square 1 260615
      , Element 262 Square 2 262616
      , Element 264 Square 0 264622
      , Element 266 Square 1 266627
      , Element 268 Square 2 268632
      , Element 270 Square 0 270637
      , Element 272 Square 1 272642
      , Element 274 Square 2 274645
      , Element 276 Square 0 276651
      , Element 278 Square 1 278652
      , Element 280 Square 2 280657
      , Element 282 Square 0 282661
      , Element 284 Square 1 284664
      , Element 286 Square 2 286667
      , Element 288 Square 0 288672
      , Element 290 Square 1 290674
      , Element 292 Square 2 292679
      , Element 294 Square 0 294686
      , Element 296 Square 1 296693
      , Element 298 Square 2 298698
      , Element 300 Square 0 300706
      , Element 302 Square 1 302712
      , Element 304 Square 2 304716
      , Element 306 Square 0 306720
      , Element 308 Square 1 308723
      , Element 310 Square 2 310728
      , Element 312 Square 0 312733
      , Element 314 Square 1 314738
      , Element 316 Square 2 316741
      , Element 318 Square 0 318746
      , Element 320 Square 1 320749
      , Element 322 Square 2 322754
      , Element 324 Square 0 324757
      , Element 326 Square 1 326761
      , Element 328 Square 2 328762
      , Element 330 Square 0 330765
      , Element 332 Square 1 332768
      , Element 334 Square 2 334770
      , Element 336 Square 0 336771
      , Element 338 Square 1 338776
      , Element 340 Square 2 340782
      , Element 342 Square 0 342787
      , Element 344 Square 1 344791
      , Element 346 Square 2 346796
      , Element 348 Square 0 348809
      , Element 350 Square 1 350826
      , Element 352 Square 2 352830
      , Element 354 Square 0 354831
      , Element 356 Square 1 356850
      , Element 358 Square 2 358859
      , Element 360 Square 0 360865
      , Element 362 Square 1 362873
      , Element 364 Square 2 364882
      , Element 366 Square 0 366882
      , Element 368 Square 1 368890
      , Element 370 Square 2 370898
      , Element 372 Square 0 372907
      , Element 374 Square 1 374912
      , Element 376 Square 2 376921
      , Element 378 Square 0 378932
      , Element 380 Square 1 380941
      , Element 382 Square 2 382951
      , Element 384 Square 0 384962
      , Element 386 Square 1 386968
      , Element 388 Square 2 388978
      , Element 390 Square 0 390985
      , Element 392 Square 1 392994
      , Element 394 Square 2 394997
      , Element 396 Square 0 397004
      , Element 398 Square 1 399009
      , Element 400 Square 2 401019
      , Element 402 Square 0 403027
      , Element 404 Square 1 405029
      , Element 406 Square 2 407039
      , Element 408 Square 0 409045
      , Element 410 Square 1 411047
      , Element 412 Square 2 413057
      , Element 414 Square 0 415067
      , Element 416 Square 1 417073
      , Element 418 Square 2 419081
      , Element 420 Square 0 421091
      , Element 422 Square 1 423097
      , Element 424 Square 2 425104
      , Element 426 Square 0 427110
      , Element 428 Square 1 429114
      , Element 430 Square 2 431125
      , Element 432 Square 0 433133
      , Element 434 Square 1 435143
      , Element 436 Square 2 437152
      , Element 438 Square 0 439162
      , Element 440 Square 1 441167
      , Element 442 Square 2 443171
      , Element 444 Square 0 445178
      , Element 446 Square 1 447207
      , Element 448 Square 2 449211
      , Element 450 Square 0 451214
      , Element 452 Square 1 453221
      , Element 454 Square 2 455223
      , Element 456 Square 0 457233
      , Element 458 Square 1 459238
      , Element 460 Square 2 461247
      , Element 462 Square 0 463256
      , Element 464 Square 1 465267
      , Element 466 Square 2 467274
      , Element 468 Square 0 469283
      , Element 470 Square 1 471292
      , Element 472 Square 2 473300
      , Element 474 Square 0 475308
      , Element 476 Square 1 477317
      , Element 478 Square 2 479326
      , Element 480 Square 0 481332
      , Element 482 Square 1 483336
      , Element 484 Square 2 485346
      , Element 486 Square 0 487356
      , Element 488 Square 1 489362
      , Element 490 Square 2 491370
      , Element 492 Square 0 493381
      , Element 494 Square 1 495391
      , Element 496 Square 2 497396
      , Element 498 Square 0 499403
      , Element 500 Square 1 501408
      , Element 502 Square 2 503418
      , Element 504 Square 0 505427
      , Element 506 Square 1 507434
      , Element 508 Square 2 509440
      , Element 510 Square 0 511447
      , Element 512 Square 1 513460
      , Element 514 Square 2 515469
      , Element 516 Square 0 517478
      , Element 518 Square 1 519487
      , Element 520 Square 2 521498
      , Element 522 Square 0 523507
      , Element 524 Square 1 525515
      , Element 526 Square 2 527521
      , Element 528 Square 0 529530
      , Element 530 Square 1 531539
      , Element 532 Square 2 533548
      , Element 534 Square 0 535560
      , Element 536 Square 1 537570
      , Element 538 Square 2 539576
      , Element 540 Square 0 541585
      , Element 542 Square 1 543595
      , Element 544 Square 2 545604
      , Element 546 Square 0 547615
      , Element 548 Square 1 549623
      , Element 550 Square 2 551628
      , Element 552 Square 0 553638
      , Element 554 Square 1 555643
      , Element 556 Square 2 557649
      , Element 558 Square 0 559661
      , Element 560 Square 1 561672
      , Element 562 Square 2 563678
      , Element 564 Square 0 565687
      , Element 566 Square 1 567693
      , Element 568 Square 2 569696
      , Element 570 Square 0 571700
      , Element 572 Square 1 573709
      , Element 574 Square 2 575716
      , Element 576 Square 0 577723
      , Element 578 Square 1 579730
      , Element 580 Square 2 581738
      , Element 582 Square 0 583748
      , Element 584 Square 1 585756
      , Element 586 Square 2 587762
      , Element 588 Square 0 589771
      , Element 590 Square 1 591779
      , Element 592 Square 2 593787
      , Element 594 Square 0 595797
      , Element 596 Square 1 597801
      , Element 598 Square 2 599818
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
mapped: rx.Observable[int] = numbers >> ops.map(
    lambda n: n*2
)
mapped.run()
""" showCode


operatorFilter : Bool -> Bool -> UnindexedSlideModel
operatorFilter showCode animate =
  operator "filter: Conditionally Remove Elements"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.filter(...)"
      , text " accepts a predicate function, and returns a new Observable of elements that match the predicate."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "Output size is no larger than input" ]
        , li [] [ text "Output type is the same type as input" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 0.5, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 2008
      , Element 2 Disc 2 4014
      , Element 3 Disc 0 6022
      , Element 4 Disc 1 8028
      , Element 5 Disc 2 10038
      , Element 6 Disc 0 12048
      , Element 7 Disc 1 14059
      , Element 8 Disc 2 16068
      , Element 9 Disc 0 18078
      , Element 10 Disc 1 20085
      , Element 11 Disc 2 22095
      , Element 12 Disc 0 24103
      , Element 13 Disc 1 26113
      , Element 14 Disc 2 28119
      , Element 15 Disc 0 30129
      , Element 16 Disc 1 32139
      , Element 17 Disc 2 34147
      , Element 18 Disc 0 36156
      , Element 19 Disc 1 38164
      , Element 20 Disc 2 40172
      , Element 21 Disc 0 42182
      , Element 22 Disc 1 44192
      , Element 23 Disc 2 46202
      , Element 24 Disc 0 48212
      , Element 25 Disc 1 50217
      , Element 26 Disc 2 52221
      , Element 27 Disc 0 54228
      , Element 28 Disc 1 56238
      , Element 29 Disc 2 58247
      , Element 30 Disc 0 60253
      , Element 31 Disc 1 62259
      , Element 32 Disc 2 64268
      , Element 33 Disc 0 66277
      , Element 34 Disc 1 68286
      , Element 35 Disc 2 70292
      , Element 36 Disc 0 72300
      , Element 37 Disc 1 74320
      , Element 38 Disc 2 76330
      , Element 39 Disc 0 78338
      , Element 40 Disc 1 80346
      , Element 41 Disc 2 82356
      , Element 42 Disc 0 84365
      , Element 43 Disc 1 86374
      , Element 44 Disc 2 88381
      , Element 45 Disc 0 90388
      , Element 46 Disc 1 92398
      , Element 47 Disc 2 94408
      , Element 48 Disc 0 96419
      , Element 49 Disc 1 98427
      , Element 50 Disc 2 100436
      , Element 51 Disc 0 102441
      , Element 52 Disc 1 104449
      , Element 53 Disc 2 106458
      , Element 54 Disc 0 108468
      , Element 55 Disc 1 110477
      , Element 56 Disc 2 112484
      , Element 57 Disc 0 114492
      , Element 58 Disc 1 116502
      , Element 59 Disc 2 118508
      , Element 60 Disc 0 120518
      , Element 61 Disc 1 122526
      , Element 62 Disc 2 124533
      , Element 63 Disc 0 126542
      , Element 64 Disc 1 128551
      , Element 65 Disc 2 130561
      , Element 66 Disc 0 132567
      , Element 67 Disc 1 134568
      , Element 68 Disc 2 136572
      , Element 69 Disc 0 138580
      , Element 70 Disc 1 140586
      , Element 71 Disc 2 142594
      , Element 72 Disc 0 144602
      , Element 73 Disc 1 146612
      , Element 74 Disc 2 148620
      , Element 75 Disc 0 150631
      , Element 76 Disc 1 152641
      , Element 77 Disc 2 154652
      , Element 78 Disc 0 156657
      , Element 79 Disc 1 158662
      , Element 80 Disc 2 160668
      , Element 81 Disc 0 162674
      , Element 82 Disc 1 164680
      , Element 83 Disc 2 166691
      , Element 84 Disc 0 168698
      , Element 85 Disc 1 170707
      , Element 86 Disc 2 172717
      , Element 87 Disc 0 174727
      , Element 88 Disc 1 176734
      , Element 89 Disc 2 178744
      , Element 90 Disc 0 180750
      , Element 91 Disc 1 182759
      , Element 92 Disc 2 184769
      , Element 93 Disc 0 186773
      , Element 94 Disc 1 188777
      , Element 95 Disc 2 190783
      , Element 96 Disc 0 192791
      , Element 97 Disc 1 194796
      , Element 98 Disc 2 196803
      , Element 99 Disc 0 198812
      , Element 100 Disc 1 200817
      , Element 101 Disc 2 202825
      , Element 102 Disc 0 204834
      , Element 103 Disc 1 206844
      , Element 104 Disc 2 208850
      , Element 105 Disc 0 210859
      , Element 106 Disc 1 212867
      , Element 107 Disc 2 214875
      , Element 108 Disc 0 216877
      , Element 109 Disc 1 218887
      , Element 110 Disc 2 220894
      , Element 111 Disc 0 222902
      , Element 112 Disc 1 224908
      , Element 113 Disc 2 226915
      , Element 114 Disc 0 228924
      , Element 115 Disc 1 230930
      , Element 116 Disc 2 232939
      , Element 117 Disc 0 234949
      , Element 118 Disc 1 236954
      , Element 119 Disc 2 238963
      , Element 120 Disc 0 240968
      , Element 121 Disc 1 242978
      , Element 122 Disc 2 244984
      , Element 123 Disc 0 246989
      , Element 124 Disc 1 248997
      , Element 125 Disc 2 251004
      , Element 126 Disc 0 253013
      , Element 127 Disc 1 255020
      , Element 128 Disc 2 257031
      , Element 129 Disc 0 259037
      , Element 130 Disc 1 261047
      , Element 131 Disc 2 263057
      , Element 132 Disc 0 265062
      , Element 133 Disc 1 267066
      , Element 134 Disc 2 269076
      , Element 135 Disc 0 271083
      , Element 136 Disc 1 273088
      , Element 137 Disc 2 275095
      , Element 138 Disc 0 277099
      , Element 139 Disc 1 279106
      , Element 140 Disc 2 281115
      , Element 141 Disc 0 283118
      , Element 142 Disc 1 285120
      , Element 143 Disc 2 287128
      , Element 144 Disc 0 289136
      , Element 145 Disc 1 291138
      , Element 146 Disc 2 293143
      , Element 147 Disc 0 295153
      , Element 148 Disc 1 297158
      , Element 149 Disc 2 299165
      , Element 150 Disc 0 301175
      , Element 151 Disc 1 303185
      , Element 152 Disc 2 305190
      , Element 153 Disc 0 307195
      , Element 154 Disc 1 309203
      , Element 155 Disc 2 311211
      , Element 156 Disc 0 313218
      , Element 157 Disc 1 315220
      , Element 158 Disc 2 317226
      , Element 159 Disc 0 319231
      , Element 160 Disc 1 321239
      , Element 161 Disc 2 323247
      , Element 162 Disc 0 325254
      , Element 163 Disc 1 327262
      , Element 164 Disc 2 329266
      , Element 165 Disc 0 331274
      , Element 166 Disc 1 333284
      , Element 167 Disc 2 335292
      , Element 168 Disc 0 337301
      , Element 169 Disc 1 339303
      , Element 170 Disc 2 341313
      , Element 171 Disc 0 343318
      , Element 172 Disc 1 345328
      , Element 173 Disc 2 347337
      , Element 174 Disc 0 349345
      , Element 175 Disc 1 351355
      , Element 176 Disc 2 353361
      , Element 177 Disc 0 355371
      , Element 178 Disc 1 357380
      , Element 179 Disc 2 359388
      , Element 180 Disc 0 361398
      , Element 181 Disc 1 363408
      , Element 182 Disc 2 365419
      , Element 183 Disc 0 367427
      , Element 184 Disc 1 369436
      , Element 185 Disc 2 371445
      , Element 186 Disc 0 373453
      , Element 187 Disc 1 375457
      , Element 188 Disc 2 377464
      , Element 189 Disc 0 379471
      , Element 190 Disc 1 381479
      , Element 191 Disc 2 383484
      , Element 192 Disc 0 385491
      , Element 193 Disc 1 387498
      , Element 194 Disc 2 389506
      , Element 195 Disc 0 391516
      , Element 196 Disc 1 393526
      , Element 197 Disc 2 395537
      , Element 198 Disc 0 397545
      , Element 199 Disc 1 399555
      , Element 200 Disc 2 401565
      , Element 201 Disc 0 403574
      , Element 202 Disc 1 405576
      , Element 203 Disc 2 407584
      , Element 204 Disc 0 409589
      , Element 205 Disc 1 411597
      , Element 206 Disc 2 413606
      , Element 207 Disc 0 415611
      , Element 208 Disc 1 417616
      , Element 209 Disc 2 419621
      , Element 210 Disc 0 421631
      , Element 211 Disc 1 423640
      , Element 212 Disc 2 425650
      , Element 213 Disc 0 427660
      , Element 214 Disc 1 429663
      , Element 215 Disc 2 431668
      , Element 216 Disc 0 433674
      , Element 217 Disc 1 435682
      , Element 218 Disc 2 437688
      , Element 219 Disc 0 439695
      , Element 220 Disc 1 441704
      , Element 221 Disc 2 443710
      , Element 222 Disc 0 445719
      , Element 223 Disc 1 447727
      , Element 224 Disc 2 449735
      , Element 225 Disc 0 451742
      , Element 226 Disc 1 453748
      , Element 227 Disc 2 455755
      , Element 228 Disc 0 457764
      , Element 229 Disc 1 459774
      , Element 230 Disc 2 461778
      , Element 231 Disc 0 463786
      , Element 232 Disc 1 465792
      , Element 233 Disc 2 467798
      , Element 234 Disc 0 469822
      , Element 235 Disc 1 471832
      , Element 236 Disc 2 473843
      , Element 237 Disc 0 475853
      , Element 238 Disc 1 477862
      , Element 239 Disc 2 479871
      , Element 240 Disc 0 481880
      , Element 241 Disc 1 483888
      , Element 242 Disc 2 485897
      , Element 243 Disc 0 487903
      , Element 244 Disc 1 489910
      , Element 245 Disc 2 491918
      , Element 246 Disc 0 493925
      , Element 247 Disc 1 495934
      , Element 248 Disc 2 497943
      , Element 249 Disc 0 499953
      , Element 250 Disc 1 501962
      , Element 251 Disc 2 503970
      , Element 252 Disc 0 505975
      , Element 253 Disc 1 507984
      , Element 254 Disc 2 509994
      , Element 255 Disc 0 512003
      , Element 256 Disc 1 514013
      , Element 257 Disc 2 516023
      , Element 258 Disc 0 518033
      , Element 259 Disc 1 520043
      , Element 260 Disc 2 522051
      , Element 261 Disc 0 524058
      , Element 262 Disc 1 526067
      , Element 263 Disc 2 528075
      , Element 264 Disc 0 530079
      , Element 265 Disc 1 532086
      , Element 266 Disc 2 534096
      , Element 267 Disc 0 536102
      , Element 268 Disc 1 538109
      , Element 269 Disc 2 540117
      , Element 270 Disc 0 542126
      , Element 271 Disc 1 544136
      , Element 272 Disc 2 546145
      , Element 273 Disc 0 548152
      , Element 274 Disc 1 550160
      , Element 275 Disc 2 552165
      , Element 276 Disc 0 554174
      , Element 277 Disc 1 556184
      , Element 278 Disc 2 558190
      , Element 279 Disc 0 560199
      , Element 280 Disc 1 562206
      , Element 281 Disc 2 564213
      , Element 282 Disc 0 566221
      , Element 283 Disc 1 568231
      , Element 284 Disc 2 570241
      , Element 285 Disc 0 572250
      , Element 286 Disc 1 574259
      , Element 287 Disc 2 576267
      , Element 288 Disc 0 578277
      , Element 289 Disc 1 580286
      , Element 290 Disc 2 582295
      , Element 291 Disc 0 584302
      , Element 292 Disc 1 586308
      , Element 293 Disc 2 588316
      , Element 294 Disc 0 590319
      , Element 295 Disc 1 592329
      , Element 296 Disc 2 594339
      , Element 297 Disc 0 596339
      , Element 298 Disc 1 598347
      , Element 299 Disc 2 600353
      ]
    }
  }
  { horizontalPosition = { leftEm = 3.25, widthEm = 9.5 }
  , operatorCode =
    [ "ops.filter("
    , "\xA0\xA0lambda n: n%2 == 0"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 13, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 2
      , Element 2 Disc 2 4014
      , Element 4 Disc 1 8028
      , Element 6 Disc 0 12048
      , Element 8 Disc 2 16068
      , Element 10 Disc 1 20085
      , Element 12 Disc 0 24103
      , Element 14 Disc 2 28119
      , Element 16 Disc 1 32139
      , Element 18 Disc 0 36156
      , Element 20 Disc 2 40172
      , Element 22 Disc 1 44192
      , Element 24 Disc 0 48212
      , Element 26 Disc 2 52221
      , Element 28 Disc 1 56238
      , Element 30 Disc 0 60253
      , Element 32 Disc 2 64268
      , Element 34 Disc 1 68286
      , Element 36 Disc 0 72300
      , Element 38 Disc 2 76331
      , Element 40 Disc 1 80346
      , Element 42 Disc 0 84365
      , Element 44 Disc 2 88381
      , Element 46 Disc 1 92398
      , Element 48 Disc 0 96419
      , Element 50 Disc 2 100436
      , Element 52 Disc 1 104449
      , Element 54 Disc 0 108468
      , Element 56 Disc 2 112484
      , Element 58 Disc 1 116502
      , Element 60 Disc 0 120519
      , Element 62 Disc 2 124533
      , Element 64 Disc 1 128551
      , Element 66 Disc 0 132567
      , Element 68 Disc 2 136572
      , Element 70 Disc 1 140586
      , Element 72 Disc 0 144602
      , Element 74 Disc 2 148620
      , Element 76 Disc 1 152641
      , Element 78 Disc 0 156657
      , Element 80 Disc 2 160668
      , Element 82 Disc 1 164680
      , Element 84 Disc 0 168698
      , Element 86 Disc 2 172717
      , Element 88 Disc 1 176734
      , Element 90 Disc 0 180750
      , Element 92 Disc 2 184769
      , Element 94 Disc 1 188777
      , Element 96 Disc 0 192791
      , Element 98 Disc 2 196803
      , Element 100 Disc 1 200817
      , Element 102 Disc 0 204834
      , Element 104 Disc 2 208850
      , Element 106 Disc 1 212867
      , Element 108 Disc 0 216877
      , Element 110 Disc 2 220894
      , Element 112 Disc 1 224908
      , Element 114 Disc 0 228924
      , Element 116 Disc 2 232939
      , Element 118 Disc 1 236954
      , Element 120 Disc 0 240968
      , Element 122 Disc 2 244984
      , Element 124 Disc 1 248998
      , Element 126 Disc 0 253013
      , Element 128 Disc 2 257031
      , Element 130 Disc 1 261047
      , Element 132 Disc 0 265062
      , Element 134 Disc 2 269076
      , Element 136 Disc 1 273088
      , Element 138 Disc 0 277099
      , Element 140 Disc 2 281115
      , Element 142 Disc 1 285120
      , Element 144 Disc 0 289136
      , Element 146 Disc 2 293143
      , Element 148 Disc 1 297158
      , Element 150 Disc 0 301175
      , Element 152 Disc 2 305190
      , Element 154 Disc 1 309203
      , Element 156 Disc 0 313218
      , Element 158 Disc 2 317226
      , Element 160 Disc 1 321239
      , Element 162 Disc 0 325254
      , Element 164 Disc 2 329267
      , Element 166 Disc 1 333284
      , Element 168 Disc 0 337301
      , Element 170 Disc 2 341313
      , Element 172 Disc 1 345328
      , Element 174 Disc 0 349345
      , Element 176 Disc 2 353361
      , Element 178 Disc 1 357380
      , Element 180 Disc 0 361398
      , Element 182 Disc 2 365419
      , Element 184 Disc 1 369436
      , Element 186 Disc 0 373453
      , Element 188 Disc 2 377464
      , Element 190 Disc 1 381479
      , Element 192 Disc 0 385491
      , Element 194 Disc 2 389506
      , Element 196 Disc 1 393526
      , Element 198 Disc 0 397545
      , Element 200 Disc 2 401565
      , Element 202 Disc 1 405576
      , Element 204 Disc 0 409589
      , Element 206 Disc 2 413606
      , Element 208 Disc 1 417616
      , Element 210 Disc 0 421631
      , Element 212 Disc 2 425651
      , Element 214 Disc 1 429663
      , Element 216 Disc 0 433674
      , Element 218 Disc 2 437688
      , Element 220 Disc 1 441704
      , Element 222 Disc 0 445720
      , Element 224 Disc 2 449735
      , Element 226 Disc 1 453748
      , Element 228 Disc 0 457765
      , Element 230 Disc 2 461779
      , Element 232 Disc 1 465792
      , Element 234 Disc 0 469822
      , Element 236 Disc 2 473843
      , Element 238 Disc 1 477862
      , Element 240 Disc 0 481880
      , Element 242 Disc 2 485897
      , Element 244 Disc 1 489910
      , Element 246 Disc 0 493925
      , Element 248 Disc 2 497943
      , Element 250 Disc 1 501963
      , Element 252 Disc 0 505975
      , Element 254 Disc 2 509994
      , Element 256 Disc 1 514014
      , Element 258 Disc 0 518033
      , Element 260 Disc 2 522051
      , Element 262 Disc 1 526067
      , Element 264 Disc 0 530079
      , Element 266 Disc 2 534096
      , Element 268 Disc 1 538109
      , Element 270 Disc 0 542126
      , Element 272 Disc 2 546145
      , Element 274 Disc 1 550160
      , Element 276 Disc 0 554174
      , Element 278 Disc 2 558190
      , Element 280 Disc 1 562206
      , Element 282 Disc 0 566221
      , Element 284 Disc 2 570241
      , Element 286 Disc 1 574259
      , Element 288 Disc 0 578277
      , Element 290 Disc 2 582295
      , Element 292 Disc 1 586308
      , Element 294 Disc 0 590319
      , Element 296 Disc 2 594339
      , Element 298 Disc 1 598347
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
filtered: rx.Observable[int] = numbers >> ops.filter(
    lambda n: n%2 == 0
)
filtered.run()
""" showCode


operatorTake : Bool -> Bool -> UnindexedSlideModel
operatorTake showCode animate =
  operator "take: Retain the First Few Elements"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.take(...)"
      , text " accepts a count, and returns an Observable with up to that number of elements."
      ]
    , p []
      [ text "It is often used to turn an infinite Observable into a finite Observable."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "Output is always finite, and no larger than input" ]
        , li [] [ text "Output type is the same type as input" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 2, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 2008
      , Element 2 Disc 2 4015
      , Element 3 Disc 0 6025
      , Element 4 Disc 1 8033
      , Element 5 Disc 2 10038
      , Element 6 Disc 0 12045
      , Element 7 Disc 1 14055
      , Element 8 Disc 2 16062
      , Element 9 Disc 0 18070
      ]
    }
  }
  { horizontalPosition = { leftEm = 5, widthEm = 6 }
  , operatorCode = [ "ops.take(10)" ]
  }
  { horizontalPosition = { leftEm = 12, widthEm = 3 }
  , value =
    Stream
    { terminal = True
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 2008
      , Element 2 Disc 2 4015
      , Element 3 Disc 0 6025
      , Element 4 Disc 1 8034
      , Element 5 Disc 2 10038
      , Element 6 Disc 0 12045
      , Element 7 Disc 1 14055
      , Element 8 Disc 2 16063
      , Element 9 Disc 0 18070
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
first10: rx.Observable[int] = numbers >> ops.take(10)
first10.run()
""" showCode


operatorFlatMapMerge : Bool -> Bool -> UnindexedSlideModel
operatorFlatMapMerge showCode animate =
  operator "flat_map: Map to Observables, flatten concurrently"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.flat_map(...)"
      , text " takes a function that transforms elements into Observables, applying it to each element, and returns an Observable with the resultant Observable flattened, "
      , i [] [ text "concurrently" ]
      , text "."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "If the input is empty, the output too must be empty" ]
        , li [] [ text "Output type can be anything (determined by transformation function)" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 1.5, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 2013
      , Element 2 Disc 2 4025
      , Element 3 Disc 0 6035
      , Element 4 Disc 1 8044
      , Element 5 Disc 2 10055
      , Element 6 Disc 0 12064
      , Element 7 Disc 1 14069
      , Element 8 Disc 2 16079
      , Element 9 Disc 0 18086
      , Element 10 Disc 1 20094
      , Element 11 Disc 2 22103
      , Element 12 Disc 0 24112
      , Element 13 Disc 1 26121
      , Element 14 Disc 2 28131
      , Element 15 Disc 0 30137
      , Element 16 Disc 1 32145
      , Element 17 Disc 2 34154
      , Element 18 Disc 0 36159
      , Element 19 Disc 1 38163
      , Element 20 Disc 2 40171
      , Element 21 Disc 0 42180
      , Element 22 Disc 1 44189
      , Element 23 Disc 2 46199
      , Element 24 Disc 0 48206
      , Element 25 Disc 1 50216
      , Element 26 Disc 2 52224
      , Element 27 Disc 0 54232
      , Element 28 Disc 1 56238
      , Element 29 Disc 2 58263
      , Element 30 Disc 0 60268
      , Element 31 Disc 1 62273
      , Element 32 Disc 2 64284
      , Element 33 Disc 0 66288
      , Element 34 Disc 1 68298
      , Element 35 Disc 2 70308
      , Element 36 Disc 0 72318
      , Element 37 Disc 1 74321
      , Element 38 Disc 2 76326
      , Element 39 Disc 0 78334
      , Element 40 Disc 1 80344
      , Element 41 Disc 2 82353
      , Element 42 Disc 0 84364
      , Element 43 Disc 1 86373
      , Element 44 Disc 2 88380
      , Element 45 Disc 0 90387
      , Element 46 Disc 1 92397
      , Element 47 Disc 2 94405
      , Element 48 Disc 0 96414
      , Element 49 Disc 1 98423
      , Element 50 Disc 2 100432
      , Element 51 Disc 0 102443
      , Element 52 Disc 1 104449
      , Element 53 Disc 2 106454
      , Element 54 Disc 0 108460
      , Element 55 Disc 1 110472
      , Element 56 Disc 2 112479
      , Element 57 Disc 0 114489
      , Element 58 Disc 1 116492
      , Element 59 Disc 2 118499
      , Element 60 Disc 0 120509
      , Element 61 Disc 1 122515
      , Element 62 Disc 2 124526
      , Element 63 Disc 0 126530
      , Element 64 Disc 1 128536
      , Element 65 Disc 2 130538
      , Element 66 Disc 0 132549
      , Element 67 Disc 1 134560
      , Element 68 Disc 2 136570
      , Element 69 Disc 0 138573
      , Element 70 Disc 1 140582
      , Element 71 Disc 2 142592
      , Element 72 Disc 0 144602
      , Element 73 Disc 1 146610
      , Element 74 Disc 2 148620
      , Element 75 Disc 0 150627
      , Element 76 Disc 1 152638
      , Element 77 Disc 2 154648
      , Element 78 Disc 0 156658
      , Element 79 Disc 1 158667
      , Element 80 Disc 2 160677
      , Element 81 Disc 0 162682
      , Element 82 Disc 1 164690
      , Element 83 Disc 2 166698
      , Element 84 Disc 0 168708
      , Element 85 Disc 1 170712
      , Element 86 Disc 2 172722
      , Element 87 Disc 0 174730
      , Element 88 Disc 1 176739
      , Element 89 Disc 2 178748
      , Element 90 Disc 0 180756
      , Element 91 Disc 1 182765
      , Element 92 Disc 2 184776
      , Element 93 Disc 0 186781
      , Element 94 Disc 1 188790
      , Element 95 Disc 2 190798
      , Element 96 Disc 0 192803
      , Element 97 Disc 1 194806
      , Element 98 Disc 2 196815
      , Element 99 Disc 0 198823
      , Element 100 Disc 1 200832
      , Element 101 Disc 2 202838
      , Element 102 Disc 0 204848
      , Element 103 Disc 1 206856
      , Element 104 Disc 2 208864
      , Element 105 Disc 0 210873
      , Element 106 Disc 1 212881
      , Element 107 Disc 2 214892
      , Element 108 Disc 0 216900
      , Element 109 Disc 1 218908
      , Element 110 Disc 2 220919
      , Element 111 Disc 0 222926
      , Element 112 Disc 1 224934
      , Element 113 Disc 2 226940
      , Element 114 Disc 0 228951
      , Element 115 Disc 1 230959
      , Element 116 Disc 2 232968
      , Element 117 Disc 0 234977
      , Element 118 Disc 1 236987
      , Element 119 Disc 2 238996
      , Element 120 Disc 0 241006
      , Element 121 Disc 1 243016
      , Element 122 Disc 2 245027
      , Element 123 Disc 0 247033
      , Element 124 Disc 1 249042
      , Element 125 Disc 2 251052
      , Element 126 Disc 0 253060
      , Element 127 Disc 1 255068
      , Element 128 Disc 2 257078
      , Element 129 Disc 0 259088
      , Element 130 Disc 1 261096
      , Element 131 Disc 2 263101
      , Element 132 Disc 0 265107
      , Element 133 Disc 1 267114
      , Element 134 Disc 2 269122
      , Element 135 Disc 0 271129
      , Element 136 Disc 1 273140
      , Element 137 Disc 2 275144
      , Element 138 Disc 0 277155
      , Element 139 Disc 1 279164
      , Element 140 Disc 2 281173
      , Element 141 Disc 0 283181
      , Element 142 Disc 1 285187
      , Element 143 Disc 2 287196
      , Element 144 Disc 0 289206
      , Element 145 Disc 1 291215
      , Element 146 Disc 2 293222
      , Element 147 Disc 0 295232
      , Element 148 Disc 1 297243
      , Element 149 Disc 2 299252
      , Element 150 Disc 0 301263
      , Element 151 Disc 1 303273
      , Element 152 Disc 2 305278
      , Element 153 Disc 0 307285
      , Element 154 Disc 1 309294
      , Element 155 Disc 2 311304
      , Element 156 Disc 0 313315
      , Element 157 Disc 1 315323
      , Element 158 Disc 2 317332
      , Element 159 Disc 0 319340
      , Element 160 Disc 1 321351
      , Element 161 Disc 2 323369
      , Element 162 Disc 0 325376
      , Element 163 Disc 1 327378
      , Element 164 Disc 2 329386
      , Element 165 Disc 0 331390
      , Element 166 Disc 1 333396
      , Element 167 Disc 2 335404
      , Element 168 Disc 0 337414
      , Element 169 Disc 1 339424
      , Element 170 Disc 2 341433
      , Element 171 Disc 0 343438
      , Element 172 Disc 1 345446
      , Element 173 Disc 2 347456
      , Element 174 Disc 0 349465
      , Element 175 Disc 1 351473
      , Element 176 Disc 2 353480
      , Element 177 Disc 0 355490
      , Element 178 Disc 1 357500
      , Element 179 Disc 2 359509
      , Element 180 Disc 0 361514
      , Element 181 Disc 1 363517
      , Element 182 Disc 2 365528
      , Element 183 Disc 0 367536
      , Element 184 Disc 1 369540
      , Element 185 Disc 2 371548
      , Element 186 Disc 0 373555
      , Element 187 Disc 1 375565
      , Element 188 Disc 2 377575
      , Element 189 Disc 0 379584
      , Element 190 Disc 1 381592
      , Element 191 Disc 2 383597
      , Element 192 Disc 0 385600
      , Element 193 Disc 1 387606
      , Element 194 Disc 2 389613
      , Element 195 Disc 0 391621
      , Element 196 Disc 1 393629
      , Element 197 Disc 2 395640
      , Element 198 Disc 0 397648
      , Element 199 Disc 1 399653
      , Element 200 Disc 2 401663
      , Element 201 Disc 0 403672
      , Element 202 Disc 1 405681
      , Element 203 Disc 2 407684
      , Element 204 Disc 0 409687
      , Element 205 Disc 1 411697
      , Element 206 Disc 2 413705
      , Element 207 Disc 0 415714
      , Element 208 Disc 1 417723
      , Element 209 Disc 2 419734
      , Element 210 Disc 0 421739
      , Element 211 Disc 1 423747
      , Element 212 Disc 2 425756
      , Element 213 Disc 0 427764
      , Element 214 Disc 1 429773
      , Element 215 Disc 2 431783
      , Element 216 Disc 0 433790
      , Element 217 Disc 1 435800
      , Element 218 Disc 2 437810
      , Element 219 Disc 0 439819
      , Element 220 Disc 1 441827
      , Element 221 Disc 2 443841
      , Element 222 Disc 0 445847
      , Element 223 Disc 1 447857
      , Element 224 Disc 2 449861
      , Element 225 Disc 0 451863
      , Element 226 Disc 1 453871
      , Element 227 Disc 2 455875
      , Element 228 Disc 0 457879
      , Element 229 Disc 1 459889
      , Element 230 Disc 2 461900
      , Element 231 Disc 0 463909
      , Element 232 Disc 1 465912
      , Element 233 Disc 2 467917
      , Element 234 Disc 0 469928
      , Element 235 Disc 1 471938
      , Element 236 Disc 2 473948
      , Element 237 Disc 0 475956
      , Element 238 Disc 1 477967
      , Element 239 Disc 2 479973
      , Element 240 Disc 0 481982
      , Element 241 Disc 1 483990
      , Element 242 Disc 2 485999
      , Element 243 Disc 0 488010
      , Element 244 Disc 1 490022
      , Element 245 Disc 2 492030
      , Element 246 Disc 0 494040
      , Element 247 Disc 1 496049
      , Element 248 Disc 2 498059
      , Element 249 Disc 0 500067
      , Element 250 Disc 1 502075
      , Element 251 Disc 2 504077
      , Element 252 Disc 0 506087
      , Element 253 Disc 1 508096
      , Element 254 Disc 2 510105
      , Element 255 Disc 0 512109
      , Element 256 Disc 1 514120
      , Element 257 Disc 2 516130
      , Element 258 Disc 0 518140
      , Element 259 Disc 1 520151
      , Element 260 Disc 2 522159
      , Element 261 Disc 0 524165
      , Element 262 Disc 1 526173
      , Element 263 Disc 2 528182
      , Element 264 Disc 0 530191
      , Element 265 Disc 1 532200
      , Element 266 Disc 2 534208
      , Element 267 Disc 0 536217
      , Element 268 Disc 1 538227
      , Element 269 Disc 2 540236
      , Element 270 Disc 0 542248
      , Element 271 Disc 1 544255
      , Element 272 Disc 2 546265
      , Element 273 Disc 0 548273
      , Element 274 Disc 1 550278
      , Element 275 Disc 2 552286
      , Element 276 Disc 0 554296
      , Element 277 Disc 1 556301
      , Element 278 Disc 2 558311
      , Element 279 Disc 0 560319
      , Element 280 Disc 1 562329
      , Element 281 Disc 2 564339
      , Element 282 Disc 0 566346
      , Element 283 Disc 1 568350
      , Element 284 Disc 2 570360
      , Element 285 Disc 0 572368
      , Element 286 Disc 1 574375
      , Element 287 Disc 2 576385
      , Element 288 Disc 0 578387
      , Element 289 Disc 1 580391
      , Element 290 Disc 2 582397
      , Element 291 Disc 0 584403
      , Element 292 Disc 1 586412
      , Element 293 Disc 2 588415
      , Element 294 Disc 0 590424
      , Element 295 Disc 1 592430
      , Element 296 Disc 2 594430
      , Element 297 Disc 0 596460
      , Element 298 Disc 1 598469
      , Element 299 Disc 2 600477
      ]
    }
  }
  { horizontalPosition = { leftEm = 4.5, widthEm = 11 }
  , operatorCode =
    [ "ops.flat_map("
    , "\xA0\xA0lambda n: \\"
    , "\xA0\xA0\xA0\xA0rx.concat("
    , "\xA0\xA0\xA0\xA0\xA0\xA0rx.just(n),"
    , "\xA0\xA0\xA0\xA0\xA0\xA0rx.just(n) >> \\"
    , "\xA0\xA0\xA0\xA0\xA0\xA0\xA0\xA0ops.delay(3)"
    , "\xA0\xA0)"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 15, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Square 0 11
      , Element 1 Square 1 2016
      , Element 0 Square 0 3023
      , Element 2 Square 2 4026
      , Element 1 Square 1 5022
      , Element 3 Square 0 6036
      , Element 2 Square 2 7031
      , Element 4 Square 1 8045
      , Element 3 Square 0 9045
      , Element 5 Square 2 10055
      , Element 4 Square 1 11054
      , Element 6 Square 0 12065
      , Element 5 Square 2 13061
      , Element 7 Square 1 14070
      , Element 6 Square 0 15071
      , Element 8 Square 2 16080
      , Element 7 Square 1 17079
      , Element 9 Square 0 18086
      , Element 8 Square 2 19089
      , Element 10 Square 1 20095
      , Element 9 Square 0 21095
      , Element 11 Square 2 22103
      , Element 10 Square 1 23103
      , Element 12 Square 0 24113
      , Element 11 Square 2 25111
      , Element 13 Square 1 26122
      , Element 12 Square 0 27123
      , Element 14 Square 2 28132
      , Element 13 Square 1 29131
      , Element 15 Square 0 30137
      , Element 14 Square 2 31140
      , Element 16 Square 1 32146
      , Element 15 Square 0 33146
      , Element 17 Square 2 34154
      , Element 16 Square 1 35158
      , Element 18 Square 0 36159
      , Element 17 Square 2 37165
      , Element 19 Square 1 38164
      , Element 18 Square 0 39165
      , Element 20 Square 2 40172
      , Element 19 Square 1 41174
      , Element 21 Square 0 42181
      , Element 20 Square 2 43182
      , Element 22 Square 1 44190
      , Element 21 Square 0 45189
      , Element 23 Square 2 46200
      , Element 22 Square 1 47201
      , Element 24 Square 0 48207
      , Element 23 Square 2 49207
      , Element 25 Square 1 50216
      , Element 24 Square 0 51217
      , Element 26 Square 2 52225
      , Element 25 Square 1 53226
      , Element 27 Square 0 54233
      , Element 26 Square 2 55235
      , Element 28 Square 1 56238
      , Element 27 Square 0 57242
      , Element 29 Square 2 58263
      , Element 28 Square 1 59248
      , Element 30 Square 0 60269
      , Element 29 Square 2 61274
      , Element 31 Square 1 62274
      , Element 30 Square 0 63278
      , Element 32 Square 2 64284
      , Element 31 Square 1 65282
      , Element 33 Square 0 66288
      , Element 32 Square 2 67288
      , Element 34 Square 1 68299
      , Element 33 Square 0 69298
      , Element 35 Square 2 70309
      , Element 34 Square 1 71309
      , Element 36 Square 0 72319
      , Element 35 Square 2 73319
      , Element 37 Square 1 74322
      , Element 36 Square 0 75328
      , Element 38 Square 2 76326
      , Element 37 Square 1 77329
      , Element 39 Square 0 78335
      , Element 38 Square 2 79333
      , Element 40 Square 1 80345
      , Element 39 Square 0 81343
      , Element 41 Square 2 82354
      , Element 40 Square 1 83353
      , Element 42 Square 0 84365
      , Element 41 Square 2 85364
      , Element 43 Square 1 86374
      , Element 42 Square 0 87377
      , Element 44 Square 2 88380
      , Element 43 Square 1 89384
      , Element 45 Square 0 90387
      , Element 44 Square 2 91389
      , Element 46 Square 1 92398
      , Element 45 Square 0 93398
      , Element 47 Square 2 94406
      , Element 46 Square 1 95408
      , Element 48 Square 0 96415
      , Element 47 Square 2 97409
      , Element 49 Square 1 98424
      , Element 48 Square 0 99425
      , Element 50 Square 2 100432
      , Element 49 Square 1 101429
      , Element 51 Square 0 102443
      , Element 50 Square 2 103444
      , Element 52 Square 1 104450
      , Element 51 Square 0 105448
      , Element 53 Square 2 106455
      , Element 52 Square 1 107451
      , Element 54 Square 0 108461
      , Element 53 Square 2 109466
      , Element 55 Square 1 110473
      , Element 54 Square 0 111469
      , Element 56 Square 2 112480
      , Element 55 Square 1 113479
      , Element 57 Square 0 114489
      , Element 56 Square 2 115489
      , Element 58 Square 1 116492
      , Element 57 Square 0 117497
      , Element 59 Square 2 118499
      , Element 58 Square 1 119502
      , Element 60 Square 0 120510
      , Element 59 Square 2 121503
      , Element 61 Square 1 122516
      , Element 60 Square 0 123517
      , Element 62 Square 2 124527
      , Element 61 Square 1 125526
      , Element 63 Square 0 126531
      , Element 62 Square 2 127534
      , Element 64 Square 1 128537
      , Element 63 Square 0 129540
      , Element 65 Square 2 130539
      , Element 64 Square 1 131544
      , Element 66 Square 0 132550
      , Element 65 Square 2 133546
      , Element 67 Square 1 134561
      , Element 66 Square 0 135558
      , Element 68 Square 2 136570
      , Element 67 Square 1 137578
      , Element 69 Square 0 138574
      , Element 68 Square 2 139577
      , Element 70 Square 1 140582
      , Element 69 Square 0 141588
      , Element 71 Square 2 142592
      , Element 70 Square 1 143592
      , Element 72 Square 0 144603
      , Element 71 Square 2 145601
      , Element 73 Square 1 146610
      , Element 72 Square 0 147609
      , Element 74 Square 2 148621
      , Element 73 Square 1 149621
      , Element 75 Square 0 150628
      , Element 74 Square 2 151629
      , Element 76 Square 1 152639
      , Element 75 Square 0 153636
      , Element 77 Square 2 154649
      , Element 76 Square 1 155645
      , Element 78 Square 0 156659
      , Element 77 Square 2 157656
      , Element 79 Square 1 158667
      , Element 78 Square 0 159668
      , Element 80 Square 2 160677
      , Element 79 Square 1 161678
      , Element 81 Square 0 162682
      , Element 80 Square 2 163683
      , Element 82 Square 1 164691
      , Element 81 Square 0 165689
      , Element 83 Square 2 166699
      , Element 82 Square 1 167696
      , Element 84 Square 0 168708
      , Element 83 Square 2 169705
      , Element 85 Square 1 170713
      , Element 84 Square 0 171717
      , Element 86 Square 2 172722
      , Element 85 Square 1 173722
      , Element 87 Square 0 174731
      , Element 86 Square 2 175730
      , Element 88 Square 1 176740
      , Element 87 Square 0 177735
      , Element 89 Square 2 178749
      , Element 88 Square 1 179749
      , Element 90 Square 0 180757
      , Element 89 Square 2 181751
      , Element 91 Square 1 182766
      , Element 90 Square 0 183766
      , Element 92 Square 2 184777
      , Element 91 Square 1 185777
      , Element 93 Square 0 186781
      , Element 92 Square 2 187787
      , Element 94 Square 1 188790
      , Element 93 Square 0 189786
      , Element 95 Square 2 190799
      , Element 94 Square 1 191801
      , Element 96 Square 0 192804
      , Element 95 Square 2 193810
      , Element 97 Square 1 194807
      , Element 96 Square 0 195811
      , Element 98 Square 2 196816
      , Element 97 Square 1 197815
      , Element 99 Square 0 198824
      , Element 98 Square 2 199824
      , Element 100 Square 1 200833
      , Element 99 Square 0 201835
      , Element 101 Square 2 202838
      , Element 100 Square 1 203839
      , Element 102 Square 0 204849
      , Element 101 Square 2 205849
      , Element 103 Square 1 206857
      , Element 102 Square 0 207851
      , Element 104 Square 2 208865
      , Element 103 Square 1 209867
      , Element 105 Square 0 210874
      , Element 104 Square 2 211875
      , Element 106 Square 1 212882
      , Element 105 Square 0 213885
      , Element 107 Square 2 214893
      , Element 106 Square 1 215887
      , Element 108 Square 0 216901
      , Element 107 Square 2 217897
      , Element 109 Square 1 218909
      , Element 108 Square 0 219906
      , Element 110 Square 2 220919
      , Element 109 Square 1 221919
      , Element 111 Square 0 222927
      , Element 110 Square 2 223926
      , Element 112 Square 1 224934
      , Element 111 Square 0 225936
      , Element 113 Square 2 226941
      , Element 112 Square 1 227944
      , Element 114 Square 0 228952
      , Element 113 Square 2 229947
      , Element 115 Square 1 230960
      , Element 114 Square 0 231959
      , Element 116 Square 2 232968
      , Element 115 Square 1 233968
      , Element 117 Square 0 234978
      , Element 116 Square 2 235985
      , Element 118 Square 1 236988
      , Element 117 Square 0 237987
      , Element 119 Square 2 238996
      , Element 118 Square 1 239996
      , Element 120 Square 0 241006
      , Element 119 Square 2 242003
      , Element 121 Square 1 243017
      , Element 120 Square 0 244012
      , Element 122 Square 2 245028
      , Element 121 Square 1 246027
      , Element 123 Square 0 247033
      , Element 122 Square 2 248036
      , Element 124 Square 1 249043
      , Element 123 Square 0 250041
      , Element 125 Square 2 251052
      , Element 124 Square 1 252053
      , Element 126 Square 0 253061
      , Element 125 Square 2 254060
      , Element 127 Square 1 255069
      , Element 126 Square 0 256071
      , Element 128 Square 2 257078
      , Element 127 Square 1 258080
      , Element 129 Square 0 259089
      , Element 128 Square 2 260089
      , Element 130 Square 1 261096
      , Element 129 Square 0 262099
      , Element 131 Square 2 263102
      , Element 130 Square 1 264106
      , Element 132 Square 0 265107
      , Element 131 Square 2 266108
      , Element 133 Square 1 267115
      , Element 132 Square 0 268117
      , Element 134 Square 2 269123
      , Element 133 Square 1 270122
      , Element 135 Square 0 271130
      , Element 134 Square 2 272133
      , Element 136 Square 1 273141
      , Element 135 Square 0 274138
      , Element 137 Square 2 275145
      , Element 136 Square 1 276151
      , Element 138 Square 0 277156
      , Element 137 Square 2 278153
      , Element 139 Square 1 279165
      , Element 138 Square 0 280163
      , Element 140 Square 2 281174
      , Element 139 Square 1 282174
      , Element 141 Square 0 283181
      , Element 140 Square 2 284184
      , Element 142 Square 1 285187
      , Element 141 Square 0 286191
      , Element 143 Square 2 287196
      , Element 142 Square 1 288197
      , Element 144 Square 0 289206
      , Element 143 Square 2 290204
      , Element 145 Square 1 291215
      , Element 144 Square 0 292218
      , Element 146 Square 2 293223
      , Element 145 Square 1 294219
      , Element 147 Square 0 295233
      , Element 146 Square 2 296227
      , Element 148 Square 1 297243
      , Element 147 Square 0 298242
      , Element 149 Square 2 299253
      , Element 148 Square 1 300250
      , Element 150 Square 0 301263
      , Element 149 Square 2 302263
      , Element 151 Square 1 303273
      , Element 150 Square 0 304274
      , Element 152 Square 2 305279
      , Element 151 Square 1 306283
      , Element 153 Square 0 307286
      , Element 152 Square 2 308284
      , Element 154 Square 1 309295
      , Element 153 Square 0 310296
      , Element 155 Square 2 311305
      , Element 154 Square 1 312301
      , Element 156 Square 0 313316
      , Element 155 Square 2 314313
      , Element 157 Square 1 315324
      , Element 156 Square 0 316326
      , Element 158 Square 2 317334
      , Element 157 Square 1 318334
      , Element 159 Square 0 319341
      , Element 158 Square 2 320340
      , Element 160 Square 1 321351
      , Element 159 Square 0 322349
      , Element 161 Square 2 323369
      , Element 160 Square 1 324367
      , Element 162 Square 0 325377
      , Element 161 Square 2 326383
      , Element 163 Square 1 327379
      , Element 162 Square 0 328383
      , Element 164 Square 2 329387
      , Element 163 Square 1 330386
      , Element 165 Square 0 331391
      , Element 164 Square 2 332389
      , Element 166 Square 1 333397
      , Element 165 Square 0 334397
      , Element 167 Square 2 335405
      , Element 166 Square 1 336404
      , Element 168 Square 0 337415
      , Element 167 Square 2 338416
      , Element 169 Square 1 339425
      , Element 168 Square 0 340422
      , Element 170 Square 2 341434
      , Element 169 Square 1 342436
      , Element 171 Square 0 343440
      , Element 170 Square 2 344442
      , Element 172 Square 1 345447
      , Element 171 Square 0 346449
      , Element 173 Square 2 347457
      , Element 172 Square 1 348455
      , Element 174 Square 0 349465
      , Element 173 Square 2 350463
      , Element 175 Square 1 351473
      , Element 174 Square 0 352473
      , Element 176 Square 2 353481
      , Element 175 Square 1 354481
      , Element 177 Square 0 355491
      , Element 176 Square 2 356489
      , Element 178 Square 1 357500
      , Element 177 Square 0 358497
      , Element 179 Square 2 359509
      , Element 178 Square 1 360509
      , Element 180 Square 0 361514
      , Element 179 Square 2 362518
      , Element 181 Square 1 363518
      , Element 180 Square 0 364523
      , Element 182 Square 2 365528
      , Element 181 Square 1 366527
      , Element 183 Square 0 367537
      , Element 182 Square 2 368534
      , Element 184 Square 1 369540
      , Element 183 Square 0 370546
      , Element 185 Square 2 371549
      , Element 184 Square 1 372550
      , Element 186 Square 0 373555
      , Element 185 Square 2 374558
      , Element 187 Square 1 375566
      , Element 186 Square 0 376563
      , Element 188 Square 2 377575
      , Element 187 Square 1 378575
      , Element 189 Square 0 379585
      , Element 188 Square 2 380580
      , Element 190 Square 1 381593
      , Element 189 Square 0 382594
      , Element 191 Square 2 383598
      , Element 190 Square 1 384600
      , Element 192 Square 0 385601
      , Element 191 Square 2 386601
      , Element 193 Square 1 387607
      , Element 192 Square 0 388612
      , Element 194 Square 2 389614
      , Element 193 Square 1 390616
      , Element 195 Square 0 391621
      , Element 194 Square 2 392617
      , Element 196 Square 1 393630
      , Element 195 Square 0 394629
      , Element 197 Square 2 395640
      , Element 196 Square 1 396637
      , Element 198 Square 0 397649
      , Element 197 Square 2 398651
      , Element 199 Square 1 399653
      , Element 198 Square 0 400650
      , Element 200 Square 2 401663
      , Element 199 Square 1 402661
      , Element 201 Square 0 403672
      , Element 200 Square 2 404672
      , Element 202 Square 1 405682
      , Element 201 Square 0 406678
      , Element 203 Square 2 407684
      , Element 202 Square 1 408690
      , Element 204 Square 0 409688
      , Element 203 Square 2 410691
      , Element 205 Square 1 411697
      , Element 204 Square 0 412697
      , Element 206 Square 2 413706
      , Element 205 Square 1 414701
      , Element 207 Square 0 415715
      , Element 206 Square 2 416713
      , Element 208 Square 1 417724
      , Element 207 Square 0 418723
      , Element 209 Square 2 419735
      , Element 208 Square 1 420732
      , Element 210 Square 0 421739
      , Element 209 Square 2 422739
      , Element 211 Square 1 423747
      , Element 210 Square 0 424747
      , Element 212 Square 2 425756
      , Element 211 Square 1 426755
      , Element 213 Square 0 427764
      , Element 212 Square 2 428759
      , Element 214 Square 1 429774
      , Element 213 Square 0 430772
      , Element 215 Square 2 431784
      , Element 214 Square 1 432784
      , Element 216 Square 0 433791
      , Element 215 Square 2 434794
      , Element 217 Square 1 435800
      , Element 216 Square 0 436801
      , Element 218 Square 2 437810
      , Element 217 Square 1 438808
      , Element 219 Square 0 439820
      , Element 218 Square 2 440818
      , Element 220 Square 1 441827
      , Element 219 Square 0 442829
      , Element 221 Square 2 443850
      , Element 220 Square 1 444835
      , Element 222 Square 0 445848
      , Element 221 Square 2 446864
      , Element 223 Square 1 447857
      , Element 222 Square 0 448858
      , Element 224 Square 2 449862
      , Element 223 Square 1 450860
      , Element 225 Square 0 451863
      , Element 224 Square 2 452872
      , Element 226 Square 1 453872
      , Element 225 Square 0 454873
      , Element 227 Square 2 455875
      , Element 226 Square 1 456881
      , Element 228 Square 0 457880
      , Element 227 Square 2 458884
      , Element 229 Square 1 459890
      , Element 228 Square 0 460889
      , Element 230 Square 2 461901
      , Element 229 Square 1 462899
      , Element 231 Square 0 463910
      , Element 230 Square 2 464912
      , Element 232 Square 1 465912
      , Element 231 Square 0 466919
      , Element 233 Square 2 467918
      , Element 232 Square 1 468923
      , Element 234 Square 0 469929
      , Element 233 Square 2 470928
      , Element 235 Square 1 471939
      , Element 234 Square 0 472936
      , Element 236 Square 2 473949
      , Element 235 Square 1 474943
      , Element 237 Square 0 475957
      , Element 236 Square 2 476958
      , Element 238 Square 1 477968
      , Element 237 Square 0 478968
      , Element 239 Square 2 479974
      , Element 238 Square 1 480978
      , Element 240 Square 0 481982
      , Element 239 Square 2 482978
      , Element 241 Square 1 483990
      , Element 240 Square 0 484993
      , Element 242 Square 2 486000
      , Element 241 Square 1 486999
      , Element 243 Square 0 488011
      , Element 242 Square 2 489011
      , Element 244 Square 1 490023
      , Element 243 Square 0 491019
      , Element 245 Square 2 492030
      , Element 244 Square 1 493025
      , Element 246 Square 0 494040
      , Element 245 Square 2 495037
      , Element 247 Square 1 496050
      , Element 246 Square 0 497048
      , Element 248 Square 2 498060
      , Element 247 Square 1 499058
      , Element 249 Square 0 500068
      , Element 248 Square 2 501069
      , Element 250 Square 1 502075
      , Element 249 Square 0 503075
      , Element 251 Square 2 504078
      , Element 250 Square 1 505085
      , Element 252 Square 0 506087
      , Element 251 Square 2 507086
      , Element 253 Square 1 508096
      , Element 252 Square 0 509098
      , Element 254 Square 2 510106
      , Element 253 Square 1 511105
      , Element 255 Square 0 512110
      , Element 254 Square 2 513109
      , Element 256 Square 1 514121
      , Element 255 Square 0 515119
      , Element 257 Square 2 516131
      , Element 256 Square 1 517129
      , Element 258 Square 0 518141
      , Element 257 Square 2 519140
      , Element 259 Square 1 520151
      , Element 258 Square 0 521147
      , Element 260 Square 2 522160
      , Element 259 Square 1 523161
      , Element 261 Square 0 524165
      , Element 260 Square 2 525168
      , Element 262 Square 1 526173
      , Element 261 Square 0 527173
      , Element 263 Square 2 528182
      , Element 262 Square 1 529180
      , Element 264 Square 0 530192
      , Element 263 Square 2 531190
      , Element 265 Square 1 532201
      , Element 264 Square 0 533201
      , Element 266 Square 2 534208
      , Element 265 Square 1 535209
      , Element 267 Square 0 536217
      , Element 266 Square 2 537216
      , Element 268 Square 1 538228
      , Element 267 Square 0 539223
      , Element 269 Square 2 540240
      , Element 268 Square 1 541234
      , Element 270 Square 0 542249
      , Element 269 Square 2 543249
      , Element 271 Square 1 544256
      , Element 270 Square 0 545257
      , Element 272 Square 2 546265
      , Element 271 Square 1 547265
      , Element 273 Square 0 548273
      , Element 272 Square 2 549275
      , Element 274 Square 1 550279
      , Element 273 Square 0 551279
      , Element 275 Square 2 552287
      , Element 274 Square 1 553285
      , Element 276 Square 0 554296
      , Element 275 Square 2 555292
      , Element 277 Square 1 556301
      , Element 276 Square 0 557306
      , Element 278 Square 2 558312
      , Element 277 Square 1 559310
      , Element 279 Square 0 560320
      , Element 278 Square 2 561319
      , Element 280 Square 1 562329
      , Element 279 Square 0 563327
      , Element 281 Square 2 564340
      , Element 280 Square 1 565337
      , Element 282 Square 0 566346
      , Element 281 Square 2 567349
      , Element 283 Square 1 568351
      , Element 282 Square 0 569357
      , Element 284 Square 2 570360
      , Element 283 Square 1 571359
      , Element 285 Square 0 572368
      , Element 284 Square 2 573370
      , Element 286 Square 1 574376
      , Element 285 Square 0 575379
      , Element 287 Square 2 576386
      , Element 286 Square 1 577385
      , Element 288 Square 0 578387
      , Element 287 Square 2 579396
      , Element 289 Square 1 580392
      , Element 288 Square 0 581395
      , Element 290 Square 2 582398
      , Element 289 Square 1 583399
      , Element 291 Square 0 584404
      , Element 290 Square 2 585405
      , Element 292 Square 1 586413
      , Element 291 Square 0 587414
      , Element 293 Square 2 588416
      , Element 292 Square 1 589423
      , Element 294 Square 0 590424
      , Element 293 Square 2 591424
      , Element 295 Square 1 592430
      , Element 294 Square 0 593428
      , Element 296 Square 2 594430
      , Element 295 Square 1 595436
      , Element 297 Square 0 596460
      , Element 296 Square 2 597440
      , Element 298 Square 1 598469
      , Element 297 Square 0 599469
      , Element 299 Square 2 600478
      , Element 298 Square 1 601479
      , Element 299 Square 2 603486
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
mapped: rx.Observable[int] = numbers >> ops.flat_map(
    lambda n: rx.concat(
        rx.just(n),
        rx.just(n) >> ops.delay(3)
    )
)
mapped.run()
""" showCode


operatorFlatMapConcat : Bool -> Bool -> UnindexedSlideModel
operatorFlatMapConcat showCode animate =
  operator "concat_map: Map to Observables, flatten sequentially"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.concat_map(...)"
      , text " accepts a function that transforms elements into Observables, applying it to each element, and returns an Observable with the resultant Observables flattened, "
      , i [] [ text "sequentially" ]
      , text "."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "If the input is empty, the output too must be empty" ]
        , li [] [ text "Output type can be anything (determined by transformation function)" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 1.5, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 0
      , Element 1 Disc 1 5017
      , Element 2 Disc 2 10037
      , Element 3 Disc 0 15057
      , Element 4 Disc 1 20070
      , Element 5 Disc 2 25093
      , Element 6 Disc 0 30104
      , Element 7 Disc 1 35124
      , Element 8 Disc 2 40141
      , Element 9 Disc 0 45156
      , Element 10 Disc 1 50172
      , Element 11 Disc 2 55192
      , Element 12 Disc 0 60209
      , Element 13 Disc 1 65222
      , Element 14 Disc 2 70234
      , Element 15 Disc 0 75251
      , Element 16 Disc 1 80268
      , Element 17 Disc 2 85283
      , Element 18 Disc 0 90297
      , Element 19 Disc 1 95310
      , Element 20 Disc 2 100320
      , Element 21 Disc 0 105333
      , Element 22 Disc 1 110351
      , Element 23 Disc 2 115365
      , Element 24 Disc 0 120382
      , Element 25 Disc 1 125397
      , Element 26 Disc 2 130415
      , Element 27 Disc 0 135430
      , Element 28 Disc 1 140444
      , Element 29 Disc 2 145458
      , Element 30 Disc 0 150476
      , Element 31 Disc 1 155490
      , Element 32 Disc 2 160503
      , Element 33 Disc 0 165520
      , Element 34 Disc 1 170533
      , Element 35 Disc 2 175551
      , Element 36 Disc 0 180570
      , Element 37 Disc 1 185587
      , Element 38 Disc 2 190604
      , Element 39 Disc 0 195621
      , Element 40 Disc 1 200633
      , Element 41 Disc 2 205647
      , Element 42 Disc 0 210668
      , Element 43 Disc 1 215686
      , Element 44 Disc 2 220704
      , Element 45 Disc 0 225722
      , Element 46 Disc 1 230740
      , Element 47 Disc 2 235759
      , Element 48 Disc 0 240773
      , Element 49 Disc 1 245784
      , Element 50 Disc 2 250798
      , Element 51 Disc 0 255814
      , Element 52 Disc 1 260827
      , Element 53 Disc 2 265842
      , Element 54 Disc 0 270859
      , Element 55 Disc 1 275873
      , Element 56 Disc 2 280892
      , Element 57 Disc 0 285905
      , Element 58 Disc 1 290923
      , Element 59 Disc 2 295940
      , Element 60 Disc 0 300958
      , Element 61 Disc 1 305974
      , Element 62 Disc 2 310990
      , Element 63 Disc 0 316004
      , Element 64 Disc 1 321024
      , Element 65 Disc 2 326039
      , Element 66 Disc 0 331053
      , Element 67 Disc 1 336069
      , Element 68 Disc 2 341081
      , Element 69 Disc 0 346101
      , Element 70 Disc 1 351119
      , Element 71 Disc 2 356140
      , Element 72 Disc 0 361157
      , Element 73 Disc 1 366173
      , Element 74 Disc 2 371190
      , Element 75 Disc 0 376209
      , Element 76 Disc 1 381217
      , Element 77 Disc 2 386235
      , Element 78 Disc 0 391250
      , Element 79 Disc 1 396267
      , Element 80 Disc 2 401282
      , Element 81 Disc 0 406293
      , Element 82 Disc 1 411325
      , Element 83 Disc 2 416344
      , Element 84 Disc 0 421363
      , Element 85 Disc 1 426381
      , Element 86 Disc 2 431396
      , Element 87 Disc 0 436414
      , Element 88 Disc 1 441432
      , Element 89 Disc 2 446446
      , Element 90 Disc 0 451465
      , Element 91 Disc 1 456481
      , Element 92 Disc 2 461494
      , Element 93 Disc 0 466509
      , Element 94 Disc 1 471521
      , Element 95 Disc 2 476537
      , Element 96 Disc 0 481550
      , Element 97 Disc 1 486568
      , Element 98 Disc 2 491586
      , Element 99 Disc 0 496603
      , Element 100 Disc 1 501614
      , Element 101 Disc 2 506633
      , Element 102 Disc 0 511649
      , Element 103 Disc 1 516666
      , Element 104 Disc 2 521683
      , Element 105 Disc 0 526692
      , Element 106 Disc 1 531711
      , Element 107 Disc 2 536729
      , Element 108 Disc 0 541736
      , Element 109 Disc 1 546752
      , Element 110 Disc 2 551770
      , Element 111 Disc 0 556788
      , Element 112 Disc 1 561803
      , Element 113 Disc 2 566818
      , Element 114 Disc 0 571836
      , Element 115 Disc 1 576847
      , Element 116 Disc 2 581856
      , Element 117 Disc 0 586874
      , Element 118 Disc 1 591889
      , Element 119 Disc 2 596904
      , Element 120 Disc 0 601935
      , Element 121 Disc 1 606953
      , Element 122 Disc 2 611963
      , Element 123 Disc 0 616973
      , Element 124 Disc 1 621984
      , Element 125 Disc 2 627004
      , Element 126 Disc 0 632018
      , Element 127 Disc 1 637032
      , Element 128 Disc 2 642047
      , Element 129 Disc 0 647063
      , Element 130 Disc 1 652079
      , Element 131 Disc 2 657097
      , Element 132 Disc 0 662115
      , Element 133 Disc 1 667129
      , Element 134 Disc 2 672141
      , Element 135 Disc 0 677153
      , Element 136 Disc 1 682168
      , Element 137 Disc 2 687180
      , Element 138 Disc 0 692195
      , Element 139 Disc 1 697211
      , Element 140 Disc 2 702229
      , Element 141 Disc 0 707241
      , Element 142 Disc 1 712253
      , Element 143 Disc 2 717270
      , Element 144 Disc 0 722289
      , Element 145 Disc 1 727304
      , Element 146 Disc 2 732324
      , Element 147 Disc 0 737341
      , Element 148 Disc 1 742356
      , Element 149 Disc 2 747376
      , Element 150 Disc 0 752395
      , Element 151 Disc 1 757415
      , Element 152 Disc 2 762433
      , Element 153 Disc 0 767454
      , Element 154 Disc 1 772466
      , Element 155 Disc 2 777494
      , Element 156 Disc 0 782513
      , Element 157 Disc 1 787528
      , Element 158 Disc 2 792547
      , Element 159 Disc 0 797555
      , Element 160 Disc 1 802575
      , Element 161 Disc 2 807587
      , Element 162 Disc 0 812600
      , Element 163 Disc 1 817613
      , Element 164 Disc 2 822628
      , Element 165 Disc 0 827644
      , Element 166 Disc 1 832662
      , Element 167 Disc 2 837674
      , Element 168 Disc 0 842689
      , Element 169 Disc 1 847697
      , Element 170 Disc 2 852712
      , Element 171 Disc 0 857731
      , Element 172 Disc 1 862748
      , Element 173 Disc 2 867765
      , Element 174 Disc 0 872771
      , Element 175 Disc 1 877789
      , Element 176 Disc 2 882802
      , Element 177 Disc 0 887821
      , Element 178 Disc 1 892840
      , Element 179 Disc 2 897852
      , Element 180 Disc 0 902864
      , Element 181 Disc 1 907880
      , Element 182 Disc 2 912898
      , Element 183 Disc 0 917913
      , Element 184 Disc 1 922923
      , Element 185 Disc 2 927942
      , Element 186 Disc 0 932962
      , Element 187 Disc 1 937980
      , Element 188 Disc 2 942996
      , Element 189 Disc 0 948012
      , Element 190 Disc 1 953026
      , Element 191 Disc 2 958042
      , Element 192 Disc 0 963055
      , Element 193 Disc 1 968074
      , Element 194 Disc 2 973092
      , Element 195 Disc 0 978109
      , Element 196 Disc 1 983124
      , Element 197 Disc 2 988140
      , Element 198 Disc 0 993154
      , Element 199 Disc 1 998172
      , Element 200 Disc 2 1003188
      , Element 201 Disc 0 1008205
      , Element 202 Disc 1 1013214
      , Element 203 Disc 2 1018232
      , Element 204 Disc 0 1023250
      , Element 205 Disc 1 1028266
      , Element 206 Disc 2 1033280
      , Element 207 Disc 0 1038295
      , Element 208 Disc 1 1043309
      , Element 209 Disc 2 1048327
      , Element 210 Disc 0 1053343
      , Element 211 Disc 1 1058360
      , Element 212 Disc 2 1063373
      , Element 213 Disc 0 1068390
      , Element 214 Disc 1 1073405
      , Element 215 Disc 2 1078422
      , Element 216 Disc 0 1083441
      , Element 217 Disc 1 1088458
      , Element 218 Disc 2 1093476
      , Element 219 Disc 0 1098487
      , Element 220 Disc 1 1103501
      , Element 221 Disc 2 1108518
      , Element 222 Disc 0 1113532
      , Element 223 Disc 1 1118550
      , Element 224 Disc 2 1123563
      , Element 225 Disc 0 1128579
      , Element 226 Disc 1 1133594
      , Element 227 Disc 2 1138605
      , Element 228 Disc 0 1143618
      , Element 229 Disc 1 1148629
      , Element 230 Disc 2 1153640
      , Element 231 Disc 0 1158659
      , Element 232 Disc 1 1163676
      , Element 233 Disc 2 1168688
      , Element 234 Disc 0 1173707
      , Element 235 Disc 1 1178723
      , Element 236 Disc 2 1183739
      , Element 237 Disc 0 1188751
      , Element 238 Disc 1 1193766
      , Element 239 Disc 2 1198781
      , Element 240 Disc 0 1203791
      , Element 241 Disc 1 1208805
      , Element 242 Disc 2 1213818
      , Element 243 Disc 0 1218835
      , Element 244 Disc 1 1223848
      , Element 245 Disc 2 1228861
      , Element 246 Disc 0 1233878
      , Element 247 Disc 1 1238893
      , Element 248 Disc 2 1243907
      , Element 249 Disc 0 1248916
      , Element 250 Disc 1 1253937
      , Element 251 Disc 2 1258953
      , Element 252 Disc 0 1263967
      , Element 253 Disc 1 1268985
      , Element 254 Disc 2 1274003
      , Element 255 Disc 0 1279018
      , Element 256 Disc 1 1284036
      , Element 257 Disc 2 1289049
      , Element 258 Disc 0 1294068
      , Element 259 Disc 1 1299086
      , Element 260 Disc 2 1304104
      , Element 261 Disc 0 1309123
      , Element 262 Disc 1 1314142
      , Element 263 Disc 2 1319160
      , Element 264 Disc 0 1324181
      , Element 265 Disc 1 1329190
      , Element 266 Disc 2 1334203
      , Element 267 Disc 0 1339219
      , Element 268 Disc 1 1344228
      , Element 269 Disc 2 1349243
      , Element 270 Disc 0 1354268
      , Element 271 Disc 1 1359288
      , Element 272 Disc 2 1364300
      , Element 273 Disc 0 1369315
      , Element 274 Disc 1 1374336
      , Element 275 Disc 2 1379350
      , Element 276 Disc 0 1384363
      , Element 277 Disc 1 1389379
      , Element 278 Disc 2 1394395
      , Element 279 Disc 0 1399412
      , Element 280 Disc 1 1404430
      , Element 281 Disc 2 1409446
      , Element 282 Disc 0 1414463
      , Element 283 Disc 1 1419482
      , Element 284 Disc 2 1424500
      , Element 285 Disc 0 1429514
      , Element 286 Disc 1 1434533
      , Element 287 Disc 2 1439543
      , Element 288 Disc 0 1444556
      , Element 289 Disc 1 1449572
      , Element 290 Disc 2 1454589
      , Element 291 Disc 0 1459612
      , Element 292 Disc 1 1464631
      , Element 293 Disc 2 1469647
      , Element 294 Disc 0 1474663
      , Element 295 Disc 1 1479680
      , Element 296 Disc 2 1484691
      , Element 297 Disc 0 1489705
      , Element 298 Disc 1 1494722
      , Element 299 Disc 2 1499730
      ]
    }
  }
  { horizontalPosition = { leftEm = 4.5, widthEm = 10 }
  , operatorCode =
    [ "ops.concat_map("
    , "\xA0\xA0lambda n: \\"
    , "\xA0\xA0\xA0\xA0rx.concat("
    , "\xA0\xA0\xA0\xA0\xA0\xA0rx.just(n),"
    , "\xA0\xA0\xA0\xA0\xA0\xA0rx.just(n) >> \\"
    , "\xA0\xA0\xA0\xA0\xA0\xA0\xA0\xA0ops.delay(3)"
    , "\xA0\xA0)"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 15, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Square 0 5
      , Element 0 Square 0 3008
      , Element 1 Square 1 5017
      , Element 1 Square 1 8026
      , Element 2 Square 2 10037
      , Element 2 Square 2 13050
      , Element 3 Square 0 15058
      , Element 3 Square 0 18061
      , Element 4 Square 1 20071
      , Element 4 Square 1 23083
      , Element 5 Square 2 25093
      , Element 5 Square 2 28096
      , Element 6 Square 0 30104
      , Element 6 Square 0 33114
      , Element 7 Square 1 35124
      , Element 7 Square 1 38133
      , Element 8 Square 2 40141
      , Element 8 Square 2 43147
      , Element 9 Square 0 45156
      , Element 9 Square 0 48165
      , Element 10 Square 1 50172
      , Element 10 Square 1 53183
      , Element 11 Square 2 55192
      , Element 11 Square 2 58200
      , Element 12 Square 0 60209
      , Element 12 Square 0 63218
      , Element 13 Square 1 65222
      , Element 13 Square 1 68230
      , Element 14 Square 2 70235
      , Element 14 Square 2 73245
      , Element 15 Square 0 75251
      , Element 15 Square 0 78259
      , Element 16 Square 1 80268
      , Element 16 Square 1 83276
      , Element 17 Square 2 85283
      , Element 17 Square 2 88290
      , Element 18 Square 0 90298
      , Element 18 Square 0 93301
      , Element 19 Square 1 95310
      , Element 19 Square 1 98316
      , Element 20 Square 2 100320
      , Element 20 Square 2 103324
      , Element 21 Square 0 105333
      , Element 21 Square 0 108343
      , Element 22 Square 1 110351
      , Element 22 Square 1 113356
      , Element 23 Square 2 115365
      , Element 23 Square 2 118374
      , Element 24 Square 0 120382
      , Element 24 Square 0 123388
      , Element 25 Square 1 125397
      , Element 25 Square 1 128405
      , Element 26 Square 2 130415
      , Element 26 Square 2 133423
      , Element 27 Square 0 135430
      , Element 27 Square 0 138438
      , Element 28 Square 1 140444
      , Element 28 Square 1 143452
      , Element 29 Square 2 145459
      , Element 29 Square 2 148466
      , Element 30 Square 0 150476
      , Element 30 Square 0 153485
      , Element 31 Square 1 155490
      , Element 31 Square 1 158497
      , Element 32 Square 2 160503
      , Element 32 Square 2 163512
      , Element 33 Square 0 165520
      , Element 33 Square 0 168526
      , Element 34 Square 1 170533
      , Element 34 Square 1 173544
      , Element 35 Square 2 175551
      , Element 35 Square 2 178560
      , Element 36 Square 0 180570
      , Element 36 Square 0 183579
      , Element 37 Square 1 185587
      , Element 37 Square 1 188596
      , Element 38 Square 2 190604
      , Element 38 Square 2 193613
      , Element 39 Square 0 195621
      , Element 39 Square 0 198629
      , Element 40 Square 1 200633
      , Element 40 Square 1 203642
      , Element 41 Square 2 205648
      , Element 41 Square 2 208658
      , Element 42 Square 0 210668
      , Element 42 Square 0 213677
      , Element 43 Square 1 215686
      , Element 43 Square 1 218694
      , Element 44 Square 2 220705
      , Element 44 Square 2 223714
      , Element 45 Square 0 225722
      , Element 45 Square 0 228732
      , Element 46 Square 1 230741
      , Element 46 Square 1 233750
      , Element 47 Square 2 235759
      , Element 47 Square 2 238768
      , Element 48 Square 0 240773
      , Element 48 Square 0 243780
      , Element 49 Square 1 245784
      , Element 49 Square 1 248794
      , Element 50 Square 2 250799
      , Element 50 Square 2 253806
      , Element 51 Square 0 255814
      , Element 51 Square 0 258823
      , Element 52 Square 1 260827
      , Element 52 Square 1 263835
      , Element 53 Square 2 265842
      , Element 53 Square 2 268850
      , Element 54 Square 0 270859
      , Element 54 Square 0 273863
      , Element 55 Square 1 275874
      , Element 55 Square 1 278884
      , Element 56 Square 2 280892
      , Element 56 Square 2 283902
      , Element 57 Square 0 285905
      , Element 57 Square 0 288915
      , Element 58 Square 1 290923
      , Element 58 Square 1 293931
      , Element 59 Square 2 295940
      , Element 59 Square 2 298949
      , Element 60 Square 0 300959
      , Element 60 Square 0 303965
      , Element 61 Square 1 305974
      , Element 61 Square 1 308982
      , Element 62 Square 2 310990
      , Element 62 Square 2 313996
      , Element 63 Square 0 316004
      , Element 63 Square 0 319014
      , Element 64 Square 1 321024
      , Element 64 Square 1 324033
      , Element 65 Square 2 326039
      , Element 65 Square 2 329047
      , Element 66 Square 0 331053
      , Element 66 Square 0 334059
      , Element 67 Square 1 336069
      , Element 67 Square 1 339073
      , Element 68 Square 2 341081
      , Element 68 Square 2 344091
      , Element 69 Square 0 346101
      , Element 69 Square 0 349110
      , Element 70 Square 1 351119
      , Element 70 Square 1 354129
      , Element 71 Square 2 356140
      , Element 71 Square 2 359149
      , Element 72 Square 0 361157
      , Element 72 Square 0 364165
      , Element 73 Square 1 366174
      , Element 73 Square 1 369182
      , Element 74 Square 2 371191
      , Element 74 Square 2 374200
      , Element 75 Square 0 376209
      , Element 75 Square 0 379216
      , Element 76 Square 1 381217
      , Element 76 Square 1 384227
      , Element 77 Square 2 386235
      , Element 77 Square 2 389246
      , Element 78 Square 0 391251
      , Element 78 Square 0 394258
      , Element 79 Square 1 396267
      , Element 79 Square 1 399277
      , Element 80 Square 2 401282
      , Element 80 Square 2 404288
      , Element 81 Square 0 406293
      , Element 81 Square 0 409315
      , Element 82 Square 1 411326
      , Element 82 Square 1 414336
      , Element 83 Square 2 416344
      , Element 83 Square 2 419353
      , Element 84 Square 0 421363
      , Element 84 Square 0 424371
      , Element 85 Square 1 426381
      , Element 85 Square 1 429388
      , Element 86 Square 2 431396
      , Element 86 Square 2 434406
      , Element 87 Square 0 436414
      , Element 87 Square 0 439424
      , Element 88 Square 1 441432
      , Element 88 Square 1 444439
      , Element 89 Square 2 446446
      , Element 89 Square 2 449456
      , Element 90 Square 0 451465
      , Element 90 Square 0 454475
      , Element 91 Square 1 456481
      , Element 91 Square 1 459484
      , Element 92 Square 2 461494
      , Element 92 Square 2 464503
      , Element 93 Square 0 466509
      , Element 93 Square 0 469515
      , Element 94 Square 1 471521
      , Element 94 Square 1 474528
      , Element 95 Square 2 476537
      , Element 95 Square 2 479543
      , Element 96 Square 0 481550
      , Element 96 Square 0 484559
      , Element 97 Square 1 486568
      , Element 97 Square 1 489576
      , Element 98 Square 2 491586
      , Element 98 Square 2 494594
      , Element 99 Square 0 496603
      , Element 99 Square 0 499607
      , Element 100 Square 1 501614
      , Element 100 Square 1 504623
      , Element 101 Square 2 506633
      , Element 101 Square 2 509643
      , Element 102 Square 0 511649
      , Element 102 Square 0 514657
      , Element 103 Square 1 516666
      , Element 103 Square 1 519675
      , Element 104 Square 2 521683
      , Element 104 Square 2 524687
      , Element 105 Square 0 526692
      , Element 105 Square 0 529700
      , Element 106 Square 1 531711
      , Element 106 Square 1 534720
      , Element 107 Square 2 536729
      , Element 107 Square 2 539733
      , Element 108 Square 0 541737
      , Element 108 Square 0 544744
      , Element 109 Square 1 546752
      , Element 109 Square 1 549761
      , Element 110 Square 2 551771
      , Element 110 Square 2 554779
      , Element 111 Square 0 556788
      , Element 111 Square 0 559796
      , Element 112 Square 1 561803
      , Element 112 Square 1 564812
      , Element 113 Square 2 566818
      , Element 113 Square 2 569826
      , Element 114 Square 0 571836
      , Element 114 Square 0 574838
      , Element 115 Square 1 576847
      , Element 115 Square 1 579851
      , Element 116 Square 2 581856
      , Element 116 Square 2 584864
      , Element 117 Square 0 586874
      , Element 117 Square 0 589883
      , Element 118 Square 1 591890
      , Element 118 Square 1 594896
      , Element 119 Square 2 596904
      , Element 119 Square 2 599914
      , Element 120 Square 0 601935
      , Element 120 Square 0 604944
      , Element 121 Square 1 606953
      , Element 121 Square 1 609958
      , Element 122 Square 2 611963
      , Element 122 Square 2 614969
      , Element 123 Square 0 616973
      , Element 123 Square 0 619983
      , Element 124 Square 1 621984
      , Element 124 Square 1 624994
      , Element 125 Square 2 627004
      , Element 125 Square 2 630011
      , Element 126 Square 0 632018
      , Element 126 Square 0 635028
      , Element 127 Square 1 637033
      , Element 127 Square 1 640040
      , Element 128 Square 2 642048
      , Element 128 Square 2 645055
      , Element 129 Square 0 647063
      , Element 129 Square 0 650070
      , Element 130 Square 1 652079
      , Element 130 Square 1 655087
      , Element 131 Square 2 657097
      , Element 131 Square 2 660107
      , Element 132 Square 0 662116
      , Element 132 Square 0 665124
      , Element 133 Square 1 667129
      , Element 133 Square 1 670137
      , Element 134 Square 2 672141
      , Element 134 Square 2 675147
      , Element 135 Square 0 677153
      , Element 135 Square 0 680161
      , Element 136 Square 1 682168
      , Element 136 Square 1 685173
      , Element 137 Square 2 687180
      , Element 137 Square 2 690187
      , Element 138 Square 0 692195
      , Element 138 Square 0 695204
      , Element 139 Square 1 697211
      , Element 139 Square 1 700219
      , Element 140 Square 2 702229
      , Element 140 Square 2 705235
      , Element 141 Square 0 707241
      , Element 141 Square 0 710250
      , Element 142 Square 1 712253
      , Element 142 Square 1 715261
      , Element 143 Square 2 717270
      , Element 143 Square 2 720279
      , Element 144 Square 0 722289
      , Element 144 Square 0 725298
      , Element 145 Square 1 727304
      , Element 145 Square 1 730313
      , Element 146 Square 2 732324
      , Element 146 Square 2 735331
      , Element 147 Square 0 737341
      , Element 147 Square 0 740350
      , Element 148 Square 1 742356
      , Element 148 Square 1 745367
      , Element 149 Square 2 747376
      , Element 149 Square 2 750385
      , Element 150 Square 0 752395
      , Element 150 Square 0 755405
      , Element 151 Square 1 757415
      , Element 151 Square 1 760424
      , Element 152 Square 2 762433
      , Element 152 Square 2 765444
      , Element 153 Square 0 767454
      , Element 153 Square 0 770460
      , Element 154 Square 1 772466
      , Element 154 Square 1 775475
      , Element 155 Square 2 777494
      , Element 155 Square 2 780503
      , Element 156 Square 0 782513
      , Element 156 Square 0 785519
      , Element 157 Square 1 787528
      , Element 157 Square 1 790538
      , Element 158 Square 2 792547
      , Element 158 Square 2 795548
      , Element 159 Square 0 797555
      , Element 159 Square 0 800565
      , Element 160 Square 1 802575
      , Element 160 Square 1 805582
      , Element 161 Square 2 807587
      , Element 161 Square 2 810594
      , Element 162 Square 0 812600
      , Element 162 Square 0 815610
      , Element 163 Square 1 817613
      , Element 163 Square 1 820618
      , Element 164 Square 2 822629
      , Element 164 Square 2 825637
      , Element 165 Square 0 827644
      , Element 165 Square 0 830653
      , Element 166 Square 1 832663
      , Element 166 Square 1 835664
      , Element 167 Square 2 837674
      , Element 167 Square 2 840682
      , Element 168 Square 0 842689
      , Element 168 Square 0 845693
      , Element 169 Square 1 847698
      , Element 169 Square 1 850705
      , Element 170 Square 2 852712
      , Element 170 Square 2 855722
      , Element 171 Square 0 857731
      , Element 171 Square 0 860741
      , Element 172 Square 1 862748
      , Element 172 Square 1 865757
      , Element 173 Square 2 867765
      , Element 173 Square 2 870770
      , Element 174 Square 0 872771
      , Element 174 Square 0 875780
      , Element 175 Square 1 877789
      , Element 175 Square 1 880798
      , Element 176 Square 2 882802
      , Element 176 Square 2 885811
      , Element 177 Square 0 887821
      , Element 177 Square 0 890830
      , Element 178 Square 1 892840
      , Element 178 Square 1 895847
      , Element 179 Square 2 897852
      , Element 179 Square 2 900858
      , Element 180 Square 0 902864
      , Element 180 Square 0 905873
      , Element 181 Square 1 907880
      , Element 181 Square 1 910889
      , Element 182 Square 2 912898
      , Element 182 Square 2 915906
      , Element 183 Square 0 917913
      , Element 183 Square 0 920917
      , Element 184 Square 1 922924
      , Element 184 Square 1 925932
      , Element 185 Square 2 927942
      , Element 185 Square 2 930952
      , Element 186 Square 0 932962
      , Element 186 Square 0 935972
      , Element 187 Square 1 937980
      , Element 187 Square 1 940986
      , Element 188 Square 2 942996
      , Element 188 Square 2 946003
      , Element 189 Square 0 948012
      , Element 189 Square 0 951016
      , Element 190 Square 1 953026
      , Element 190 Square 1 956033
      , Element 191 Square 2 958042
      , Element 191 Square 2 961048
      , Element 192 Square 0 963055
      , Element 192 Square 0 966065
      , Element 193 Square 1 968075
      , Element 193 Square 1 971084
      , Element 194 Square 2 973093
      , Element 194 Square 2 976102
      , Element 195 Square 0 978110
      , Element 195 Square 0 981118
      , Element 196 Square 1 983124
      , Element 196 Square 1 986134
      , Element 197 Square 2 988140
      , Element 197 Square 2 991147
      , Element 198 Square 0 993154
      , Element 198 Square 0 996163
      , Element 199 Square 1 998172
      , Element 199 Square 1 1001181
      , Element 200 Square 2 1003188
      , Element 200 Square 2 1006198
      , Element 201 Square 0 1008205
      , Element 201 Square 0 1011212
      , Element 202 Square 1 1013214
      , Element 202 Square 1 1016223
      , Element 203 Square 2 1018232
      , Element 203 Square 2 1021241
      , Element 204 Square 0 1023250
      , Element 204 Square 0 1026258
      , Element 205 Square 1 1028266
      , Element 205 Square 1 1031272
      , Element 206 Square 2 1033280
      , Element 206 Square 2 1036286
      , Element 207 Square 0 1038295
      , Element 207 Square 0 1041305
      , Element 208 Square 1 1043309
      , Element 208 Square 1 1046318
      , Element 209 Square 2 1048327
      , Element 209 Square 2 1051334
      , Element 210 Square 0 1053343
      , Element 210 Square 0 1056352
      , Element 211 Square 1 1058360
      , Element 211 Square 1 1061368
      , Element 212 Square 2 1063373
      , Element 212 Square 2 1066383
      , Element 213 Square 0 1068390
      , Element 213 Square 0 1071399
      , Element 214 Square 1 1073405
      , Element 214 Square 1 1076413
      , Element 215 Square 2 1078422
      , Element 215 Square 2 1081431
      , Element 216 Square 0 1083441
      , Element 216 Square 0 1086447
      , Element 217 Square 1 1088458
      , Element 217 Square 1 1091466
      , Element 218 Square 2 1093477
      , Element 218 Square 2 1096481
      , Element 219 Square 0 1098487
      , Element 219 Square 0 1101493
      , Element 220 Square 1 1103501
      , Element 220 Square 1 1106511
      , Element 221 Square 2 1108518
      , Element 221 Square 2 1111528
      , Element 222 Square 0 1113532
      , Element 222 Square 0 1116542
      , Element 223 Square 1 1118550
      , Element 223 Square 1 1121553
      , Element 224 Square 2 1123563
      , Element 224 Square 2 1126569
      , Element 225 Square 0 1128579
      , Element 225 Square 0 1131586
      , Element 226 Square 1 1133594
      , Element 226 Square 1 1136601
      , Element 227 Square 2 1138606
      , Element 227 Square 2 1141612
      , Element 228 Square 0 1143618
      , Element 228 Square 0 1146628
      , Element 229 Square 1 1148629
      , Element 229 Square 1 1151637
      , Element 230 Square 2 1153641
      , Element 230 Square 2 1156649
      , Element 231 Square 0 1158659
      , Element 231 Square 0 1161667
      , Element 232 Square 1 1163676
      , Element 232 Square 1 1166681
      , Element 233 Square 2 1168688
      , Element 233 Square 2 1171697
      , Element 234 Square 0 1173707
      , Element 234 Square 0 1176714
      , Element 235 Square 1 1178723
      , Element 235 Square 1 1181729
      , Element 236 Square 2 1183739
      , Element 236 Square 2 1186743
      , Element 237 Square 0 1188751
      , Element 237 Square 0 1191759
      , Element 238 Square 1 1193766
      , Element 238 Square 1 1196773
      , Element 239 Square 2 1198781
      , Element 239 Square 2 1201790
      , Element 240 Square 0 1203791
      , Element 240 Square 0 1206798
      , Element 241 Square 1 1208805
      , Element 241 Square 1 1211812
      , Element 242 Square 2 1213818
      , Element 242 Square 2 1216827
      , Element 243 Square 0 1218835
      , Element 243 Square 0 1221841
      , Element 244 Square 1 1223849
      , Element 244 Square 1 1226858
      , Element 245 Square 2 1228861
      , Element 245 Square 2 1231869
      , Element 246 Square 0 1233878
      , Element 246 Square 0 1236883
      , Element 247 Square 1 1238893
      , Element 247 Square 1 1241902
      , Element 248 Square 2 1243907
      , Element 248 Square 2 1246909
      , Element 249 Square 0 1248916
      , Element 249 Square 0 1251927
      , Element 250 Square 1 1253937
      , Element 250 Square 1 1256945
      , Element 251 Square 2 1258954
      , Element 251 Square 2 1261957
      , Element 252 Square 0 1263967
      , Element 252 Square 0 1266976
      , Element 253 Square 1 1268985
      , Element 253 Square 1 1271993
      , Element 254 Square 2 1274003
      , Element 254 Square 2 1277009
      , Element 255 Square 0 1279019
      , Element 255 Square 0 1282028
      , Element 256 Square 1 1284036
      , Element 256 Square 1 1287045
      , Element 257 Square 2 1289049
      , Element 257 Square 2 1292058
      , Element 258 Square 0 1294068
      , Element 258 Square 0 1297077
      , Element 259 Square 1 1299086
      , Element 259 Square 1 1302095
      , Element 260 Square 2 1304104
      , Element 260 Square 2 1307113
      , Element 261 Square 0 1309123
      , Element 261 Square 0 1312133
      , Element 262 Square 1 1314142
      , Element 262 Square 1 1317151
      , Element 263 Square 2 1319160
      , Element 263 Square 2 1322166
      , Element 264 Square 0 1324181
      , Element 264 Square 0 1327182
      , Element 265 Square 1 1329191
      , Element 265 Square 1 1332198
      , Element 266 Square 2 1334203
      , Element 266 Square 2 1337213
      , Element 267 Square 0 1339220
      , Element 267 Square 0 1342224
      , Element 268 Square 1 1344228
      , Element 268 Square 1 1347234
      , Element 269 Square 2 1349243
      , Element 269 Square 2 1352262
      , Element 270 Square 0 1354268
      , Element 270 Square 0 1357279
      , Element 271 Square 1 1359288
      , Element 271 Square 1 1362292
      , Element 272 Square 2 1364300
      , Element 272 Square 2 1367309
      , Element 273 Square 0 1369315
      , Element 273 Square 0 1372325
      , Element 274 Square 1 1374336
      , Element 274 Square 1 1377343
      , Element 275 Square 2 1379350
      , Element 275 Square 2 1382359
      , Element 276 Square 0 1384363
      , Element 276 Square 0 1387373
      , Element 277 Square 1 1389379
      , Element 277 Square 1 1392385
      , Element 278 Square 2 1394395
      , Element 278 Square 2 1397402
      , Element 279 Square 0 1399412
      , Element 279 Square 0 1402420
      , Element 280 Square 1 1404430
      , Element 280 Square 1 1407439
      , Element 281 Square 2 1409446
      , Element 281 Square 2 1412456
      , Element 282 Square 0 1414463
      , Element 282 Square 0 1417473
      , Element 283 Square 1 1419482
      , Element 283 Square 1 1422492
      , Element 284 Square 2 1424500
      , Element 284 Square 2 1427504
      , Element 285 Square 0 1429514
      , Element 285 Square 0 1432523
      , Element 286 Square 1 1434533
      , Element 286 Square 1 1437540
      , Element 287 Square 2 1439543
      , Element 287 Square 2 1442548
      , Element 288 Square 0 1444556
      , Element 288 Square 0 1447562
      , Element 289 Square 1 1449572
      , Element 289 Square 1 1452578
      , Element 290 Square 2 1454589
      , Element 290 Square 2 1457602
      , Element 291 Square 0 1459612
      , Element 291 Square 0 1462622
      , Element 292 Square 1 1464631
      , Element 292 Square 1 1467639
      , Element 293 Square 2 1469647
      , Element 293 Square 2 1472655
      , Element 294 Square 0 1474663
      , Element 294 Square 0 1477671
      , Element 295 Square 1 1479680
      , Element 295 Square 1 1482683
      , Element 296 Square 2 1484691
      , Element 296 Square 2 1487700
      , Element 297 Square 0 1489705
      , Element 297 Square 0 1492713
      , Element 298 Square 1 1494722
      , Element 298 Square 1 1497726
      , Element 299 Square 2 1499730
      , Element 299 Square 2 1502732
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
mapped: rx.Observable[int] = numbers >> ops.concat_map(
    lambda n: rx.concat(
        rx.just(n),
        rx.just(n) >> ops.delay(3)
    )
)
mapped.run()
""" showCode


operatorFold : Bool -> Bool -> UnindexedSlideModel
operatorFold showCode animate =
  operator "reduce: Combine all elements of an Observable"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.reduce(...)"
      , text " accepts a seed value, and a combining function, combining the seed value and all elements of the Observable into a single element."
      ]
    , p []
      [ text "It is used for general aggregation operations." ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "Output is a single element" ]
        , li [] [ text "Does not return if input is infinite" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 1, widthEm = 3 }
  , value =
    Stream
    { terminal = True
    , elements =
      [ Element 0 Disc 0 2010
      , Element 1 Disc 1 4021
      , Element 2 Disc 2 6026
      , Element 3 Disc 0 8032
      , Element 4 Disc 1 10041
      , Element 5 Disc 2 12045
      , Element 6 Disc 0 14054
      , Element 7 Disc 1 16061
      , Element 8 Disc 2 18070
      , Element 9 Disc 0 20078
      ]
    }
  }
  { horizontalPosition = { leftEm = 4, widthEm = 9 }
  , operatorCode =
    [ "reduce("
    , "\xA0\xA0lambda x,y: x+y,"
    , "\xA0\xA0seed=0"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 13, widthEm = 3 }
  , value =
    Stream
    { terminal = True
    , elements = [ Element 45 Square 2 20078 ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
reduced: rx.Observable[int] = numbers >> ops.take(10) >> ops.reduce(
    lambda x,y: x+y,
    seed=0
)
reduced.run()
""" showCode


operatorRunningFold : Bool -> Bool -> UnindexedSlideModel
operatorRunningFold showCode animate =
  operator "scan: reduce that emits the value of each step"
  ( div []
    [ p []
      [ syntaxHighlightedCodeSnippet Python "reactivex.operators.scan(...)"
      , text " is just a reduce that emits the accumulated value on every combining step."
      ]
    , p []
      [ text "Properties:"
      , ul []
        [ li [] [ text "Output has one more element than input" ]
        , li [] [ text "Output type can be anything (determined by combining function’s seed value)" ]
        ]
      ]
    ]
  )
  { horizontalPosition = { leftEm = 1, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Disc 0 2010
      , Element 1 Disc 1 4021
      , Element 2 Disc 2 6026
      , Element 3 Disc 0 8032
      , Element 4 Disc 1 10041
      , Element 5 Disc 2 12045
      , Element 6 Disc 0 14054
      , Element 7 Disc 1 16061
      , Element 8 Disc 2 18070
      , Element 9 Disc 0 20078
      , Element 10 Disc 1 22083
      , Element 11 Disc 2 24090
      , Element 12 Disc 0 26097
      , Element 13 Disc 1 28105
      , Element 14 Disc 2 30112
      , Element 15 Disc 0 32121
      , Element 16 Disc 1 34129
      , Element 17 Disc 2 36139
      , Element 18 Disc 0 38148
      , Element 19 Disc 1 40158
      , Element 20 Disc 2 42165
      , Element 21 Disc 0 44171
      , Element 22 Disc 1 46180
      , Element 23 Disc 2 48187
      , Element 24 Disc 0 50191
      , Element 25 Disc 1 52199
      , Element 26 Disc 2 54208
      , Element 27 Disc 0 56216
      , Element 28 Disc 1 58223
      , Element 29 Disc 2 60232
      , Element 30 Disc 0 62240
      , Element 31 Disc 1 64248
      , Element 32 Disc 2 66256
      , Element 33 Disc 0 68260
      , Element 34 Disc 1 70268
      , Element 35 Disc 2 72277
      , Element 36 Disc 0 74286
      , Element 37 Disc 1 76291
      , Element 38 Disc 2 78302
      , Element 39 Disc 0 80308
      , Element 40 Disc 1 82311
      , Element 41 Disc 2 84320
      , Element 42 Disc 0 86326
      , Element 43 Disc 1 88333
      , Element 44 Disc 2 90343
      , Element 45 Disc 0 92354
      , Element 46 Disc 1 94360
      , Element 47 Disc 2 96363
      , Element 48 Disc 0 98372
      , Element 49 Disc 1 100381
      , Element 50 Disc 2 102389
      , Element 51 Disc 0 104395
      , Element 52 Disc 1 106399
      , Element 53 Disc 2 108405
      , Element 54 Disc 0 110408
      , Element 55 Disc 1 112416
      , Element 56 Disc 2 114424
      , Element 57 Disc 0 116431
      , Element 58 Disc 1 118441
      , Element 59 Disc 2 120449
      , Element 60 Disc 0 122455
      , Element 61 Disc 1 124464
      , Element 62 Disc 2 126471
      , Element 63 Disc 0 128478
      , Element 64 Disc 1 130487
      , Element 65 Disc 2 132494
      , Element 66 Disc 0 134500
      , Element 67 Disc 1 136506
      , Element 68 Disc 2 138517
      , Element 69 Disc 0 140523
      , Element 70 Disc 1 142532
      , Element 71 Disc 2 144538
      , Element 72 Disc 0 146549
      , Element 73 Disc 1 148558
      , Element 74 Disc 2 150567
      , Element 75 Disc 0 152575
      , Element 76 Disc 1 154583
      , Element 77 Disc 2 156591
      , Element 78 Disc 0 158599
      , Element 79 Disc 1 160609
      , Element 80 Disc 2 162618
      , Element 81 Disc 0 164628
      , Element 82 Disc 1 166637
      , Element 83 Disc 2 168646
      , Element 84 Disc 0 170656
      , Element 85 Disc 1 172661
      , Element 86 Disc 2 174666
      , Element 87 Disc 0 176675
      , Element 88 Disc 1 178685
      , Element 89 Disc 2 180695
      , Element 90 Disc 0 182701
      , Element 91 Disc 1 184711
      , Element 92 Disc 2 186720
      , Element 93 Disc 0 188727
      , Element 94 Disc 1 190735
      , Element 95 Disc 2 192745
      , Element 96 Disc 0 194752
      , Element 97 Disc 1 196762
      , Element 98 Disc 2 198768
      , Element 99 Disc 0 200778
      , Element 100 Disc 1 202786
      , Element 101 Disc 2 204794
      , Element 102 Disc 0 206801
      , Element 103 Disc 1 208811
      , Element 104 Disc 2 210819
      , Element 105 Disc 0 212827
      , Element 106 Disc 1 214836
      , Element 107 Disc 2 216846
      , Element 108 Disc 0 218854
      , Element 109 Disc 1 220861
      , Element 110 Disc 2 222869
      , Element 111 Disc 0 224875
      , Element 112 Disc 1 226880
      , Element 113 Disc 2 228886
      , Element 114 Disc 0 230888
      , Element 115 Disc 1 232896
      , Element 116 Disc 2 234905
      , Element 117 Disc 0 236912
      , Element 118 Disc 1 238920
      , Element 119 Disc 2 240927
      , Element 120 Disc 0 242936
      , Element 121 Disc 1 244946
      , Element 122 Disc 2 246955
      , Element 123 Disc 0 248961
      , Element 124 Disc 1 250970
      , Element 125 Disc 2 252981
      , Element 126 Disc 0 254990
      , Element 127 Disc 1 256999
      , Element 128 Disc 2 259008
      , Element 129 Disc 0 261016
      , Element 130 Disc 1 263025
      , Element 131 Disc 2 265034
      , Element 132 Disc 0 267045
      , Element 133 Disc 1 269055
      , Element 134 Disc 2 271063
      , Element 135 Disc 0 273072
      , Element 136 Disc 1 275083
      , Element 137 Disc 2 277093
      , Element 138 Disc 0 279099
      , Element 139 Disc 1 281108
      , Element 140 Disc 2 283118
      , Element 141 Disc 0 285120
      , Element 142 Disc 1 287127
      , Element 143 Disc 2 289131
      , Element 144 Disc 0 291141
      , Element 145 Disc 1 293148
      , Element 146 Disc 2 295157
      , Element 147 Disc 0 297166
      , Element 148 Disc 1 299177
      , Element 149 Disc 2 301182
      , Element 150 Disc 0 303192
      , Element 151 Disc 1 305202
      , Element 152 Disc 2 307209
      , Element 153 Disc 0 309209
      , Element 154 Disc 1 311215
      , Element 155 Disc 2 313218
      , Element 156 Disc 0 315226
      , Element 157 Disc 1 317233
      , Element 158 Disc 2 319239
      , Element 159 Disc 0 321243
      , Element 160 Disc 1 323250
      , Element 161 Disc 2 325256
      , Element 162 Disc 0 327263
      , Element 163 Disc 1 329273
      , Element 164 Disc 2 331280
      , Element 165 Disc 0 333286
      , Element 166 Disc 1 335294
      , Element 167 Disc 2 337302
      , Element 168 Disc 0 339312
      , Element 169 Disc 1 341318
      , Element 170 Disc 2 343327
      , Element 171 Disc 0 345336
      , Element 172 Disc 1 347345
      , Element 173 Disc 2 349354
      , Element 174 Disc 0 351360
      , Element 175 Disc 1 353365
      , Element 176 Disc 2 355373
      , Element 177 Disc 0 357376
      , Element 178 Disc 1 359386
      , Element 179 Disc 2 361396
      , Element 180 Disc 0 363405
      , Element 181 Disc 1 365410
      , Element 182 Disc 2 367417
      , Element 183 Disc 0 369423
      , Element 184 Disc 1 371430
      , Element 185 Disc 2 373440
      , Element 186 Disc 0 375447
      , Element 187 Disc 1 377454
      , Element 188 Disc 2 379463
      , Element 189 Disc 0 381468
      , Element 190 Disc 1 383478
      , Element 191 Disc 2 385487
      , Element 192 Disc 0 387495
      , Element 193 Disc 1 389504
      , Element 194 Disc 2 391512
      , Element 195 Disc 0 393516
      , Element 196 Disc 1 395524
      , Element 197 Disc 2 397531
      , Element 198 Disc 0 399542
      , Element 199 Disc 1 401552
      , Element 200 Disc 2 403562
      , Element 201 Disc 0 405572
      , Element 202 Disc 1 407580
      , Element 203 Disc 2 409582
      , Element 204 Disc 0 411589
      , Element 205 Disc 1 413594
      , Element 206 Disc 2 415602
      , Element 207 Disc 0 417607
      , Element 208 Disc 1 419611
      , Element 209 Disc 2 421619
      , Element 210 Disc 0 423629
      , Element 211 Disc 1 425638
      , Element 212 Disc 2 427643
      , Element 213 Disc 0 429653
      , Element 214 Disc 1 431663
      , Element 215 Disc 2 433672
      , Element 216 Disc 0 435679
      , Element 217 Disc 1 437690
      , Element 218 Disc 2 439699
      , Element 219 Disc 0 441707
      , Element 220 Disc 1 443715
      , Element 221 Disc 2 445724
      , Element 222 Disc 0 447733
      , Element 223 Disc 1 449742
      , Element 224 Disc 2 451752
      , Element 225 Disc 0 453760
      , Element 226 Disc 1 455768
      , Element 227 Disc 2 457775
      , Element 228 Disc 0 459781
      , Element 229 Disc 1 461788
      , Element 230 Disc 2 463795
      , Element 231 Disc 0 465804
      , Element 232 Disc 1 467812
      , Element 233 Disc 2 469819
      , Element 234 Disc 0 471829
      , Element 235 Disc 1 473838
      , Element 236 Disc 2 475843
      , Element 237 Disc 0 477853
      , Element 238 Disc 1 479861
      , Element 239 Disc 2 481867
      , Element 240 Disc 0 483876
      , Element 241 Disc 1 485883
      , Element 242 Disc 2 487893
      , Element 243 Disc 0 489898
      , Element 244 Disc 1 491905
      , Element 245 Disc 2 493912
      , Element 246 Disc 0 495917
      , Element 247 Disc 1 497925
      , Element 248 Disc 2 499931
      , Element 249 Disc 0 501942
      , Element 250 Disc 1 503951
      , Element 251 Disc 2 505958
      , Element 252 Disc 0 507967
      , Element 253 Disc 1 509977
      , Element 254 Disc 2 511984
      , Element 255 Disc 0 513992
      , Element 256 Disc 1 515998
      , Element 257 Disc 2 518002
      , Element 258 Disc 0 520010
      , Element 259 Disc 1 522012
      , Element 260 Disc 2 524020
      , Element 261 Disc 0 526023
      , Element 262 Disc 1 528032
      , Element 263 Disc 2 530042
      , Element 264 Disc 0 532050
      , Element 265 Disc 1 534058
      , Element 266 Disc 2 536061
      , Element 267 Disc 0 538071
      , Element 268 Disc 1 540077
      , Element 269 Disc 2 542088
      , Element 270 Disc 0 544093
      , Element 271 Disc 1 546100
      , Element 272 Disc 2 548107
      , Element 273 Disc 0 550118
      , Element 274 Disc 1 552121
      , Element 275 Disc 2 554127
      , Element 276 Disc 0 556135
      , Element 277 Disc 1 558146
      , Element 278 Disc 2 560153
      , Element 279 Disc 0 562161
      , Element 280 Disc 1 564168
      , Element 281 Disc 2 566177
      , Element 282 Disc 0 568183
      , Element 283 Disc 1 570193
      , Element 284 Disc 2 572201
      , Element 285 Disc 0 574206
      , Element 286 Disc 1 576215
      , Element 287 Disc 2 578221
      , Element 288 Disc 0 580227
      , Element 289 Disc 1 582235
      , Element 290 Disc 2 584244
      , Element 291 Disc 0 586253
      , Element 292 Disc 1 588262
      , Element 293 Disc 2 590267
      , Element 294 Disc 0 592277
      , Element 295 Disc 1 594284
      , Element 296 Disc 2 596293
      , Element 297 Disc 0 598303
      , Element 298 Disc 1 600313
      , Element 299 Disc 2 602317
      ]
    }
  }
  { horizontalPosition = { leftEm = 4, widthEm = 9 }
  , operatorCode =
    [ "scan("
    , "\xA0\xA0lambda x,y: x+y,"
    , "\xA0\xA0seed=0"
    , ")"
    ]
  }
  { horizontalPosition = { leftEm = 13, widthEm = 3 }
  , value =
    Stream
    { terminal = False
    , elements =
      [ Element 0 Square -1 0
      , Element 0 Square 0 2012
      , Element 1 Square 1 4021
      , Element 3 Square 2 6026
      , Element 6 Square 0 8032
      , Element 10 Square 1 10042
      , Element 15 Square 2 12045
      , Element 21 Square 0 14054
      , Element 28 Square 1 16061
      , Element 36 Square 2 18070
      , Element 45 Square 0 20078
      , Element 55 Square 1 22083
      , Element 66 Square 2 24090
      , Element 78 Square 0 26097
      , Element 91 Square 1 28105
      , Element 105 Square 2 30112
      , Element 120 Square 0 32121
      , Element 136 Square 1 34129
      , Element 153 Square 2 36139
      , Element 171 Square 0 38148
      , Element 190 Square 1 40158
      , Element 210 Square 2 42165
      , Element 231 Square 0 44171
      , Element 253 Square 1 46180
      , Element 276 Square 2 48187
      , Element 300 Square 0 50191
      , Element 325 Square 1 52199
      , Element 351 Square 2 54208
      , Element 378 Square 0 56216
      , Element 406 Square 1 58223
      , Element 435 Square 2 60232
      , Element 465 Square 0 62240
      , Element 496 Square 1 64248
      , Element 528 Square 2 66256
      , Element 561 Square 0 68260
      , Element 595 Square 1 70268
      , Element 630 Square 2 72277
      , Element 666 Square 0 74286
      , Element 703 Square 1 76292
      , Element 741 Square 2 78302
      , Element 780 Square 0 80308
      , Element 820 Square 1 82311
      , Element 861 Square 2 84320
      , Element 903 Square 0 86326
      , Element 946 Square 1 88333
      , Element 990 Square 2 90343
      , Element 1035 Square 0 92354
      , Element 1081 Square 1 94360
      , Element 1128 Square 2 96363
      , Element 1176 Square 0 98372
      , Element 1225 Square 1 100381
      , Element 1275 Square 2 102389
      , Element 1326 Square 0 104395
      , Element 1378 Square 1 106399
      , Element 1431 Square 2 108405
      , Element 1485 Square 0 110408
      , Element 1540 Square 1 112416
      , Element 1596 Square 2 114425
      , Element 1653 Square 0 116431
      , Element 1711 Square 1 118442
      , Element 1770 Square 2 120449
      , Element 1830 Square 0 122455
      , Element 1891 Square 1 124464
      , Element 1953 Square 2 126471
      , Element 2016 Square 0 128478
      , Element 2080 Square 1 130487
      , Element 2145 Square 2 132494
      , Element 2211 Square 0 134500
      , Element 2278 Square 1 136506
      , Element 2346 Square 2 138517
      , Element 2415 Square 0 140523
      , Element 2485 Square 1 142532
      , Element 2556 Square 2 144538
      , Element 2628 Square 0 146549
      , Element 2701 Square 1 148558
      , Element 2775 Square 2 150567
      , Element 2850 Square 0 152575
      , Element 2926 Square 1 154583
      , Element 3003 Square 2 156591
      , Element 3081 Square 0 158599
      , Element 3160 Square 1 160609
      , Element 3240 Square 2 162619
      , Element 3321 Square 0 164628
      , Element 3403 Square 1 166637
      , Element 3486 Square 2 168646
      , Element 3570 Square 0 170656
      , Element 3655 Square 1 172661
      , Element 3741 Square 2 174666
      , Element 3828 Square 0 176676
      , Element 3916 Square 1 178685
      , Element 4005 Square 2 180695
      , Element 4095 Square 0 182701
      , Element 4186 Square 1 184711
      , Element 4278 Square 2 186720
      , Element 4371 Square 0 188727
      , Element 4465 Square 1 190735
      , Element 4560 Square 2 192746
      , Element 4656 Square 0 194752
      , Element 4753 Square 1 196762
      , Element 4851 Square 2 198768
      , Element 4950 Square 0 200778
      , Element 5050 Square 1 202786
      , Element 5151 Square 2 204794
      , Element 5253 Square 0 206801
      , Element 5356 Square 1 208811
      , Element 5460 Square 2 210819
      , Element 5565 Square 0 212827
      , Element 5671 Square 1 214836
      , Element 5778 Square 2 216846
      , Element 5886 Square 0 218854
      , Element 5995 Square 1 220861
      , Element 6105 Square 2 222870
      , Element 6216 Square 0 224875
      , Element 6328 Square 1 226880
      , Element 6441 Square 2 228886
      , Element 6555 Square 0 230888
      , Element 6670 Square 1 232896
      , Element 6786 Square 2 234905
      , Element 6903 Square 0 236912
      , Element 7021 Square 1 238920
      , Element 7140 Square 2 240927
      , Element 7260 Square 0 242936
      , Element 7381 Square 1 244946
      , Element 7503 Square 2 246955
      , Element 7626 Square 0 248961
      , Element 7750 Square 1 250971
      , Element 7875 Square 2 252981
      , Element 8001 Square 0 254991
      , Element 8128 Square 1 256999
      , Element 8256 Square 2 259008
      , Element 8385 Square 0 261016
      , Element 8515 Square 1 263025
      , Element 8646 Square 2 265035
      , Element 8778 Square 0 267045
      , Element 8911 Square 1 269055
      , Element 9045 Square 2 271064
      , Element 9180 Square 0 273072
      , Element 9316 Square 1 275083
      , Element 9453 Square 2 277093
      , Element 9591 Square 0 279099
      , Element 9730 Square 1 281109
      , Element 9870 Square 2 283118
      , Element 10011 Square 0 285120
      , Element 10153 Square 1 287127
      , Element 10296 Square 2 289131
      , Element 10440 Square 0 291141
      , Element 10585 Square 1 293148
      , Element 10731 Square 2 295158
      , Element 10878 Square 0 297166
      , Element 11026 Square 1 299177
      , Element 11175 Square 2 301182
      , Element 11325 Square 0 303192
      , Element 11476 Square 1 305202
      , Element 11628 Square 2 307209
      , Element 11781 Square 0 309209
      , Element 11935 Square 1 311215
      , Element 12090 Square 2 313218
      , Element 12246 Square 0 315226
      , Element 12403 Square 1 317233
      , Element 12561 Square 2 319240
      , Element 12720 Square 0 321243
      , Element 12880 Square 1 323250
      , Element 13041 Square 2 325256
      , Element 13203 Square 0 327264
      , Element 13366 Square 1 329273
      , Element 13530 Square 2 331280
      , Element 13695 Square 0 333286
      , Element 13861 Square 1 335294
      , Element 14028 Square 2 337302
      , Element 14196 Square 0 339312
      , Element 14365 Square 1 341318
      , Element 14535 Square 2 343327
      , Element 14706 Square 0 345336
      , Element 14878 Square 1 347346
      , Element 15051 Square 2 349355
      , Element 15225 Square 0 351360
      , Element 15400 Square 1 353365
      , Element 15576 Square 2 355373
      , Element 15753 Square 0 357376
      , Element 15931 Square 1 359386
      , Element 16110 Square 2 361396
      , Element 16290 Square 0 363405
      , Element 16471 Square 1 365410
      , Element 16653 Square 2 367417
      , Element 16836 Square 0 369423
      , Element 17020 Square 1 371430
      , Element 17205 Square 2 373440
      , Element 17391 Square 0 375447
      , Element 17578 Square 1 377454
      , Element 17766 Square 2 379463
      , Element 17955 Square 0 381469
      , Element 18145 Square 1 383479
      , Element 18336 Square 2 385487
      , Element 18528 Square 0 387495
      , Element 18721 Square 1 389504
      , Element 18915 Square 2 391512
      , Element 19110 Square 0 393516
      , Element 19306 Square 1 395525
      , Element 19503 Square 2 397532
      , Element 19701 Square 0 399542
      , Element 19900 Square 1 401552
      , Element 20100 Square 2 403562
      , Element 20301 Square 0 405572
      , Element 20503 Square 1 407581
      , Element 20706 Square 2 409582
      , Element 20910 Square 0 411589
      , Element 21115 Square 1 413594
      , Element 21321 Square 2 415602
      , Element 21528 Square 0 417608
      , Element 21736 Square 1 419611
      , Element 21945 Square 2 421619
      , Element 22155 Square 0 423629
      , Element 22366 Square 1 425638
      , Element 22578 Square 2 427643
      , Element 22791 Square 0 429654
      , Element 23005 Square 1 431663
      , Element 23220 Square 2 433672
      , Element 23436 Square 0 435680
      , Element 23653 Square 1 437690
      , Element 23871 Square 2 439699
      , Element 24090 Square 0 441707
      , Element 24310 Square 1 443715
      , Element 24531 Square 2 445724
      , Element 24753 Square 0 447733
      , Element 24976 Square 1 449742
      , Element 25200 Square 2 451752
      , Element 25425 Square 0 453760
      , Element 25651 Square 1 455768
      , Element 25878 Square 2 457775
      , Element 26106 Square 0 459781
      , Element 26335 Square 1 461789
      , Element 26565 Square 2 463795
      , Element 26796 Square 0 465805
      , Element 27028 Square 1 467812
      , Element 27261 Square 2 469820
      , Element 27495 Square 0 471829
      , Element 27730 Square 1 473838
      , Element 27966 Square 2 475843
      , Element 28203 Square 0 477853
      , Element 28441 Square 1 479861
      , Element 28680 Square 2 481867
      , Element 28920 Square 0 483876
      , Element 29161 Square 1 485883
      , Element 29403 Square 2 487893
      , Element 29646 Square 0 489898
      , Element 29890 Square 1 491905
      , Element 30135 Square 2 493912
      , Element 30381 Square 0 495917
      , Element 30628 Square 1 497925
      , Element 30876 Square 2 499931
      , Element 31125 Square 0 501942
      , Element 31375 Square 1 503952
      , Element 31626 Square 2 505958
      , Element 31878 Square 0 507968
      , Element 32131 Square 1 509977
      , Element 32385 Square 2 511984
      , Element 32640 Square 0 513992
      , Element 32896 Square 1 515998
      , Element 33153 Square 2 518002
      , Element 33411 Square 0 520011
      , Element 33670 Square 1 522012
      , Element 33930 Square 2 524020
      , Element 34191 Square 0 526024
      , Element 34453 Square 1 528032
      , Element 34716 Square 2 530042
      , Element 34980 Square 0 532050
      , Element 35245 Square 1 534058
      , Element 35511 Square 2 536062
      , Element 35778 Square 0 538071
      , Element 36046 Square 1 540077
      , Element 36315 Square 2 542088
      , Element 36585 Square 0 544093
      , Element 36856 Square 1 546100
      , Element 37128 Square 2 548108
      , Element 37401 Square 0 550118
      , Element 37675 Square 1 552121
      , Element 37950 Square 2 554127
      , Element 38226 Square 0 556135
      , Element 38503 Square 1 558146
      , Element 38781 Square 2 560153
      , Element 39060 Square 0 562161
      , Element 39340 Square 1 564168
      , Element 39621 Square 2 566177
      , Element 39903 Square 0 568184
      , Element 40186 Square 1 570193
      , Element 40470 Square 2 572201
      , Element 40755 Square 0 574206
      , Element 41041 Square 1 576215
      , Element 41328 Square 2 578221
      , Element 41616 Square 0 580227
      , Element 41905 Square 1 582235
      , Element 42195 Square 2 584244
      , Element 42486 Square 0 586253
      , Element 42778 Square 1 588262
      , Element 43071 Square 2 590268
      , Element 43365 Square 0 592277
      , Element 43660 Square 1 594284
      , Element 43956 Square 2 596293
      , Element 44253 Square 0 598303
      , Element 44551 Square 1 600313
      , Element 44850 Square 2 602317
      ]
    }
  }
  animate
  """
import reactivex as rx
import reactivex.operators as ops

numbers: rx.Observable[int] = rx.timer(2, 2)
scanned: rx.Observable[int] = numbers >> ops.scan(
    lambda x,y: (x+y),
    seed=0
)
scanned.run()
""" showCode


operatorCollect : UnindexedSlideModel
operatorCollect =
  { baseSlideModel
  | view =
    ( \page _ -> standardSlideView page heading
      "Running the Observable"
      ( div []
        [ p []
          [ text "In the previous code snippets, you may have noticed that they all end with a call to "
          , syntaxHighlightedCodeSnippet Python "run()"
          , text ". This is because Observables are cold, and does not start running otherwise."
          ]
        , p []
          [ syntaxHighlightedCodeSnippet Python "subscribe(...)"
          , text " is another way to start the Observable, and preferred as it is asynchronous."
          ]
        , p []
          [ syntaxHighlightedCodeBlock Python Dict.empty Dict.empty []
      """
import reactivex as rx

numbers: rx.Observable[int] = rx.timer(2, 2)
numbers.run()
"""
          ]
        ]
      )
    )
  }


slides : List UnindexedSlideModel
slides =
  ( introduction
  ::( [ operatorMap
      , operatorFilter
      , operatorTake
      , operatorFlatMapMerge
      , operatorFlatMapConcat
      , operatorFold
      , operatorRunningFold
      ]
      |> List.concatMap
        ( \slide ->
          [ slide False False
          , slide False True
          , slide True True
          , slide False True
          ]
        )
    )
  )
  ++[ operatorCollect ]
