module Stats exposing (..)


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
max : List comparable -> Result String comparable
max xs =
  case (List.maximum xs) of
    Just m ->
      Ok m

    Nothing ->
      Err <| emptyListErrMsg "maximum"


{-| Returns the smallest number in a list. Wraps List.minimum to return
a Result type like the other functions.
-}
min : List comparable -> Result String comparable
min xs =
  case (List.minimum xs) of
    Just m ->
      Ok m

    Nothing ->
      Err <| emptyListErrMsg "minimum"


{-| Returns the median of a list of numbers.
-}
median : List Float -> Result String Float
median xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "median"
  else
    let
      n =
        List.length xs

      xsSorted =
        List.sort xs

      middleVals =
        if (n % 2 == 0) then
          xsSorted
            |> List.drop (n // 2 - 1)
            |> List.take 2
        else
          xsSorted
            |> List.drop (n // 2)
            |> List.take 1
    in
      Result.map Basics.identity (mean middleVals)

{-| Returns the MAD (median absolute deviation) of a list of numbers
-}
mad : List Float -> Result String Float
mad xs =
  if List.isEmpty xs then
    Err <| emptyListErrMsg "mean absolute deviation"
  else
    let
      subtractedFromMedian m =
        List.map (\x -> Basics.abs (x - m)) xs

      deviations =
        Result.map subtractedFromMedian (median xs)
    in
      Result.andThen deviations median


type alias Comp a = Result String a

{-| Returns the variance of a list of numbers
-}
variance : List Float -> Comp Float
variance xs =
  let
    d = (lengthf xs) - 1

    subtractFromMean : Comp Float -> List Float
    subtractFromMean m =
      case m of
        Ok mu -> List.map (\x -> (x - mu)^2) xs
        Err _ -> []

    sub = subtractFromMean (mean xs)
  in
    if List.isEmpty sub then
      Err ""
    else
      Ok <| (List.foldr (+) 0 sub) / d
