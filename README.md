# elm-stats
Statistics for Elm. Some of its API is borrowed from the [Simple Statistics](http://simplestatistics.org/) for JavaScript.

## Modules

### `Stats`

Functions for measuring the central tendency and spread of sample data.

#### Type aliases
User-provided data is assumed to be real-valued (i.e. represented by floating-point numbers).

* `Sample = List Float`
* `Stat = Result.Result String Float`

#### Functions

Released in 1.0:
* geometricMean
* harmonicMean
* mad (mean absolute deviation)
* max
* mean
* median
* min
* mode
* quantile
* quantileSorted
* rootMeanSquare
* standardDeviation
* variance

TODO for 1.1:
* sortedUniqueCount
* sampleCorrelation
* sampleCovariances
* sampleSkewness
* sampleStandardDeviation

### `Stats.Distribution`

Will aim to release in 1.2, or soon thereafter. Simulating random processes from different distributions.

#### Distributions
* Bernoulli
* Binomial
* Poisson
* Gaussian
* Uniform

#### Functions
* for sampling
* for converting between `Event`s and `Float`
* for sampling directly to `Float`

#### WIP API for sampling
```{elm}
import Stats.Distribution exposing(Distribution(Uniform))
import Random.Pcg exposing(initialSeed)

-- Create a Uniform(0, 1) Distribution
unif : Distribution
unif = Uniform 0 1

-- Set the seed
seed0 : Seed
seed0 = initialSeed 12345

-- Generate one random value with new seed for next iteration
(x1, seed1) = random1 seed unif

-- Next value
(x2, seed2) = random1 seed1 unif
sampleFromProcess : Distribution a -> Int -> List a

-- TODO a convenience method that wraps the above process
-- randomN : Seed -> Distribution -> Int -> List (Event)
genRandomVals = randomN seed0 unif
genRandomVals 100 == [Binary True, Binary False, ...]
```


#### WIP API for calculating pdf/cdf values
```{elm}
-- pdf : Distribution -> Event -> Float
-- cdf : Distribution -> Event -> Float

-- Create a Distribution
bern60percent : Distribution
bern60percent = Bernoulli 0.6

-- Partially apply `pdf` to get specific pdf for `bern60percent`
bernPdf : Event -> Float
bernPdf = pdf bernX

-- Invoke `bernPdf` events to get their densities
bernPdf (Binary True) == 0.6
bernPdf (Binary False) == 0.4
```

### `Stats.Util`
Functions that don't really fit in any of the other modules.
* chunk

### `Stats.Inference`

Common statistical tests (e.g. t-test, chi-squared).

### `Stats.Learning`

Algorithms for statistical learning and classification.

* BayesianClassifier
* PerceptronModel
* linearRegression
* linearRegressionLine
* ckmeans
