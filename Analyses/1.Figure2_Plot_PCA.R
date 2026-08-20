############################################################################################
### Plotting the PCA for the paper: 
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


###-----------------------------------
####---- 2. Colors
###-----------------------------------

group_cols <- c(
  "#E76F51",  # terracotta (replaces coral red)
  "#F4A259",  # orange
  "#F6EE8C",  # pale yellow
  "#A6D854",  # light green
  "#B2DF8A",  # sage green
  "#80B1D3",  # sky blue
  "#B3B3E6",  # lavender
  "#9E9AC8",  # blue-purple
  "#6A4C93",  # deep violet (replaces purple)
  "#E7B6D8",  # pink
  "#8DD3C7",  # turquoise
  "#FDB462",  # peach
  "#BC80BD",  # mauve
  "#CCEBC5"   # mint
)
###-----------------------------------
####---- 3. Traits
###-----------------------------------


dat <- read.table("../Data/4.EigenValues_5MSet.txt")

colnames(dat)[1:4] <- c("GenID", "GenID2", "PC1", "PC2")

df_eras <- read.csv("/Users/deamorimpeixotom/Library/CloudStorage/OneDrive-UniversityofFlorida/1.SweetCorn_PopGen/Submission/Supplementary_Material_S2.csv")


df1_eras <- df_eras[,c(3,5,6)]

###---- Renaming
df1_eras$clade.name[df1_eras$clade.name == "Golden_Bantam"] <- "Golden Bantam" 
df1_eras$clade.name[df1_eras$clade.name == "su1 admixed red"] <- "Admixed su1" 
df1_eras$clade.name[df1_eras$clade.name == "Ia453"] <- "Ia453" 
df1_eras$clade.name[df1_eras$clade.name == "sh2 admixed purple"] <- "Admixed purple sh2" 
df1_eras$clade.name[df1_eras$clade.name == "Stowells Evergreen"] <- "Stowell's Evergreen"
df1_eras$clade.name[df1_eras$clade.name == "IL Lines"] <- "IL lines"  
df1_eras$clade.name[df1_eras$clade.name == "IL14H"] <- "IL14H" 
df1_eras$clade.name[df1_eras$clade.name == "sh2 green"] <- "Green sh2" 
df1_eras$clade.name[df1_eras$clade.name == "sh2 admixed yellow"] <- "Admixed yellow sh2" 
df1_eras$clade.name[df1_eras$clade.name == "Conversions_MDMs"] <- "Conversions MDMs"
df1_eras$clade.name[df1_eras$clade.name == "admixed torquoise"] <- "Admixed torquoise"  
df1_eras$clade.name[df1_eras$clade.name == "tropical_old"] <- "Tropical old"
df1_eras$clade.name[df1_eras$clade.name == "Old sugaries"] <- "Old su1" 

table(df1_eras$clade.name)


colnames(df1_eras)[1] <- "GenID"

#### Merging
colnames(df1_eras)

df_plot = merge(df1_eras, dat)

#### Making sure the order is okay
df_plot$clade.name <- factor(
  df_plot$clade.name,
  levels = sort(unique(df_plot$clade.name))
)

legend_labels <- c(
  "Admixed purple sh2" = expression("Admixed purple " * italic(sh2)),
  "Admixed su1" = expression("Admixed " * italic(su1)),
  "Admixed torquoise" = "Admixed torquoise",
  "Admixed yellow sh2" = expression("Admixed yellow " * italic(sh2)),
  "Conversions MDMs" = "Conversions MDMs",
  "Golden Bantam" = "Golden Bantam",
  "Green sh2" = expression("Green " * italic(sh2)),
  "Ia453" = "Ia453",
  "IL lines" = "IL lines",
  "IL14H" = "IL14H",
  "Old su1" = expression("Old " * italic(su1)),
  "Stowell's Evergreen" = "Stowell's Evergreen",
  "Tropical old" = "Tropical old"
)

####::::::::::::::::::::::::::::::::::::::::::::
png("1.Figure_2.png", width = 18, height = 10, units = 'in', res = 300)
#svg("1.Figure_2v1.svg", width = 12, height = 10)

ggplot(df_plot, aes(PC1, PC2, fill = clade.name)) +
  geom_point(
    shape = 21,
    size = 10,
    color = "black",
    stroke = 0.4
  ) +
  scale_fill_manual(
    values = group_cols,
    labels = legend_labels
  ) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(
      colour = "gray80",
      size = 0.5,
      linetype = "dotted"
    ),
    panel.grid.major.x = element_line(
      colour = "gray80",
      size = 0.5,
      linetype = "dotted"
    ),
    legend.title = element_blank(),
    legend.text = element_text(size = 16),
    legend.position = "none",
    legend.key.width = unit(3, "cm"),
    axis.line = element_line(color = "black", size = 0.5),
    axis.text.x = element_text(size = 14, colour = "black", face = "bold"),
    axis.text.y.left = element_text(size = 14, colour = "black", face = "bold"),
    axis.title.x = element_text(size = 20, face = "bold"),
    axis.title.y = element_text(size = 20, face = "bold")
  ) +
  labs(
    x = "PC1 (34.9 %)",
    y = "PC2 (13.3 %)"
  )
dev.off()

