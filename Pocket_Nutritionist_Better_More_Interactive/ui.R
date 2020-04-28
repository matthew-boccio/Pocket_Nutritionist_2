fluidPage(
    
    titlePanel("Pocket Nutritionist"),
    #intro
    navlistPanel(
        "Better Food, Instantly",
        tabPanel("Introduction", 
                 p("Welcome, and thank you for visiting my app!"),
                 p("When planning a diet, it's hard to be precise when ",
                   "counting calories, carbs, protein, and fat, because ",
                   "fresh produce is often unlabeled."),
                 p("My goal in creating this app is to give users the ability ",
                   "to look up the nutritional content of any food, compare it to other foods, ", 
                   "and plan a healthy diet with the foods they want to eat.")
        ),
        tabPanel("Compare Foods By Nutrient Type", 
                 "Use the 'Compare Foods By Nutrient Type' tab to see the overall value ",
                 "of different types of food by their macronurtient category." ,
                 selectizeInput(inputId = "food_comparison", 
                                label = "Select Nutrient", 
                                choices = c("choose" = "", unique(food_compare_main_graph$Calorie_Type))),
                 plotOutput("food_by_category"),
                 selectizeInput(inputId = "type_picked", 
                                label = "Select Food",
                                choices = c('choose' = '', unique(food_compare_type_graph$Food))),
                 selectizeInput(inputId = "food_type_comparison", 
                                label = "Select Nutrient", 
                                choices = c("choose" = "", unique(food_compare_type_graph$Calorie_Type))),
                 plotOutput("food_by_type"),
                 selectizeInput(inputId = "cat_picked", 
                                label = "Select Type", 
                                choices = c('choose' = '', unique(food_compare_cat_table$Type))),
                 selectizeInput(inputId = "food_cat_comparison", 
                                label = "Select Nutrient", 
                                choices = c("choose" = "", unique(food_compare_cat_table$Calorie_Type))),
                 tableOutput("food_by_cat"),
                 
                 ),
    
        tabPanel("Compare Your Food Choices",
                 p("Use the 'Compare your Foods' tab to pick a food, and ",
                   "see its nutritional value compared to foods in the same category"),
                 uiOutput("Food_Pick"), 
                 uiOutput("Type_Pick"),
                 uiOutput("Prep_Pick"),
                 uiOutput("Add_Pick"),
                 plotOutput("compfood")
        ),
        tabPanel("Check Your Calorie Needs",
                 p("Check your calorie needs based on your age, gender and activity level."),
                 p("Data sourced from the USDA 2015-2020 Dietary Guidelines for Americans. Definitions for different activity levels are at the bottom."),
                 tableOutput("Calorie_Needs"),
                 p("Sedentary means a lifestyle that includes only the physical activity of independent living."),
                 p("Moderately Active means a lifestyle that includes physical activity equivalent to walking about 1.5 to 3 miles per day at 3 to 4 miles per hour, in addition to the
activities of independent living"),
                 p("Active means a lifestyle that includes physical activity equivalent to walking more than 3 miles per day at 3 to 4 miles per hour, in addition to the activities of
independent living.")
        ),
        tabPanel("Plan Your Diet",
                 p("Use the 'Plan your Diet' tab to pick multiple food options, ",
                   "and see how they fit into a USDA recommended 2000 calorie diet.",
                   "The USDA recommends that a healthy diet contains ",
                   "45%-65% carbs, 10%-30% protein, and 25%-35% fat. They also recommend that ",
                   "your saturated fat intake and sugar intake be less than 10%."),
                 uiOutput("Food_Pick_2"),
                 uiOutput("Type_Pick_2"),
                 uiOutput("Prep_Pick_2"),
                 uiOutput("Add_Pick_2"),
                 plotOutput("dietplan")
        ),
        tabPanel("Cleaned Data",
                 p("The raw data offers our full list of foods from the USDA, ",
                   "as well as the calorie levels of common serving sizes."),
                 tableOutput("Food_Table")
        )
    )
    
)    