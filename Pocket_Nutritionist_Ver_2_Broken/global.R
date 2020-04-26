library('dplyr') #table manip
library('ggplot2') #create plots
library('RColorBrewer') #colors, ggplot2
library('tidyverse')
library('tidyr') #clean data
library('shiny') #make apps
library('googleVis') #cool graphs, shiny
library('maps') #maps on graphs 
library('leaflet') #cool maps, shiny
library('shinydashboard') #cool UI shiny
library('DT') #better data table display
library('RSQLite') #connects shiny to MYSQL
library('data.table') #better data frames
library('rsconnect') #deploy shiny apps to shiny.io
library('shinyWidgets')

food_data = read.csv('Food_Nutrition_Data.csv', stringsAsFactors = F)

#renaming columns to be more reader-friendly
food_data_renames = food_data %>%
  rename(Food = Shrt_Desc, Calories = Energ_Kcal, Total_Fat_.g. = Lipid_Tot_.g., 
         Total_Carbs_.g. = Carbohydrt_.g., Total_Fiber_.g. = Fiber_TD_.g., 
         Total_Sugar_.g. = Sugar_Tot_.g., Saturated_Fat_.g. = FA_Sat_.g., 
         MonoUnsaturated_Fat_.g. = FA_Mono_.g., PolyUnsaturated_Fat_.g. = FA_Poly_.g.,
         Common_Portion_Size_1 = GmWt_Desc1, Weight_In_Grams_Size_1 = GmWt_1, 
         Common_Portion_Size_2 = GmWt_Desc2, Weight_In_Grams_Size_2 = GmWt_2)

#seperating foods into different categories/types, for better comparison
food_data_1 = food_data_renames %>%
  separate(Food, sep = ',', 
           into = c('Food', 'Type', 
                    'Sub-Type_1', 'Sub-Type_2', 'Sub-Type_3', 'Sub-Type_4', 
                    'Sub-Type_5', 'Sub-Type_6', 'Sub-Type_7', 'Sub-Type_8', 
                    'Sub-Type_9'))
#according to warning summary, 1 has more than 9 sub-types(5545), 11 have 9 exactly, 
#the rest have less. so we narrow down from 9 sub-types

#one category at a time - separating categories into their own data tables for now 

dairy_and_eggs = food_data_1 %>% #eliminate 5-9, combine 2-4, have 1
  filter(NDB_No < 2000) 

poultry = food_data_1 %>% #eliminate 6-9, combine 2-5, have 1
  filter(NDB_No >= 5000 & NDB_No < 6000) %>%
  rename('Type' = 'Food', 'Sub-Type' = 'Type') %>%
  mutate('Food' = rep('POULTRY', 382))

cured_meats_and_deli_meats = food_data_1 %>% #eliminate 4-9, combine 1-3
  filter(NDB_No >= 7000 & NDB_No < 8000) 

fruit_and_fruit_juice = food_data_1 %>% #eliminate 4-9, combine 1-3
  filter(NDB_No >= 9000 & NDB_No < 10000)

pork = food_data_1 %>% #eliminate 7-9, combine 4-6, combine 1-3
  filter(NDB_No >= 10000 & NDB_No < 11000)

veggies1 = food_data_1 %>% 
  filter((NDB_No >= 11000 & NDB_No < 12000))
veggies2 = food_data_1 %>%
  filter((NDB_No >= 16000 & NDB_No < 16500))
veggies3 = food_data_1 %>%
  filter((NDB_No >= 31000 & NDB_No < 32000))

beef1 = food_data_1 %>%
  filter((NDB_No >= 13000 & NDB_No < 14000) )
beef2 = food_data_1 %>%
  filter((NDB_No >= 23000 & NDB_No < 24000))

fish = food_data_1 %>%
  filter(NDB_No >= 15000 & NDB_No < 16000)
  
  other_meats = food_data_1 %>%
  filter(NDB_No >= 17000 & NDB_No < 18000)
  
  grains_1 = food_data_1 %>%
  filter((NDB_No >= 18000 & NDB_No < 19000))
grains_2 = food_data_1 %>%
  filter((NDB_No >= 20000 & NDB_No < 21000))

#rejoin
food_full = food_data_1 %>%
     filter(NDB_No < 2000 
         | (NDB_No >= 5000 & NDB_No < 6000)
         | (NDB_No >= 9000 & NDB_No < 12000)
         | (NDB_No >= 13000 & NDB_No < 14000)
         | (NDB_No >= 15000 & NDB_No < 16500)
         | (NDB_No >= 17000 & NDB_No < 19000) 
         | (NDB_No >= 20000 & NDB_No < 21000)
         | (NDB_No >= 23000 & NDB_No < 24000))

food_names = c(rep('DAIRY AND EGGS', 250), 
               rep('POULTRY', 382),
               rep('FRUIT', 359),
               rep('PORK', 336),
               rep('VEGGIES', 791),
               rep('BEEF', 380),
               rep('FISH', 259),
               rep('VEGGIES', 278),
               rep('VEAL AND LAMB', 464),
               rep('GRAINS AND BREADS', 666),
               rep('BEEF', 587))

