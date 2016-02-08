module Stats.Util where

import List.Extra as LExtra

{-| Given a list, returns a list of tuples whose first element is a list
entry, and whose second is the number of times it appears in the list.
-}
groupCount : List a -> List (Maybe a, Int)
groupCount xs =
  if List.isEmpty xs then []
  else
    LExtra.group xs
    |> List.map (ys -> (List.head ys, List.length ys))
