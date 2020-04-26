function(input, output, session) {
    
    food_picker = reactive({
        food_full %>%
            filter(Food == input$Food_Pick
                   & Type == input$Type_Pick
                   & Preparation == input$Prep_Pick
                   & Additions == input$Add_Pick)
    })
    #tables and graphs for the first and second tab
    food_choice = reactive({
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

    food_summary = reactive({
        summary_food = food_full %>%
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
        food_for_summary_chart = summary_food %>%
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
    
    output$Food = renderUI({
        selectizeInput("Food", label = h4("Select Food"), 
                       choices = unique(food_full$Food)) 
    })
    
    output$Type = renderUI({
        type_depend = reactive({
            food_full %>%
                filter(Food == input$Food) %>%
                pull(Type) %>%
                as.character() })
        selectizeInput("Type", label = h4("Select Type"), 
                       choices = type_depend())
    })
    
    output$Preparation = renderUI({
        prep_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>%
                filter(Type == input$Type) %>%
                pull(Preparation) %>%
                as.character() })
        selectizeInput("Preparation", label = h4("Select Preparation"), 
                       choices = prep_depend()) 
    })
    
    output$Additions = renderUI({
        add_depend = reactive ({
            food_full %>%
                filter(Food == input$Food) %>% 
                filter(Type == input$Type) %>%
                filter(Preparation == input$Preparation) %>%
                pull(Additions) %>%
                as.character() })
        selectizeInput("Additions", label = h4("Select Additions"), 
                       choices = add_depend())
    })
    
    output$compfood = renderPlot(
        food_choice() %>%
            ggplot(aes(x = Calorie_Type, y = Calorie_Amount)) + 
            geom_col(aes(fill = Food), position = 'dodge') + 
            coord_flip() + ylim(0, 900) + 
            geom_text(aes(label = Calorie_Amount), position = position_nudge(x = 0, y = 1))
    )
    
    output$dietplan = renderPlot(
        food_summary() %>%
            summary_bar = ggplot(food_for_pie_chart, aes(x = Food, y = Calorie_Amount)) + 
            geom_col(aes(fill = Calorie_Type)) + 
            geom_text(aes(label = Calorie_Amount), size = 3, position = position_stack(vjust = 0.5))
    )
    
    output$Food_Table_Test = renderTable(
        food_picker()
    )

    
    output$Food_Table = renderTable(
        food_full
    )
}