module Tests exposing (..)
import ElmTest exposing (..)
import StatsTests as Stats

tests : Test
tests =
    suite "Elm Stats"
        [ Stats.tests
        ]

main : Program Never
main =
    runSuite tests
