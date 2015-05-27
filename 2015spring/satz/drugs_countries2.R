library(dplyr)
library(ggplot2)

## read file with companies, drugs, and dates
raw1 <- read.table(file = "/Users/alexandersatz/Documents/Cuny/IS608/project/drugs_chembl.txt",
                   quote = "", fill = TRUE, sep = "\t", header = TRUE, stringsAsFactors = FALSE)
head(raw1)

## filter down to just the inventor companies
comp1 <- filter(raw1, innovator_company ==1)
nrow(comp2)
comp2 <- unique(comp1[,1:10])
head(comp2)

##read file with companies and countries
loc <- read.table(file = "/Users/alexandersatz/Documents/Cuny/IS608/project/companies_chembl.csv",
                   quote = "", fill = TRUE, sep = ",", header = TRUE, stringsAsFactors = FALSE)

## simplify company names for matching purposes
head(vloc)
vloc = tolower(loc$company)
vloc2 = 0
for (x in 1:length(vloc)){
  vloc2[x] = strsplit(vloc[x], " ")[[1]][[1]]
  vloc2[x] = strsplit(vloc2[x], "-")[[1]][[1]]
}


### companies have long and short names, and capital letter issues.
### below I get everything simplified to a lowercase first name
pvloc = tolower(loc$previous_company)
pvloc2 = 0
for (x in 1:length(pvloc)){
  pvloc2[x] = strsplit(pvloc[x], " ")[[1]][[1]]
  pvloc2[x] = strsplit(pvloc2[x], "-")[[1]][[1]]
}

head(pvloc2)

## now do the matching.
v = 0
for (x in 1:nrow(comp2)){
  c = comp2$applicant_full_name[x]
  c2 = strsplit(c, " ")
  c2 = tolower(c2[[1]][[1]])
  i = match(c2, vloc2)
  if (is.na(i)){
    i = match(c2, pvloc2) 
  }
  if (!is.na(i)){
    v[x] = loc$country[i]
  }
  else{
    v[x] = "Unk"
  }
  
}
head(v)
comp2["country"] = v
head(comp2)
nrow(comp2)

comp3 <- filter(comp2, country != 'Unk')
head(comp3)

## now I have dataframe that includes company country names!


## I have to also assigne ADM0_3 country codes to country names
isolist <- read.table(file = "/Users/alexandersatz/Documents/Cuny/IS608/project/ISOcodes.csv",
                  quote = "", fill = TRUE, sep = ",", header = TRUE, stringsAsFactors = FALSE)
head(isolist)

iso = 0
v = 0
for (x in 1:nrow(comp3)){
  c = comp3$country[x]
  i = match(c, isolist$country)
  if (!is.na(i)){
    v[x] = isolist$ISO[i]
  }
  else{
    v[x] = "Unk"
  }
  
}
head(v)


comp3['ISO'] <- v
nrow(comp3)
comp4 <- filter(comp3, ISO != 'Unk')
nrow(comp4)
head(comp4)


dates = strsplit(comp4$approval_date, "/", fixed=FALSE)
dates2 = 0
for (x in 1:length(dates)){
  v = as.numeric(dates[[x]][[3]])
  if (v<16){
    dates2[x] = v + 2000
  }
  else{
    dates2[x]= v+1900
  }
}

df_companies <- data.frame(dates2, comp4$ISO, comp4$applicant_full_name)
df_companies2 <- df_companies[order(df_companies$dates2),]
head(df_companies2)
setwd("/Users/alexandersatz/Documents/Cuny/IS608/project")
write.csv(df_companies2, file = "iso_dates.csv",row.names=FALSE)

