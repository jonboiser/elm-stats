# elm-stats
A port of simple statistics to Elm

## Modules

### Stats: Common statistical calculations of central tendency and spread.

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

### Stats.Distributions: Simulating random processes from different distributions.

* sample
* (r/d/p/q) bernoulli
* (r/d/p/q) binomial
* (r/d/p/q) poisson
* (r/d/p/q) gaussian

### Stats.Tests: Common statistical tests (e.g. t-test, chi-squared).

### Stats.Learning: Algorithms for statistical learning and classification.

* BayesianClassifier
* PerceptronModel
* linearRegression
* linearRegressionLine
* ckmeans

### Stat.Util: Utility functions that don't fit in the other modules.

* chunk
