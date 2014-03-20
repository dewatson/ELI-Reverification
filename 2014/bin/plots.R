# Install plotting and graphics libraries if TRUE
doInstall <- FALSE
toInstall <- c("ggplot2", "RGtk2", "Cairo")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
# Load the plotting and graphics libraries
lapply(toInstall, library, character.only = TRUE)

# Set up fonts for the plots
CairoFonts(
  regular="Myriad Pro:style=Regular",
  bold="Myriad Pro:style=Bold",
  italic="Myriad Pro:style=Italic",
  bolditalic="Myriad Pro:style=Bold Italic,BoldItalic",
  symbol="Symbol"
)

# Load creatinine and nitrite cross-reactivity data
load("data/cRCR.Rdata")
load("data/nTCR.Rdata")

# Plot ascorbic acid cross-reactivity
attach(ascorbicacid)
CairoPDF("plots/AAplot.pdf",family="Myriad Pro")
AAplot <- ggplot(ascorbicacid, aes(x=Concentration, y=Response, xmin = 0, ymin = 0))
AAplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(aa_fit)[1], slope = coef(aa_fit)[2], size=1.4, alpha=0.4) + 
  geom_abline(intercept = 2, slope = 0, linetype=3) +
  geom_abline(intercept = 20, slope = 0, linetype=3) +  
  labs(title="Ascorbic acid cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(aa_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(aa_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(aa_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(aa_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(ascorbicacid)

# Plot ascorbic acid cross-reactivity
attach(niacin)
CairoPDF("plots/Niacinplot.pdf",family="Myriad Pro")
Niacinplot <- ggplot(niacin, aes(x=Concentration, y=Response, xmin = 0, ymin = 0))
Niacinplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(niacin_fit)[1], slope = coef(niacin_fit)[2], size=1.4, alpha=0.4) + 
  geom_abline(intercept = 2, slope = 0, linetype=3) +
  geom_abline(intercept = 20, slope = 0, linetype=3) +  
  labs(title="Niacin cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(niacin_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(niacin_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(niacin_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(niacin_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(niacin)

# Plot permanganate cross-reactivity
attach(permanganate)
CairoPDF("plots/KMNO4plot.pdf",family="Myriad Pro")
KMNO4plot <- ggplot(permanganate, aes(x=Concentration, y=Response, xmin = 0, ymin = 0))
KMNO4plot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(permanganate_fit)[1], slope = coef(permanganate_fit)[2], size=2, alpha=0.4) + 
  geom_abline(intercept = 200, slope = 0, linetype=3) +  
  labs(title="Permanganate cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(permanganate_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(permanganate_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(permanganate_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(permanganate_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(permanganate)

# Plot PCC cross-reactivity
attach(pcc)
CairoPDF("plots/PCCplot.pdf",family="Myriad Pro")
PCCplot <- ggplot(pcc, aes(x=Concentration, y=Response, xmin = 0, ymin = 0))
PCCplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(pcc_fit)[1], slope = coef(pcc_fit)[2], size=2, alpha=0.4) + 
  geom_abline(intercept = 200, slope = 0, linetype=3) +  
  labs(title="PCC cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(pcc_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(pcc_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(pcc_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(pcc_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(pcc)

# Plot dichromate cross-reactivity
attach(dichromate)
CairoPDF("plots/dichromateplot.pdf",family="Myriad Pro")
dichromateplot <- ggplot(dichromate, aes(x=Concentration, y=Response, xmin = 0, ymin = 0, ymax=220))
dichromateplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(dichromate_fit)[1], slope = coef(dichromate_fit)[2], size=2, alpha=0.4) + 
  geom_abline(intercept = 200, slope = 0, linetype=3) +  
  labs(title="Dichromate cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(dichromate_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(dichromate_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(dichromate_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(dichromate_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(dichromate)

# Plot iodine cross-reactivity
attach(iodine)
CairoPDF("plots/iodineplot.pdf",family="Myriad Pro")
iodineplot <- ggplot(iodine, aes(x=Concentration, y=Response, xmin = 0, ymin = 0, ymax=220))
iodineplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(iodine_fit)[1], slope = coef(iodine_fit)[2], size=2, alpha=0.4) + 
  geom_abline(intercept = 200, slope = 0, linetype=3) +  
  labs(title="Iodine cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(iodine_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(iodine_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(iodine_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(iodine_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(iodine)

# Plot hypochlorite cross-reactivity
attach(hypochlorite)
CairoPDF("plots/hypochloriteplot.pdf",family="Myriad Pro")
hypochloriteplot <- ggplot(hypochlorite, aes(x=Concentration, y=Response, xmin = 0, ymin = 0, ymax=220))
hypochloriteplot + 
  geom_point(size=3) + 
  theme_classic(base_size = 18, base_family="Myriad Pro") + 
  geom_abline(intercept = coef(hypochlorite_fit)[1], slope = coef(hypochlorite_fit)[2], size=2, alpha=0.4) + 
  geom_abline(intercept = 200, slope = 0, linetype=3) +  
  labs(title="Hypochlorite cross-reactivity") + 
  theme(plot.title = element_text(family = "Myriad Pro Semibold")) +
  annotate("text", x = Concentration[3], y = 0, 
           label=paste(
             "RSD:  ", 
             round(hypochlorite_summary$sigma, digits = 5), "\n",
             "r:  ", round(sqrt(hypochlorite_summary$r.squared), digits = 5), "\n",
             "m:  ", round(coef(hypochlorite_fit)[2], digits = 5), "\n",
             "b:  ", round(coef(hypochlorite_fit)[1], digits = 5),
             sep=""
           ),
           hjust=1, vjust=0)
dev.off()
detach(hypochlorite)