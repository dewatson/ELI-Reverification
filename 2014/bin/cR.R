##
# cR.R
#
# Implements validation methodology for creatinine reverification
#
# author    David Watson
# email     dewatson@icloud.com
# copyright Copyright (c) 2014, David Watson
#
##

setwd("../")
# Load common utility functions
source("bin/common.R")
# Record results to an output file
outFile <- file("results/cRvalidation.txt", open = "wt")
sink(outFile, append = FALSE)
timestamp()

# Read in creatinine data and register column names
cRdata <- read.csv("data/cR.csv",
                   header = TRUE,
                   colClasses = 
                     c("character","factor","numeric"))
attach(cRdata)

# Verify that the sample number, ID, and response are correct
cat("", "Creatinine Validation", "", "Sample Data:", sep="\n")
cRdata

# Calculate the mean, SD, and CV for each level
crMeans <- aggregate(Response, by = list(ID), mean)
colnames(crMeans) <- c("ID", "mean")
crStdDev <- aggregate(Response, by = list(ID), stddev)
colnames(crStdDev) <- c("ID", "SD")
crCV <- aggregate(Response, by = list(ID), cv)
colnames(crCV) <- c("ID", "CV")

# Unregister the cR data
detach(cRdata)

# Build a table of the group statistics
cat("", "Statistics:", sep = "\n")
merge(merge(crMeans, crStdDev), crCV)

# Read in carryover data and register column names
lowCOdata <- read.csv("data/cRlowCO.csv",
                      header = TRUE,
                      colClasses =
                        c("character","character","numeric","logical"))

# Verify that the sample number, ID, and response are correct
cat("", "Blank carryover data:", sep = "\n")
lowCOdata

# Assign the decision point
DecisionPoint <- 2.0

# Select Armbruster "normal" samples
D_norm <- subset(lowCOdata, Candidate == FALSE, select = Response)
# Select Armbruster "carryover candidate" samples
D_cc <- subset(lowCOdata, Candidate == TRUE, select = Response)
# Calculate the carryover
cat("\n", "Carryover (%): ", sep = "")
write(carryover(D_cc$Response, D_norm$Response), "")

# Calculate the CV of the normal samples
cat("\n", "CV of normal decision point samples: ", sep = "")
write(round(100 * sd(D_norm$Response)/ mean(D_norm$Response), 1), "")

# Unpaired, two-sample t.test using unequal variance (Welch): check
# whether the difference in means is <0.4 (20% of the decision level)
t.test(D_norm$Response,
       D_cc$Response,
       mu = 0.2 * DecisionPoint,
       alternative="less")

# Read in carryover data and register column names
highCOdata <- read.csv('data/cRhighCO.csv',
                       header = TRUE,
                       colClasses = 
                         c("character","character","numeric","logical"))
# Verify that the sample number, ID, and response are correct
cat("", "High carryover data:", sep = "\n")
highCOdata

# Select Armbruster "normal" samples
D_norm <- subset(highCOdata, Candidate == FALSE, select = Response)
# Select Armbruster "carryover candidate" samples
D_cc <- subset(highCOdata, Candidate == TRUE, select = Response)
cat("\n", "Carryover (%): ", sep = "")
write(carryover(D_cc$Response, D_norm$Response), "")

# Calculate the CV of the normal samples
cat("\n", "CV of normal decision point samples: ", sep = "")
write(round(100 * sd(D_norm$Response)/ mean(D_norm$Response), 1), "")

# Unpaired, two-sample t.test using unequal variance (Welch): check
# whether the difference in means is <0.4 (20% of the decision level)
t.test(D_cc$Response,
       D_norm$Response,
       mu = 0.2 * DecisionPoint,
       alternative = "less")

# Read in cross-reactivity data
crossrx <- read.csv('data/cRCR.csv',
                    header = TRUE)

# Calculate ascorbic acid cross-reactivity
ascorbicacid <- subset(crossrx,
                       Analyte == "ascorbate",
                       select = c(Concentration, Response))
ascorbicacid$Concentration <- ascorbicacid$Concentration * 100
attach(ascorbicacid)
aa_fit <- lm(Response ~ Concentration)
aa_summary <- summary(aa_fit)
aa_cross_reactivity <-
  100 * 20 * coef(aa_fit)[2]/(20.0 - coef(aa_fit)[1])
cat("\n", "Ascorbic acid cross-reactivity (%): ", sep = "")
write(round(as.numeric(aa_cross_reactivity), 1), "")
cat("", "Ascorbic acid linear regression: ", sep = "\n")
aa_fit$coefficients
detach(ascorbicacid)

# Calculate niacin cross-reactivity
niacin <- subset(crossrx,
                 Analyte == "niacin",
                 select = c(Concentration, Response))
niacin$Concentration <- niacin$Concentration * 100
attach(niacin)
niacin_fit <- lm(Response ~ Concentration)
niacin_summary <- summary(niacin_fit)
niacin_cross_reactivity <-
  100 * 20 * coef(niacin_fit)[2]/(20.0 - coef(niacin_fit)[1])
cat("\n", "Niacin cross-reactivity (%): ", sep = "")
write(round(as.numeric(niacin_cross_reactivity), 1), "")
cat("", "Niacin linear regression:", sep = "\n")
niacin_fit$coefficients
detach(niacin)

# Save cross-reactivity data for plots
save(ascorbicacid,
     aa_fit,
     aa_summary,
     niacin,
     niacin_fit,
     niacin_summary,
     file="data/cRCR.Rdata"
)

# Close output redirection and results file
sink()
close(outFile)