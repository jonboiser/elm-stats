module Tests exposing (..)
import String exposing (left)
import ElmTest exposing (..)

tests : Test
tests =
    suite "A Test Suite"
        [ test "Addition" (assertEqual (3 + 7) 10)
        , test "String.left" (assertEqual "a" (String.left 1 "abcdefg"))
        , test "This test should fail" (assert False)
        ]

main : Program Never
main =
    runSuite tests
