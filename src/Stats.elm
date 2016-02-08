module Stats (..) where

import List.Extra as LExtra


lengthf : List a -> Float
lengthf xs =
  List.length xs |> toFloat


emptyListErrMsg : String -> String
emptyListErrMsg funcName =
  "Cannot compute the " ++ funcName ++ " of an empty list."


{-| Returns the arithmetic mean of a list of numbers.
-}
mean : List Float -> Result String Float
mean xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "mean"
  else
    Ok <| (List.sum xs) / (lengthf xs)


{-| Returns the geometric mean of a list of numbers.
See https://en.wikipedia.org/wiki/Geometric_mean for a definition.
-}
geometricMean : List Float -> Result String Float
geometricMean xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "geometric mean"
  else
    Ok <| (List.product xs) ^ (1 / lengthf xs)


{-| Returns the harmonic mean of a list of numbers.
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
      sumReciprocals =
        xs |> List.map ((/) 1) |> List.sum
    in
      Ok <| lengthf xs / sumReciprocals


{-| Returns the largest number in a list. Wraps List.maximum to return
a Result type like the other functions.
-}
max : List Float -> Result String Float
max xs =
  case (List.maximum xs) of
    Just m ->
      Ok m

    Nothing ->
      Err "Maximum is not defined for empty lists."


{-| Returns the smallest number in a list. Wraps List.minimum to return
a Result type like the other functions.
-}
min : List Float -> Result String Float
min xs =
  case (List.minimum xs) of
    Just m ->
      Ok m

    Nothing ->
      Err "Minimum is not defined for empty lists."
