Creatinine Reverification
========================================================

This program implements calculations and plotting commands for annual reverification of creatinine screening on the Hitachi 717 automated chemistry analyzer.

**Author** David Watson  
**email** [dewatson@icloud.com](mailto:dewatson@icloud.com)  
**Copyright** (c) 2014, David Watson  

```r
timestamp()
```

```
## ##------ Thu Feb 27 13:24:51 2014 ------##
```



```r
setwd("../")
# Load common utility functions
source("bin/common.R")
getwd()
```

```
## [1] "/Volumes/6624738003/ELI/Reverification/2014"
```


Read in creatinine data and register column names:


```r
getwd()
```

```
## [1] "/Volumes/6624738003/ELI/Reverification/2014/reports"
```

```r
cRdata <- read.csv("data/cR.csv", header = TRUE, colClasses = c("character", 
    "factor", "numeric"))
```

```
## Warning: cannot open file 'data/cR.csv': No such file or directory
```

```
## Error: cannot open the connection
```

```r
attach(cRdata)
```

```
## Error: object 'cRdata' not found
```


Verify that the sample number, ID, and response are correct:

```r
cRdata
```

```
## Error: object 'cRdata' not found
```


Calculate the mean, SD, and CV for each level

```r
crMeans <- aggregate(Response, by = list(ID), mean)
```

```
## Error: object 'Response' not found
```

```r
colnames(crMeans) <- c("ID", "mean")
```

```
## Error: object 'crMeans' not found
```

```r
crStdDev <- aggregate(Response, by = list(ID), stddev)
```

```
## Error: object 'Response' not found
```

```r
colnames(crStdDev) <- c("ID", "SD")
```

```
## Error: object 'crStdDev' not found
```

```r
crCV <- aggregate(Response, by = list(ID), cv)
```

```
## Error: object 'Response' not found
```

```r
colnames(crCV) <- c("ID", "CV")
```

```
## Error: object 'crCV' not found
```


Group statistics:

```r
merge(merge(crMeans, crStdDev), crCV)
```

```
## Error: object 'crMeans' not found
```

Unregister the cR data:

```r
detach(cRdata)
```

```
## Error: invalid 'name' argument
```


Read in carryover data and register column names:

```r
lowCOdata <- read.csv("data/cRlowCO.csv", header = TRUE, colClasses = c("character", 
    "character", "numeric", "logical"))
```

```
## Warning: cannot open file 'data/cRlowCO.csv': No such file or directory
```

```
## Error: cannot open the connection
```


Verify that the blank carryover sample numbers, IDs, and responses are correct:

```r
lowCOdata
```

```
## Error: object 'lowCOdata' not found
```


The decision point for this assay is 2.0
```
DecisionPoint <- 2.0
```

Select Armbruster ``normal'' and ``carryover candidate'' samples:

```r
D_norm <- subset(lowCOdata, Candidate == FALSE, select = Response)
```

```
## Error: object 'lowCOdata' not found
```

```r
D_cc <- subset(lowCOdata, Candidate == TRUE, select = Response)
```

```
## Error: object 'lowCOdata' not found
```


Carryover (%): 

```r
carryover(D_cc$Response, D_norm$Response)
```

```
## Error: object 'D_cc' not found
```

CV (%): 

```r
round(100 * sd(D_norm$Response)/mean(D_norm$Response), 1)
```

```
## Error: object 'D_norm' not found
```


An unpaired, two-sample t.test using unequal variance (Welch) is used to check
whether the difference in means is <0.4 (20% of the decision level)

```r
t.test(D_norm$Response, D_cc$Response, mu = 0.2 * DecisionPoint, alternative = "less")
```

```
## Error: object 'D_norm' not found
```


Read in high carryover data and register column names

```r
highCOdata <- read.csv("data/cRhighCO.csv", header = TRUE, colClasses = c("character", 
    "character", "numeric", "logical"))
```

```
## Warning: cannot open file 'data/cRhighCO.csv': No such file or directory
```

```
## Error: cannot open the connection
```

