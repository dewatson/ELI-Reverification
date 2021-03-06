# Load common utility functions
source("bin/common.R")
# Record results to an output file
outFile <- file("results/nTvalidation.txt", open = "wt")
sink(outFile, append = FALSE)
timestamp()

# Read in nitrite data and register column names
nTdata <- read.csv("data/nT.csv", 
                   header = TRUE,
                   colClasses = 
                     c("character","factor","numeric"))
attach(nTdata)

# Verify that the sample number, ID, and response are correct
cat("", "Nitrite Validation", "", "Sample Data:", sep="\n")
nTdata

# Calculate the mean, SD, and CV for each level
ntMeans <- aggregate(Response, by=list(ID), mean)
colnames(ntMeans) <- c("ID", "mean")
ntStdDev <- aggregate(Response, by=list(ID), stddev)
colnames(ntStdDev) <- c("ID", "SD")
ntCV <- aggregate(Response, by=list(ID), cv)
colnames(ntCV) <- c("ID", "CV")

# Unregister the nT data
detach(nTdata)

# Build a table of the group statistics
cat("", "Statistics:", sep = "\n")
merge(merge(ntMeans, ntStdDev), ntCV)

# Read in carryover data and register column names
COdata <- read.csv('data/nTCO.csv', 
                   header = TRUE,
                   colClasses = 
                     c("character","character","numeric","logical"))
# Verify that the sample number, ID, and response are correct
cat("", "High carryover data:", sep = "\n")
COdata

# Assign the Decision Point
DecisionPoint <- 200

# Select Armbruster "normal" samples
D_norm <- subset(COdata, Candidate == FALSE, select=Response)
# Select Armbruster "carryover candidate" samples
D_cc <- subset(COdata, Candidate == TRUE, select=Response)
# Calculate the carryover
cat("\n", "Carryover (%): ", sep = "")
write(carryover(D_cc$Response, D_norm$Response), "")

# Calculate the CV of the normal samples
cat("\n", "CV of normal decision point samples: ", sep = "")
write(round(100 * sd(D_norm$Response)/ mean(D_norm$Response), 1), "")

# Unpaired, two-sample t.test using unequal variance (Welch):
#   check whether the difference in means is <40 (20% of
#   the decision level)
t.test(D_cc$Response, 
       D_norm$Response, 
       mu = 0.2 * DecisionPoint, 
       alternative = "less"
       )

# Read in cross-reactivity data
crossrx <- read.csv('data/nTCR.csv', 
                    header = TRUE)

# Calculate permanganate cross-reactivity
permanganate <- subset(crossrx, 
                       Analyte == "permanganate", 
                       select = c(Concentration, Response)
                       )
attach(permanganate)
permanganate_fit <- lm(Response ~ Concentration)
permanganate_summary <- summary(permanganate_fit)
pct_permanganate_cr <- 
  100 * 200 * coef(permanganate_fit)[2]/ (200 - coef(permanganate_fit)[1])
cat("\n", "Permanganate cross-reactivity (%): ", sep = "")
write(round(pct_permanganate_cr, 1), "")
cat("", "Permanganate linear regression: ", sep = "\n")
permanganate_fit$coefficients
detach(permanganate)

# Calculate PCC cross-reactivity
pcc <- subset(crossrx, 
              Analyte == "pcc", 
              select = c(Concentration, Response))
attach(pcc)
pcc_fit <- lm(Response ~ Concentration)
pcc_summary <- summary(pcc_fit)
pct_pcc_cr <- 
  100 * 200 * coef(pcc_fit)[2]/ (200 - coef(pcc_fit)[1])
cat("\n", "PCC cross-reactivity (%): ", sep = "")
write(round(pct_pcc_cr, 1), "")
cat("", "PCC linear regression: ", sep = "\n")
pcc_fit$coefficients
detach(pcc)

# Calculate dichromate cross-reactivity
dichromate <- subset(crossrx, 
                     Analyte == "dichromate", 
                     select = c(Concentration, Response))
attach(dichromate)
dichromate_fit <- lm(Response ~ Concentration)
dichromate_summary <- summary(dichromate_fit)
pct_dichromate_cr <- 
  100 * 200 * coef(dichromate_fit)[2]/ (200 - coef(dichromate_fit)[1])
cat("\n", "Dichromate cross-reactivity (%): ", sep = "")
write(round(pct_dichromate_cr, 1), "")
cat("", "Dichromate linear regression: ", sep = "\n")
dichromate_fit$coefficients
detach(dichromate)

# Calculate iodine cross-reactivity
iodine <- subset(crossrx, 
                 Analyte == "iodine", 
                 select = c(Concentration, Response))
iodine$Concentration <- 1000 * iodine$Concentration
attach(iodine)
iodine_fit <- lm(Response ~ Concentration)
iodine_summary <- summary(iodine_fit)
pct_iodine_cr <- 
  100 * 200 * coef(iodine_fit)[2]/ (200 - coef(iodine_fit)[1])
cat("\n", "Iodine cross-reactivity (%): ", sep = "")
write(round(pct_iodine_cr, 1), "")
cat("", "Iodine linear regression: ", sep = "\n")
iodine_fit$coefficients
detach(iodine)

# Calculate hypochlorite cross-reactivity
hypochlorite <- subset(crossrx, 
                       Analyte == "hypochlorite", 
                       select = c(Concentration, Response))
naocl_mw <- 74.44
ocl_mw <- 51.45
hypochlorite$Concentration <- 
  10000 * hypochlorite$Concentration * ocl_mw / naocl_mw
attach(hypochlorite)
hypochlorite_fit <- lm(Response ~ Concentration)
hypochlorite_summary <- summary(hypochlorite_fit)
pct_hypochlorite_cr <- 
  100 * 200 * coef(hypochlorite_fit)[2]/ (200 - coef(hypochlorite_fit)[1])
cat("\n", "Hypochlorite cross-reactivity (%): ", sep = "")
write(round(pct_hypochlorite_cr, 1), "")
cat("", "Hypochlorite linear regression: ", sep = "\n")
hypochlorite_fit$coefficients
detach(hypochlorite)

# Save cross-reactivity data for plots
save(permanganate,
     permanganate_fit, 
     permanganate_summary,
     pcc,
     pcc_fit, 
     pcc_summary,
     dichromate,
     dichromate_fit, 
     dichromate_summary,
     iodine,
     iodine_fit, 
     iodine_summary,
     hypochlorite,
     hypochlorite_fit, 
     hypochlorite_summary, 
     file="data/nTCR.Rdata"
)

# Close output redirection and results file
sink()
close(outFile)