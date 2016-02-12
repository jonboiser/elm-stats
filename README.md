# elm-stats
A port of simple statistics to Elm

## Modules

### Stats

Common statistical calculations of central tendency and spread.

* mad
* mode
* variance
* quantile
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

* sample
* bernoulliProcess
* binomialProcess
* poissonProcess
* gaussianProcess

Possible API:

For sampling:
```{elm}
bernoulliProcess : Float -> Distribution Bool

sampleFromProcess : Distribution a -> Int -> List a

bernX : Distribution Bool = bernoulliProcess 0.4
sampleFromProcess bernX 10
-- Returns 10 IID Bernoulli samples from {True, False}
```

For getting PDF, CDF values:
```{elm}
pdf : Distribution a -> a -> Float
cdf : Distribution a -> a -> Float

bernPdf = pdf bernX
bernPdf True -- 0.4
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
