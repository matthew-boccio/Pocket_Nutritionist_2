function(input, output, session) {
  #tried to make the dropdowns reactive
  food_picks = reactive({
    food_full %>%
      filter(Food == input$Food
             & Type == input$Type
             & Preparation == input$Preparation
             & Additions == input$Additions) 
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
  #here's how i'd get my input from the dropdown columns
  #to display the nutrient information against the category
  food_choice = reactive({
    food_choose = food_picks() %>%
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
  #plotting graph for food comp
  output$compfood = renderPlot(
    food_choice() %>%
      ggplot(aes(x = Calorie_Type, y = Calorie_Amount)) + 
      geom_col(aes(fill = Food), position = 'dodge') + 
      coord_flip() + ylim(0, 900)
  )
  
  #tried to get the second plot going 
  food_for_pie_chart = reactive ({
    food_choice() %>%
    food_choose %>%
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
  
  outputdiet_plan = renderPlot(
    food_for_pie_chart() %>%
      bar_instead_of_pie = ggplot(food_for_pie_chart, aes(x = Food, y = Calorie_Amount)) + 
      geom_col(aes(fill = Calorie_Type)) + 
      geom_text(aes(label = Calorie_Amount), size = 3, position = position_stack(vjust = 0.5))
  )
  
#raw data output
  output$Food_Table = renderTable(
    food_full
)
  #calorie table output 
  output$Calorie_Needs = renderTable(
    all_calorie_needs
    
  )
  
  
}