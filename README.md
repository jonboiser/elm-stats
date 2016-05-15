# elm-stats
A port of simple statistics to Elm

## Modules

### Stats
Common statistical calculations of central tendency and spread.

#### Done

* mad
* median
* geometricMean
* harmonicMean
* mean
* mode
* min
* max
* variance
* quantile

## TODO
* quantileSorted
* standardDeviation
* rootMeanSquare
* sortedUniqueCount
* sampleCorrelation
* sampleCovariance
* sampleSkewness
* sampleStandardDeviation

### Stats.Distribution

Simulating random processes from different distributions.

#### Distributions
* Bernoulli
* Binomial
* Poisson
* Gaussian
* Uniform

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
-- randomN : Seed -> Int -> Distribution -> List (Event)
randomVals = randomN 100
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

### Stats.Tests

Common statistical tests (e.g. t-test, chi-squared).

### Stats.Learning

Algorithms for statistical learning and classification.

* BayesianClassifier
* PerceptronModel
* linearRegression
* linearRegressionLine
* ckmeans

### Stat.Util

Utility functions that don't fit in the other modules.

* chunk
