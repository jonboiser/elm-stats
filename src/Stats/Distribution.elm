module Stats.Distribution exposing (..)


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


randomEvent : Distribution -> Event
randomEvent dist =
    case dist of
        Bernoulli p ->
            Binary True

        Binomial p n ->
            Discrete 0

        Gaussian mu sigma ->
            Continuous 0

        Poisson lambda ->
            Continuous 0

        Uniform a b ->
            Continuous 0
