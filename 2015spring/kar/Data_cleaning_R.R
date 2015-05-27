## World Health Data ##


bcg<-read.csv(file.choose(), header=TRUE)
#bcg1<-bcg[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]
#names_immunization<-names(bcg1)

hepB<-read.csv(file.choose(), header=TRUE)
#hepB<-hepB[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]
#names(hepB)<-names_immunization

hib3<-read.csv(file.choose(), header=TRUE)
#hib3<-hib3[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]
#names(hib3)<-names_immunization

dtp3<-read.csv(file.choose(), header=TRUE)
#dtp3<-dtp3[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]
#names(dtp3)<-names_immunization

measles<-read.csv(file.choose(), header=TRUE)
names(measles)<-names(bcg)
#measles<-measles[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]


neonatal<-read.csv(file.choose(), header=TRUE)
#neonatal<-neonatal[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]

polio<-read.csv(file.choose(), header=TRUE)
#polio<-polio[,c( "GHO", "Indicator", "Year","Region_Code","WHO_region", "Country_Code", "Country", "Numeric_Value")]

require(tidyr)

immunization<-rbind(bcg, hepB, hib3,dtp3, measles, neonatal, polio)

spread_data_bcg<-spread(bcg1[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_bcg)
write.csv(spread_data_bcg, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\bcg_spread.csv")


spread_data_hepB<-spread(hepB[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_hepB)
write.csv(spread_data_hepB, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\hepB_spread.csv")

spread_data_hib3<-spread(hib3[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_hib3)
write.csv(spread_data_hib3, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\hib3_spread.csv")

spread_data_dtp3<-spread(dtp3[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_dtp3)
write.csv(spread_data_dtp3, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\dtp3_spread.csv")

spread_data_measles<-spread(measles[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_measles)
write.csv(spread_data_measles, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\measles_spread.csv")

spread_data_neonatal<-spread(neonatal[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_neonatal)
write.csv(spread_data_neonatal, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\neonatal_spread.csv")

spread_data_polio<-spread(polio[,c("Country", "Year", "Numeric_Value")], Year,  Numeric_Value)
na.omit(spread_data_polio)
write.csv(spread_data_polio, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\polio_spread.csv")

write.csv(immunization, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\immunization_all.csv")


require(dplyr)
life_expectancy<-read.csv(file.choose(), header=TRUE)


life_expectancy_chart1<-life_expectancy[,c("Year", "WHO_region", "World_Bank_income_group", "Country","Sex", "Numeric_Value", "Indicator")] %>%
                    filter(Sex=="Both sexes" & Indicator=="Life expectancy at birth (years)") 

life_expectancy_chart1$World_bank_Income_grp_Code[life_expectancy_chart1$World_Bank_income_group=="High-income"]<-4
life_expectancy_chart1$World_bank_Income_grp_Code[life_expectancy_chart1$World_Bank_income_group=="Upper-middle-income"]<-3
life_expectancy_chart1$World_bank_Income_grp_Code[life_expectancy_chart1$World_Bank_income_group=="Lower-middle-income"]<-2
life_expectancy_chart1$World_bank_Income_grp_Code[life_expectancy_chart1$World_Bank_income_group=="Lower-income"]<-1

life_expectancy_chart1 <- life_expectancy_chart1[ , c("Country", "Numeric_Value", "World_bank_Income_grp_Code", "World_Bank_income_group", "WHO_region", "Year")]

write.csv(life_expectancy_chart1, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\life_expectancy_chart1.csv")


life_expectancy_chart2 <- life_expectancy[,c("Indicator", "Year", "Country", "Sex", "Numeric_Value")] %>%
  filter( Sex=="Male" | Sex=="Female") %>%
           filter(Indicator=="Life expectancy at birth (years)") 

life_expectancy_chart2<-spread(life_expectancy_chart2[,c( "Country", "Sex", "Numeric_Value", "Year")], Sex,  Numeric_Value)


write.csv(life_expectancy_chart2, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\life_expectancy_chart2.csv")

malaria_confirm<-read.csv(file.choose(), header = TRUE)  
malaria_death<-read.csv(file.choose(), header = TRUE)  

malaria_data<-merge(malaria_confirm,malaria_death, by = c("Country_Code" , "Year"), all = TRUE)

names(malaria_data)
malaria_data<-malaria_data[complete.cases(malaria_data),]
malaria_data<-malaria_data[,c("Country.x", "Region_Code.x", "Numeric_Value.x", "Numeric_Value.y","Year", "Region.x")]
names(malaria_data)<-c("Country","Region_Code", "Confirmation_Number", "Death_Number", "Year", "Region")
write.csv(malaria_data, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\malaria_data.csv")


malaria_data<-complete.cases(malaria_data)
grouped_malaria_data<-select(malaria_data, Confirmation_Number: Region)%>%
group_by( Region, Year) %>%
  summarise(sum(Confirmation_Number), sum(Death_Number))
write.csv(grouped_malaria_data, "C:\\Users\\sonatushi\\Google Drive\\CUNY Data Analytics\\IS 608\\World health data\\malaria_data2.csv")
