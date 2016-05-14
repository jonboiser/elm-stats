module Stats.Distribution exposing (..)


type Distribution
    = Bernoulli Float
    | Gaussian Float Float
    | Binomial Float Int
    | Poisson Float
    | Uniform Float Float