Verify that the high carryover sample numbers, IDs, and responses are correct:

```r
highCOdata
```

```
## Error: object 'highCOdata' not found
```


Select Armbruster ``normal'' and ``carryover candidate'' samples:

```r
D_norm <- subset(highCOdata, Candidate == FALSE, select = Response)
```

```
## Error: object 'highCOdata' not found
```

```r
D_cc <- subset(highCOdata, Candidate == TRUE, select = Response)
```

```
## Error: object 'highCOdata' not found
```


Carryover (%): 

```r
carryover(D_cc$Response, D_norm$Response)
```

```
## Error: object 'D_cc' not found
```


CV of normal decision point samples: 

```r
round(100 * sd(D_norm$Response)/mean(D_norm$Response), 1)
```

```
## Error: object 'D_norm' not found
```


An unpaired, two-sample t.test using unequal variance (Welch) is used to check
whether the difference in means is <0.4 (20% of the decision level)

```r
t.test(D_cc$Response, D_norm$Response, mu = 0.2 * DecisionPoint, alternative = "less")
```

```
## Error: object 'D_cc' not found
```


Read in cross-reactivity data:

```r
crossrx <- read.csv("data/cRCR.csv", header = TRUE)
```

```
## Warning: cannot open file 'data/cRCR.csv': No such file or directory
```

```
## Error: cannot open the connection
```


Calculate ascorbic acid cross-reactivity:

```r
ascorbicacid <- subset(crossrx, Analyte == "ascorbate", select = c(Concentration, 
    Response))
```

```
## Error: object 'crossrx' not found
```

```r
ascorbicacid$Concentration <- ascorbicacid$Concentration * 100
```

```
## Error: object 'ascorbicacid' not found
```

```r
attach(ascorbicacid)
```

```
## Error: object 'ascorbicacid' not found
```

```r
aa_fit <- lm(Response ~ Concentration)
```

```
## Error: object 'Response' not found
```

```r
aa_summary <- summary(aa_fit)
```

```
## Error: object 'aa_fit' not found
```

```r
aa_cross_reactivity <- 100 * 20 * coef(aa_fit)[2]/(20 - coef(aa_fit)[1])
```

```
## Error: object 'aa_fit' not found
```


Ascorbic acid cross-reactivity (%): 

```r
round(as.numeric(aa_cross_reactivity), 1)
```

```
## Error: object 'aa_cross_reactivity' not found
```


Ascorbic acid linear regression coefficients:

```r
aa_fit$coefficients
```

```
## Error: object 'aa_fit' not found
```

```r
detach(ascorbicacid)
```

```
## Error: invalid 'name' argument
```


Calculate niacin cross-reactivity:

```r
niacin <- subset(crossrx, Analyte == "niacin", select = c(Concentration, Response))
```

```
## Error: object 'crossrx' not found
```

```r
niacin$Concentration <- niacin$Concentration * 100
```

```
## Error: object 'niacin' not found
```

```r
attach(niacin)
```

```
## Error: object 'niacin' not found
```

```r
niacin_fit <- lm(Response ~ Concentration)
```

```
## Error: object 'Response' not found
```

```r
niacin_summary <- summary(niacin_fit)
```

```
## Error: object 'niacin_fit' not found
```

```r
niacin_cross_reactivity <- 100 * 20 * coef(niacin_fit)[2]/(20 - coef(niacin_fit)[1])
```

```
## Error: object 'niacin_fit' not found
```

Niacin cross-reactivity (%): 

```r
round(as.numeric(niacin_cross_reactivity), 1)
```

```
## Error: object 'niacin_cross_reactivity' not found
```


Niacin linear regression:

```r
niacin_fit$coefficients
```

```
## Error: object 'niacin_fit' not found
```

```r
detach(niacin)
```

```
## Error: invalid 'name' argument
```


Save cross-reactivity data for plots:


```r
save(ascorbicacid, aa_fit, aa_summary, niacin, niacin_fit, niacin_summary, file = "data/cRCR.Rdata")
```

```
## Error: object 'ascorbicacid' not found
```

