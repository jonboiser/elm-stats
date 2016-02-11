module Stats.Util (..) where

{-|-}
import List.Extra as LExtra

{-| Given a list, returns a list of tuples whose first element is a list
entry, and whose second is the number of times it appears in the list.
-}
groupCount : List a -> List (Maybe a, Int)
groupCount xs =
  if List.isEmpty xs then []
  else
    LExtra.group xs
    |> List.map (\ys -> (List.head ys, List.length ys))

{-| Returns n!, where n is an integer.
-}
factorial : Int -> Int
factorial n =
  List.product [1..n]

{-| Given a list of data and an integer n, returns a list of lists (chunks)
each of size n. If the size of the list is not divisble by n, the last chunk
will contain the remainder.
-}
chunk : Int -> List a -> List (List a)
chunk n xs =
  if List.isEmpty xs then []
  else
    (List.take n xs) :: (List.drop n xs |> chunk n)
