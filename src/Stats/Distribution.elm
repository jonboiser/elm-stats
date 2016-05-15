module Stats.Distribution exposing (..)


import Random.Pcg exposing (..)

type Distribution
    = Bernoulli Float
    | Binomial Float Int
    | Gaussian Float Float
    | Poisson Float
    | Uniform Float Float


type Event
    = Binary Bool
    | Continuous Float
    | Discrete Int


randomEvent : Seed -> Distribution -> (Event, Seed)
randomEvent seed dist =
    case dist of
        Bernoulli p ->
            (Binary True, seed)

        Binomial p n ->
            (Discrete 0, seed)

        Gaussian mu sigma ->
            (Continuous 0, seed)

        Poisson lambda ->
            (Continuous 0, seed)

        Uniform a b ->
            let
                (x, newSeed) = step (float a b) seed
            in
                (Continuous x, newSeed)
