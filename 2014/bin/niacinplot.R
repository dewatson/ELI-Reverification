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