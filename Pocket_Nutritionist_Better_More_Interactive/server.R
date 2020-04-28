function(input, output, session) {

    food_choice = reactive({
        food_full %>%
            filter(Food == input$Food) %>%
            filter(Type == input$Type) %>%
            filter(Preparation == input$Preparation) %>%
            filter(Additions == input$Additions)
    })
    
    output$Food_Pick = renderUI({
        selectizeInput("Food", label = h4("Select Food"), 
                       choices = c("choose" = "", unique(food_full$Food))) 
    })
    
    output$Type_Pick = renderUI({
        type_depend = reactive({
            food_full %>%
                filter(Food == input$Food) %>%
                pull(Type) %>%
                as.character() })
        selectizeInput("Type", label = h4("Select Type"), 
                       choices = c("choose" = "", type_depend())) 
    })
    
    output$Prep_Pick = renderUI({
        prep_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>%
                filter(Type == input$Type) %>%
                pull(Preparation) %>%
                as.character() })
        selectizeInput("Preparation", label = h4("Select Preparation"), 
                       choices = c("choose" = "", prep_depend())) 
    })
    
    output$Add_Pick = renderUI({
        add_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>% 
                filter(Type == input$Type) %>%
                filter(Preparation == input$Preparation) %>%
                pull(Additions) %>%
                as.character() })
        selectizeInput("Additions", label = h4("Select Additions"), 
                       choices = c("choose" = "", add_depend())) 
    })
    
    food_choice_for_compare = reactive({
        food_choose = food_full %>%
            filter(Food == input$Food
                   & Type == input$Type
                   & Preparation == input$Preparation
                   & Additions == input$Additions) %>%
            group_by(Food) %>%
            summarize(Avg_Total_Calories_per_100g = round(mean(Calories)),
                      Calories_of_Carbs = round(mean(Total_Carbs_.g.) * 4),
                      Calories_of_Sugar = round(mean(Total_Sugar_.g.) * 4),
                      Calories_of_Fat = round(mean(Total_Fat_.g.) * 9),
                      Calories_of_Saturated_Fat = round(mean(Saturated_Fat_.g.) * 9),
                      Calories_of_Protein = round(mean(Protein_.g.) * 4)) %>%
            mutate(Food = "SELECTED FOOD")
        
        add_choose_to_compare = rbind(food_compare_base, food_choose)
        
        comparer = add_choose_to_compare %>%
            filter(Food == input$Food
                   | Food == "SELECTED FOOD")
        comparer = comparer %>%
            gather(Avg_Total_Calories_per_100g, 
                   Calories_of_Carbs, 
                   Calories_of_Sugar, 
                   Calories_of_Fat, 
                   Calories_of_Saturated_Fat, 
                   Calories_of_Protein, 
                   key = "Calorie_Type", value = "Calorie_Amount")
    })
    
    
    
    output$compfood = renderPlot(
        food_choice_for_compare() %>%
            ggplot(aes(x = Calorie_Type, y = Calorie_Amount)) + 
            geom_col(aes(fill = Food), position = 'dodge') + 
            coord_flip() + ylim(0, 900)
    )
    
#----------------------------------------------------------    
    
    food_choice_2 = reactive({
        food_full %>%
            filter(Food == input$Food) %>%
            filter(Type == input$Type) %>%
            filter(Preparation == input$Preparation) %>%
            filter(Additions == input$Additions)
    })
    
    output$Food_Pick_2 = renderUI({
        selectizeInput("Food", label = h4("Select Food"), 
                       choices = c("choose" = "", unique(food_full$Food))) 
    })
    
    output$Type_Pick_2 = renderUI({
        type_depend = reactive({
            food_full %>%
                filter(Food == input$Food) %>%
                pull(Type) %>%
                as.character() })
        selectizeInput("Type", label = h4("Select Type"), 
                       choices = c("choose" = "", type_depend())) 
    })
    
    output$Prep_Pick_2 = renderUI({
        prep_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>%
                filter(Type == input$Type) %>%
                pull(Preparation) %>%
                as.character() })
        selectizeInput("Preparation", label = h4("Select Preparation"), 
                       choices = c("choose" = "", prep_depend())) 
    })
    
    output$Add_Pick_2 = renderUI({
        add_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>% 
                filter(Type == input$Type) %>%
                filter(Preparation == input$Preparation) %>%
                pull(Additions) %>%
                as.character() })
        selectizeInput("Additions", label = h4("Select Additions"), 
                       choices = c("choose" = "", add_depend())) 
    })
    
    food_choice_for_diet = reactive({
        food_choose_2 = food_full %>%
            filter(Food == input$Food
                   & Type == input$Type
                   & Preparation == input$Preparation
                   & Additions == input$Additions) %>%
            group_by(Food) %>%
            summarize(Avg_Total_Calories_per_100g = round(mean(Calories)),
                      Calories_of_Carbs = round(mean(Total_Carbs_.g.) * 4),
                      Calories_of_Sugar = round(mean(Total_Sugar_.g.) * 4),
                      Calories_of_Fat = round(mean(Total_Fat_.g.) * 9),
                      Calories_of_Saturated_Fat = round(mean(Saturated_Fat_.g.) * 9),
                      Calories_of_Protein = round(mean(Protein_.g.) * 4)) %>%
            mutate(Food = "SELECTED FOOD")
            food_choose_2 = food_choose_2 %>%
                select(-Avg_Total_Calories_per_100g) %>%
                mutate(Calories_of_Carbs = (Calories_of_Carbs - Calories_of_Sugar)) %>%
                mutate(Calories_of_Fat = (Calories_of_Fat - Calories_of_Saturated_Fat)) %>%
                gather(Calories_of_Carbs, 
                       Calories_of_Sugar, 
                       Calories_of_Fat, 
                       Calories_of_Saturated_Fat, 
                       Calories_of_Protein, 
                       key = "Calorie_Type", value = "Calorie_Amount")
    })
    
    output$dietplan = renderPlot(
        food_choice_for_diet() %>%
            ggplot(aes(x = Food, y = Calorie_Amount)) + 
            geom_col(aes(fill = Calorie_Type)) + 
            geom_text(aes(label = Calorie_Amount), size = 3, position = position_stack(vjust = 0.5))
    )
    
    #-------------------------------------------------------------------------------------------
    
    output$Calorie_Needs = renderTable(
        all_calorie_needs
    )
    
    output$Food_Table = renderTable(
        food_full
    )
    
    output$food_by_category = renderPlot(
        food_compare_main_graph %>%
            filter(Calorie_Type == input$food_comparison) %>%
            ggplot(aes(x = Food, y = Average_Calorie_Amount_Per_100g), fill = "red") + 
            geom_bar(stat = "identity")
    )
    
    output$food_by_type = renderPlot(
        food_compare_type_graph %>%
            filter(Calorie_Type == input$food_type_comparison,
                   Food == input$type_picked) %>%
            ggplot(aes(x = Type, y = Average_Calorie_Amount_Per_100g), fill = "red") + 
            geom_bar(stat = "identity") + coord_flip()
    )
    output$food_by_cat = renderTable(
        food_compare_cat_table %>%
            filter(Calorie_Type == input$food_cat_comparison,
                   Type == input$cat_picked) 
    )
    
}

