module StatsTests exposing (tests)

import ElmTest exposing (..)
import Stats exposing (..)

tests : Test
tests =
    suite "Stats"
        [ meanTests
        , geometricMeanTests
        , maximumTests
        ]

meanTests : Test
meanTests =
    suite "Stat.mean"
        [ test "" (assertEqual (mean [1..5]) (Ok 3))
        , test "" (assertEqual (mean [-1,1,0]) (Ok 0))
        ]

geometricMeanTests : Test
geometricMeanTests =
    suite "Stats.geometricMean"
        [ test "" (assertEqual (geometricMean [1..5]) (Ok 2.605171084697352))
        , test "" (assertEqual (geometricMean [1,1,1]) (Ok 1))
        ]

maximumTests : Test
maximumTests =
    suite "Stats.maximum"
        [ test "" (assertEqual (maximum [10,4,2,-3]) (Ok 10))

        ]