food_full = food_full %>%
  rename('Type' = 'Food', 'Sub-Type' = 'Type') %>%
  arrange(NDB_No) %>%
  mutate('Food' = food_names)

#combine sub-columns

food_full = food_full %>%
  select(-`Sub-Type_9`, -`Sub-Type_8`, 
         -`Sub-Type_7`, -`Sub-Type_6`)
food_full = food_full %>%
  replace_na(list(`Sub-Type_1` = '',
                  `Sub-Type_2` = '',
                  `Sub-Type_3` = '',
                  `Sub-Type_4` = '',
                  `Sub-Type_5` = '')) %>%
  unite(`Sub-Type`, `Sub-Type_1`, `Sub-Type_2`, 
        col = 'Preparation', sep = ', ') %>%
  unite(`Sub-Type_3`, `Sub-Type_4`, `Sub-Type_5`, 
        col = 'Additions', sep = ', ')

#narrow down columns
food_full = food_full %>%
  select(Food, Type, Preparation, Additions, 
         Calories, Total_Carbs_.g., Total_Sugar_.g.,
         Total_Fat_.g., Saturated_Fat_.g., 
         Protein_.g., Sodium_.mg.,
         Common_Portion_Size_1, Weight_In_Grams_Size_1)

#adjust nutrients for portion size
food_full = food_full %>%
  mutate('Cals_Portion' = round(Calories * Weight_In_Grams_Size_1/100),
         'Carbs_Portion' = round(Total_Carbs_.g. * Weight_In_Grams_Size_1/100),
         'Sugar_Portion' = round(Total_Sugar_.g. * Weight_In_Grams_Size_1/100),
         'Fat_Portion' = round(Total_Fat_.g. * Weight_In_Grams_Size_1/100),
         'Sat_Fat_Portion' = round(Saturated_Fat_.g. * Weight_In_Grams_Size_1/100),
         'Protein_Portion' = round(Protein_.g. * Weight_In_Grams_Size_1/100),
         'Sodium_Portion' = round(Sodium_.mg. * Weight_In_Grams_Size_1/100))

#getting rid of weird one-time entries and ones with brand names for easier grouping
#getting rid of NAs too
food_full = food_full %>%
  group_by(Type) %>%
  mutate(Num_Val = n()) %>%
  filter(Num_Val >= 5, nchar(Type) < 20, 
         is.na(Common_Portion_Size_1) == FALSE, is.na(Weight_In_Grams_Size_1) == FALSE,
         Type != 'USDA CMDTY', Type != 'EMU', Type != 'OSTRICH', 
         Type != 'FRUIT SALAD', Type != "GOOSE", 
         Type != "TURKEY FROM WHL", Type != "FRUIT COCKTAIL", 
         Type != "FRUIT JUC SMOOTHIE",
         Type != "PEAS&CARROTS", Type != 'VEGETABLES', 
         Type != 'FISH', Type != "USDA COMMODITY",
         Type != "VITASOY USA", 
         Type != "GAME MEAT", 
         Type != "KASHI", Type != "AUSTIN", Type != "KELLOGG'S", 
         Type != "WHEAT") %>%
  replace_na(list(Total_Sugar_.g. = as.numeric('0'), 
                  Saturated_Fat_.g. = as.numeric('0'),
                  Sugar_Portion = as.numeric('0'), 
                  Sat_Fat_Portion = as.numeric('0')))

#ungrouping for now

ungroup(food_full, Type)

#making col names factors again

food_full_factors = as.factor(colnames(food_full))

#making empty values "none" to work with the dropdown menu better

#make_nones = function(x) {
 # require(dplyr)
 # x %>%
#    gsub("	, , ", "NONE", . )
# }

# food_full$Additions = make_nones(food_full$Additions)

#base avg nutrients by category to compare input to: 
food_compare_base = food_full %>%
  group_by(Food) %>%
  summarize(Avg_Total_Calories_per_100g = round(mean(Calories)),
            Calories_of_Carbs = round(mean(Total_Carbs_.g.) * 4),
            Calories_of_Sugar = round(mean(Total_Sugar_.g.) * 4),
            Calories_of_Fat = round(mean(Total_Fat_.g.) * 9),
            Calories_of_Saturated_Fat = round(mean(Saturated_Fat_.g.) * 9),
            Calories_of_Protein = round(mean(Protein_.g.) * 4))

#empty data frame with right columns to reference later
placeholder = food_compare_base %>%
  filter(Food == "NOTHING")


#counting NAs
na_counter = colSums(is.na(food_full)) 
print(na_counter)

#max calories for axis labeling 
food_full %>%
  ungroup(Type) %>%
  summarize(max(Calories))

#returns 898, set max to 900

#---------------------------------------------------------------------------------------



