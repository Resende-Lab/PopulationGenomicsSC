############################################################################################
### Plotting the H2 for the paper: 
### "The Evolution of Starch Biosynthesis During Post-Domestication Improvement in Sweet Corn"
### 
### Dr. Marco Peixoto
### Last version: Aug, 2026
############################################################################################

rm(list=ls())


###-----------------------------------
####---- 1. Packages
###-----------------------------------

library(dplyr)
library(ggplot2)
library("ggridges")
theme_set(theme_minimal())


###-----------------------------------
####---- 3. Traits
###-----------------------------------


dat <- read.table("../Data/dataH2.txt")

colnames(dat) <- c("Trait", "Heritability", "Year")




dat$Year <- as.factor(dat$Year)

####::::::::::::::::::::::::::::::::::::::::::::

tiff("1.Figure_1.tiff", width = 18, height = 10, units = 'in', res = 300)

ggplot(dat, aes(Trait, Heritability, color = Year)) +
  geom_point(size = 18, alpha = 1, shape = 20)+
  scale_color_manual(values = c("22" = "#ACA4E2",   # Assign a color to each combination
                                "21" = "blue",
                                "19" = "wheat")) +  # Customize as needed
   theme(panel.grid.minor=element_blank(),
        panel.grid.major.y=element_line(colour = "gray80", size = 0.5, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "gray80", size = 0.5, linetype="dotted"),
        plot.title = element_text(size = 23, hjust = 0.9, face = "bold"),
        legend.title = element_blank(),
        legend.text = element_text(size=16),
        legend.position = "bottom",
        legend.key.width =   unit(3, 'cm'),
        axis.line = element_line(color = "black", size = 0.5),
        axis.text.x =  element_text(size = 14,colour = "black", angle = 45, face = "bold", hjust = 0.9),
        axis.text.y.left = element_text(size = 18,colour = "black"),
        axis.text.y.right =  element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 20, face = "bold") )
dev.off()




