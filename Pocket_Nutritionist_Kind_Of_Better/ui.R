fluidPage(
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
            #compare selected food macronutrients vs general type
            tabPanel("Compare Your Foods",
                     p("Use the 'Compare your Foods' tab to pick a food, and ",
                       "see its nutritional value compared to foods in the same category"),
                     uiOutput("Food"),
                     uiOutput("Type"),
                     uiOutput("Preparation"),
                     uiOutput("Additions"),
                     plotOutput("compfood")
            ),
            tabPanel("Plan Your Diet",
                     p("Use the 'Plan your Diet' tab to pick multiple food options, ",
                       "and see how they fit into a USDA recommended 2000 calorie diet.",
                       "The USDA recommends that a healthy diet contains ",
                       "45%-65% carbs, 10%-30% protein, and 25%-35% fat. They also recommend that ",
                       "your saturated fat intake and sugar intake be less than 10%."),
#                     uiOutput("Food"),
#                     uiOutput("Type"),
#                     uiOutput("Preparation"),
#                     uiOutput("Additions"),
#                     plotOutput("dietplan")
            ),
            tabPanel("Raw Data",
                     tableOutput("Food_Table")
            ),
            tabPanel("About the Creator")
        )
        
    )    

    
    
)