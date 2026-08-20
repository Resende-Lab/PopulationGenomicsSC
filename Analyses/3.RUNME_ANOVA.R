############################################################################################
### Running an ANOVA for the paper: 
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
library(tidyr)
library("agricolae")

### --- # Loading the Clades information
keyData = read.csv("../Data/5.Clades.csv")
keyData = keyData[!is.na(keyData$Group), ]


###-----------------------------------
####---- 2. Plotting BLUES distribution by clades
###-----------------------------------

# data coming from the multi-year
dfMTM = read.table(file = "../Data/2.Phenotypes_GxEModels.txt", h=T)[,-1]

# merging
dat1 <- merge(keyData, dfMTM, by = "vcfID", all.x = TRUE)

# Preparing

finalDat_mtm = pivot_longer(dat1, cols = !c(vcfID, Group), 
                        names_to= 'Trait', 
                        values_to= 'value')

finalDat_mtm$Group[finalDat_mtm$Group ==  "Modern_sh2-R"] <-  "Modern_sh2R"
finalDat_mtm$Group[finalDat_mtm$Group ==  "Modern_sh2-i"] <-  "Modern_sh2i"
finalDat_mtm$Group[finalDat_mtm$Group ==  "Old_su"] <-  "Old_su1"
table(finalDat_mtm$Group)

finalDat_mtm <- finalDat_mtm[grep("*_GxE", finalDat_mtm$Trait), ]
finalDat_mtm$Group <- factor(finalDat_mtm$Group, levels = c("Open_Pollinated", "Old_su1", "Modern_su1",  "Modern_sh2R", "Modern_sh2i"))


pdf("1.Figure1_S1_MTM.pdf", width = 18, height = 12)#, units = "cm", res = 300)

ggplot(finalDat_mtm, aes(x = Group, y = value, color = Group)) +
  geom_boxplot() +
  labs(x = " ", y = "Phenotypic Mean of Trait") +
  facet_wrap(~ Trait, scales = "free_y") +
  theme(axis.text.x =  element_blank(),
        axis.text.y.left = element_text(size = 12,colour = "black", face = "bold"),
        axis.title = element_text(size = 20, face = "bold"),
        panel.border = element_rect(colour = "black", fill = "transparent"),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(size=20),
        legend.title = element_blank(),
        strip.text = element_text(size = 12, face = "bold"))

dev.off()



#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

####>>>---- Data
df = read.table(file = "../Data/1.Phenotypes_bySeason.txt", h=T)[,-1]
df1 = df[1:58]


# merging
dat1 <- merge(keyData, df1, by = "vcfID")


finalDat = pivot_longer(dat1, cols = !c(vcfID, Group), 
                        names_to= 'Trait', 
                        values_to= 'value')

finalDat$Group[finalDat$Group ==  "Modern_sh2-R"] <-  "Modern_sh2R"
finalDat$Group[finalDat$Group ==  "Modern_sh2-i"] <-  "Modern_sh2i"
finalDat$Group[finalDat$Group ==  "Old_su"] <-  "Old_su1"
table(finalDat$Group)

finalDat$Group <- factor(finalDat$Group, levels = c("Open_Pollinated", "Old_su1", "Modern_su1",  "Modern_sh2R", "Modern_sh2i"))


pdf("1.Figure1_S1_STM.pdf", width = 18, height = 12)#, units = "cm", res = 300)

ggplot(finalDat, aes(x = Group, y = value, color = Group)) +
  geom_boxplot() +
  labs(x = " ", y = "Phenotypic Mean of Trait") +
  facet_wrap(~ Trait, scales = "free_y") +
  theme(axis.text.x =  element_blank(),
        axis.text.y.left = element_text(size = 12,colour = "black", face = "bold"),
        axis.title = element_text(size = 20, face = "bold"),
        panel.border = element_rect(colour = "black", fill = "transparent"),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(size=20),
        legend.title = element_blank(),
        strip.text = element_text(size = 12, face = "bold"))

dev.off()


###-----------------------------------
####---- 3. Running an ANOVA
###-----------------------------------
rm(list=ls())

## ::::::::::::::::::::::::: MultiYear

