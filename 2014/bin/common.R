# Utility functions for pretty printing the SD and CV
stddev <- function(response) {
  round(sd(response), 2)
}

cv <- function(response) {
  round(100 * sd(response)/
          mean(response), 1)
}

# Utility function to calculate percent carryover
carryover <- function(carryoverSamples, normalSamples) {
  round(100 * (mean(carryoverSamples) - mean(normalSamples))/
          mean(normalSamples),1)
}