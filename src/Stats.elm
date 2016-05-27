module Stats exposing (mean, geometricMean, harmonicMean, median, maximum, minimum, mad, variance)

import Array exposing (Array)


type alias Sample =
    List Float


type alias Statistic =
    Result String Float


lengthf : List a -> Float
lengthf =
    toFloat << List.length


emptyListErrMsg : String -> Result String a
emptyListErrMsg funcName =
    Err <| "Cannot compute the " ++ funcName ++ " of an empty list."


{-| Returns the arithmetic mean of a List of numbers.

    mean [1..5] = Ok 3
    mean [1, 1, -1, 1] = Ok 0.5
    mean [] = Err "Cannot compute the mean of an empty list."
-}
mean : Sample -> Statistic
mean xs =
    case xs of
        [] ->
            emptyListErrMsg "mean"

        _ ->
            Ok <| (List.sum xs) / (lengthf xs)


{-| Returns the geometric mean of a List of numbers.
See https://en.wikipedia.org/wiki/Geometric_mean for a definition.

    geometricMean [1..5] = Ok 2.605171084697352
    geometricMean [1, 1, 1] = Ok 1
    geometricMean [0..5] = Ok 0
    geometricMean [-1..5] = Err "The geometric mean is defined only for lists of numbers greater than or equal to zero."
-}
geometricMean : Sample -> Statistic
geometricMean xs =
    if List.isEmpty xs then
        emptyListErrMsg "geometric mean"
    else if List.any ((>) 0) xs then
        Err <| "The geometric mean is defined only for lists of numbers greater than or equal to zero."
    else
        Ok <| (List.product xs) ^ (1 / lengthf xs)


{-| Returns the harmonic mean of a List of numbers.
See https://en.wikipedia.org/wiki/Harmonic_mean for a definition.

    harmonicMean [1..5] = Ok 2.18978102189781
    harmonicMean [1, 1, 1] = Ok 1
    harmonicMean [0..5] = Err "The geometric mean is defined only for lists of numbers greater than or equal to zero."
-}
harmonicMean : Sample -> Statistic
harmonicMean xs =
    if List.isEmpty xs then
        emptyListErrMsg "harmonic mean"
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

    maximum [10, 4, 2, -3] = Ok 10
    maximum [(-10)..(-5)] = Ok -5
    maximum [] = Err "Cannot compute the maximum of an empty list."
-}
maximum : Sample -> Statistic
maximum xs =
    case (List.maximum xs) of
        Just m ->
            Ok m

        Nothing ->
            emptyListErrMsg "maximum"


{-| Returns the smallest number in a list. Wraps List.minimum to return
a Result type like the other functions.

    minimum [10, 4, 2, -3] = Ok -3
    minimum [(-10)..(-5)] = Ok -10
    minimum [] = Err "Cannot compute the minimum of an empty list."
-}
minimum : Sample -> Statistic
minimum xs =
    case (List.minimum xs) of
        Just m ->
            Ok m

        Nothing ->
            emptyListErrMsg "minimum"


{-| Returns the median of a list of numbers. An alias for (quantile 0.5).

    median [1..5] = Ok 3
    median [1..6] = Ok 3.5
    median [] = Err "Cannot compute the median of an empty list."
-}
median : Sample -> Statistic
median xs =
    if List.isEmpty xs then
        emptyListErrMsg "median"
    else
        quantile 0.5 xs


{-| Returns the MAD (median absolute deviation) of a list of numbers

    mad [1..5] = Ok 1
    mad [1, 1, 1] = Ok 0
    mad [(-4)..4] = Ok 2
    mad [] = Err "Cannot compute the mean absolute deviation of an empty list."
-}
mad : Sample -> Statistic
mad xs =
    if List.isEmpty xs then
        emptyListErrMsg "mean absolute deviation"
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
                minimum xs
            else if p == 1 then
                maximum xs
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
        Result.fromMaybe "Error computing the quantile." yhat
