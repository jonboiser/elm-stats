module Stats where

lengthf : List a -> Float
lengthf xs = List.length xs |> toFloat

emptyListErrMsg : String -> String
emptyListErrMsg funcName = "Cannot compute the " ++ funcName ++ " of an empty list."

{-| Calculates the arithmetic mean of a list of numbers.
-}
mean : List Float -> Result String Float
mean xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "mean"
  else
    Ok <| (List.sum xs) / (lengthf xs)

{-| Calculates the geometric mean of a list of numbers.
See https://en.wikipedia.org/wiki/Geometric_mean for a definition.
-}
geometricMean : List Float -> Result String Float
geometricMean xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "geometric mean"
  else
    Ok <| (List.product xs) ^ (1 / lengthf xs)

{-| Calculates the harmonic mean of a list of numbers.
See https://en.wikipedia.org/wiki/Harmonic_mean for a definition.
-}
harmonicMean : List Float -> Result String Float
harmonicMean xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "harmonic mean"
  else if List.any ((>=) 0) xs then
    Err <| "The harmonic mean is defined only for lists of numbers strictly greater than zero."
  else
    let
      sumReciprocals = xs |> List.map ((/) 1) |> List.sum
    in
      Ok <| lengthf xs / sumReciprocals