### --- # Loading the Clades information
keyData = read.csv("../Data/5.Clades.csv")
keyData = keyData[!is.na(keyData$Group), ]


# data coming from the multi-year
dfMTM = read.table(file = "../Data/2.Phenotypes_GxEModels.txt", h=T)[,-1]

# merging
dat1 <- merge(keyData, dfMTM, by = "vcfID", all.x = TRUE)




finalDat = pivot_longer(dat1, cols = !c(vcfID, Group), 
                        names_to= 'Trait', 
                        values_to= 'value')



finalDat$Group[finalDat$Group ==  "Modern_sh2-R"] <-  "Modern_sh2R"
finalDat$Group[finalDat$Group ==  "Modern_sh2-i"] <-  "Modern_sh2i"
table(finalDat$Group)

####>>>---- ANOVA
#.a = finalDat[finalDat$Trait == "LA_19",]

myANOVA = lapply(split(finalDat, f = finalDat$Trait), function(.a){
  
  #NA
  .b = .a[!is.na(.a[,4]),]
  
  # anovis
  anova_result <- aov(value ~ Group, data = .b)
  
  pVal_AOV = summary(anova_result)[[1]][["Pr(>F)"]][1]
  
  # Tukey
  tukey_result <- TukeyHSD(anova_result)
  ad =  HSD.test(anova_result, 'Group')
  
 
     return(list(summary(anova_result),
              tukey_result,
              ad,
              pVal_AOV))
         
  
})


# Extract the third element of each inner list and take the `$groups` component
groups_list <- lapply(myANOVA, function(x) x[[3]]$groups)

# Combine the list into a single data frame
df <- do.call(rbind, groups_list)
df$Trait = sub("^([^\\.]+)\\..*", "\\1",rownames(df))
df$Pop = sub(".*\\.", "", rownames(df))


finalTukey = pivot_wider(df[-1], 
                         names_from = Pop,
                         values_from = groups)

######### p-value from ANOVA
# Extract the third element of each inner list and take the `$groups` component
pValist <- lapply(myANOVA, function(x) x[[4]])

dfPVal <- do.call(rbind, pValist)

## merging and save

finalSTM = cbind(finalTukey, dfPVal)


## ::::::::::::::::::::::::: Single year


####>>>---- Data
df = read.table(file = "../Data/1.Phenotypes_bySeason.txt", h=T)[,-1]
df1 = df[1:58]

# merging
dat_STM <- merge(keyData, df1, by = "vcfID")

###----- Preparing
finalDat = pivot_longer(dat_STM, cols = !c(vcfID, Group), 
                        names_to= 'Trait', 
                        values_to= 'value')


finalDat$Group[finalDat$Group ==  "Modern_sh2-R"] <-  "Modern_sh2R"
finalDat$Group[finalDat$Group ==  "Modern_sh2-i"] <-  "Modern_sh2i"
table(finalDat$Group)


####>>>---- ANOVA
myANOVA = lapply(split(finalDat, f = finalDat$Trait), function(.a){
  
  #NA
  .b = .a[!is.na(.a[,4]),]
  
  # anovis
  anova_result <- aov(value ~ Group, data = .b)
  
  pVal_AOV = summary(anova_result)[[1]][["Pr(>F)"]][1]
  
  # Tukey
  tukey_result <- TukeyHSD(anova_result)
  ad =  HSD.test(anova_result, 'Group')
  
  
  return(list(summary(anova_result),
              tukey_result,
              ad,
              pVal_AOV))
  
  
})


######### Tukey
groups_list <- lapply(myANOVA, function(x) x[[3]]$groups)

# Combine the list into a single data frame
df <- do.call(rbind, groups_list)
df$Trait = sub("^([^\\.]+)\\..*", "\\1",rownames(df))
df$Pop = sub(".*\\.", "", rownames(df))

finalTukey = pivot_wider(df[-1], 
                         names_from = Pop,
                         values_from = groups)

######### p-value from ANOVA
# Extract the third element of each inner list and take the `$groups` component
pValist <- lapply(myANOVA, function(x) x[[4]])

dfPVal <- do.call(rbind, pValist)

## merring and save

finalSTM = cbind(finalTukey, dfPVal)










