module Stats exposing (..)

import Array exposing (Array)


type alias Sample =
    List Float


type alias Statistic =
    Result String Float


lengthf : List a -> Float
lengthf =
    toFloat << List.length


emptyListErrMsg : String -> String
emptyListErrMsg funcName =
    "Cannot compute the " ++ funcName ++ " of an empty list."


{-| Returns the arithmetic mean of a List of numbers.
-}
mean : Sample -> Statistic
mean xs =
    case xs of
        [] ->
            Err <| emptyListErrMsg "mean"

        _ ->
            Ok <| (List.sum xs) / (lengthf xs)


{-| Returns the geometric mean of a List of numbers.
See https://en.wikipedia.org/wiki/Geometric_mean for a definition.
-}
geometricMean : Sample -> Statistic
geometricMean xs =
    case xs of
        [] ->
            Err <| emptyListErrMsg "geometric mean"

        _ ->
            Ok <| (List.product xs) ^ (1 / lengthf xs)


{-| Returns the harmonic mean of a List of numbers.
See https://en.wikipedia.org/wiki/Harmonic_mean for a definition.
-}
harmonicMean : Sample -> Statistic
harmonicMean xs =
    if List.isEmpty xs then
        Err <| emptyListErrMsg "harmonic mean"
    else if List.any ((>=) 0) xs then
        Err <| "The harmonic mean is defined only for lists of numbers strictly greater than zero."
    else
        let
            sumOfReciprocals =
                xs |> List.map ((/) 1.0) |> List.sum
        in
            Ok <| lengthf xs / sumOfReciprocals


{-| Returns the largest number in a list. Wraps List.maximum to return
a Result type like the other functions.
-}
max : Sample -> Statistic
max xs =
    case (List.maximum xs) of
        Just m ->
            Ok m

        Nothing ->
            Err <| emptyListErrMsg "maximum"


{-| Returns the smallest number in a list. Wraps List.minimum to return
a Result type like the other functions.
-}
min : Sample -> Statistic
min xs =
    case (List.minimum xs) of
        Just m ->
            Ok m

        Nothing ->
            Err <| emptyListErrMsg "minimum"


{-| Returns the median of a list of numbers.
-}
median : Sample -> Statistic
median =
    quantile 0.5


{-| Returns the MAD (median absolute deviation) of a list of numbers
-}
mad : Sample -> Statistic
mad xs =
    if List.isEmpty xs then
        Err <| emptyListErrMsg "mean absolute deviation"
    else
        let
            subtractedFromMedian m =
                List.map (\x -> abs (x - m)) xs

            deviations =
                Result.map subtractedFromMedian (median xs)
        in
            Result.andThen deviations median



-- Move to Util


subtractThenSquare : number -> List number -> List number
subtractThenSquare d xs =
    List.map (\x -> (x - d) ^ 2) xs


{-| Returns the variance of a List of numbers.
-}
variance : Sample -> Statistic
variance xs =
    case mean xs of
        Err err ->
            Err <| "Cannot compute the mean: " ++ err

        Ok mu ->
            let
                denom =
                    (lengthf xs) - 1

                sumOfDiffsSquared =
                    subtractThenSquare mu xs
                        |> List.sum
            in
                Ok <| sumOfDiffsSquared / denom


toProportion : Float -> Statistic
toProportion p =
    if p >= 0 && p <= 1 then
        Ok p
    else
        Err "A proportion must be between 0 and 1."


{-| Returns the value representing the boundary of the q-th quantile.
-}
quantile : Float -> Sample -> Statistic
quantile q xs =
    case toProportion q of
        Err err ->
            Err <| "Invalid value of q: " ++ err

        Ok p ->
            if p == 0 then
                min xs
            else if p == 1 then
                max xs
            else
                quantileByInterpolation p xs


interpolate : Float -> (Float -> Float -> Float)
interpolate x l r =
    l + x * (r - l)


{-| Calculate quantile from a sample via interpolation.
Corresponds to the default algorithm used in R's `quantile`.
-}
quantileByInterpolation : Float -> Sample -> Statistic
quantileByInterpolation q xs =
    let
        h =
            q * ((lengthf xs) - 1)

        idx =
            floor h

        sortedxs =
            Array.fromList (List.sort xs)

        q1 =
            Array.get idx sortedxs

        q2 =
            Array.get (idx + 1) sortedxs

        yhat =
            Maybe.map2 (interpolate (h - (toFloat idx))) q1 q2
    in
        Result.fromMaybe "" yhat
