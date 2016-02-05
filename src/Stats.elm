module Stats where

lengthf : List a -> Float
lengthf xs = List.length xs |> Basics.toFloat

{-| Calculates the arithmetic mean of a list of numbers.
-}
mean : List Float -> Maybe Float
mean xs =
  if List.isEmpty xs then Nothing
  else
    let
      n = lengthf xs
      total = List.sum xs
    in
      Just (total / n)

{-| Calculates the geometric mean of a list of numbers.
See https://en.wikipedia.org/wiki/Geometric_mean for a definition.
-}
geometricMean : List Float -> Maybe Float
geometricMean xs =
  if List.isEmpty xs then Nothing
  else
    let
      n = lengthf xs
      prod = List.product xs
    in
      Just (prod ^ (1 / n))

{-| Calculates the harmonic mean of a list of numbers.
See https://en.wikipedia.org/wiki/Harmonic_mean for a definition.
-}
harmonicMean : List Float -> Maybe Float
harmonicMean xs =
  if List.isEmpty xs || List.any ((>=) 0) xs
    then Nothing
  else
    let
      n = lengthf xs
      sumReciprocals = xs |> List.map ((/) 1) |> List.sum
    in
      Just (n / sumReciprocals)
