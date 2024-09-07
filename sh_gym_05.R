
simple plots with R ggplot2


# Install ggplot2 if not already installed
# install.packages("ggplot2")

# Load the ggplot2 library
library(tidyverse)
library(ggplot2)

# Preview the mtcars dataset (you can use your own dataset)
head(mtcars)

# 1. Basic scatter plot of Horsepower vs. Miles per Gallon (mpg)
# ggplot(data = mtcars, aes(x = hp, y = mpg)) +
#   geom_point() # Adds points to represent the data

mtcars %>% ggplot( aes(x = hp, y = mpg)) +
  geom_point() # Adds points to represent the data

# 2. Customize scatter plot with color and size aesthetics
ggplot(data = mtcars, aes(x = hp, y = mpg, color = factor(cyl), size = wt)) +
  geom_point() + # Adds points with color and size based on cylinders and weight
  theme_minimal() + # Apply a minimalistic theme for a clean look
  labs(title = "MPG vs Horsepower",  # Title of the plot
       x = "Horsepower",             # X-axis label
       y = "Miles per Gallon",        # Y-axis label
       color = "Cylinders",           # Legend label for color
       size = "Weight")               # Legend label for size

# 3. Scatter plot with a trend line (linear model)
ggplot(data = mtcars, aes(x = hp, y = mpg)) +
  geom_point(aes(color = factor(cyl))) +  # Color points by number of cylinders
  geom_smooth(method = "lm", se = FALSE, color = "blue") + # Add a trend line
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "MPG vs Horsepower with Trend Line",  # Title of the plot
       x = "Horsepower",             # X-axis label
       y = "Miles per Gallon",        # Y-axis label
       color = "Cylinders")           # Legend label for color

# 4. Bar plot of average MPG by number of cylinders
ggplot(data = mtcars, aes(x = factor(cyl), y = mpg)) +
  geom_bar(stat = "summary", fun = "mean", fill = "lightblue", color = "black") + # Bar plot showing average mpg
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "Average MPG by Number of Cylinders", # Title of the plot
       x = "Cylinders",             # X-axis label
       y = "Average MPG")            # Y-axis label

# 5. Facet wrap - MPG vs Horsepower plot split by number of cylinders
ggplot(data = mtcars, aes(x = hp, y = mpg)) + 
  geom_point() + # Add points to represent data
  facet_wrap(~ cyl) + # Create separate plots for each number of cylinders
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "MPG vs Horsepower by Cylinders",  # Title of the plot
       x = "Horsepower",             # X-axis label
       y = "Miles per Gallon")        # Y-axis label

# 6. Save the last plot (or any plot) to a file
ggsave("mpg_vs_hp_plot.png", width = 8, height = 6) # Save the plot as a PNG file



# Sample data for fruit classes and random numbers
fruit_data <- data.frame(
  Fruit = c("Apple", "Banana", "Orange", "Grapes", "Pineapple"),
  Count = c(30, 15, 20, 25, 10) # Random numbers
)


#7 Pie chart of fruit classes vs count
ggplot(data = fruit_data, aes(x = "", y = Count, fill = Fruit)) +
  geom_bar(stat = "identity", width = 1, color = "white") + # Creates the bars for the pie slices
  coord_polar(theta = "y") + # Converts the bar chart to a pie chart using polar coordinates
  theme_void() + # Removes axes and background
  labs(title = "Fruit Distribution") + # Adds a title
  scale_fill_brewer(palette = "Set3") # Adds a nice color palette for different fruit types



# 8. Bar chart of fruit classes vs count
ggplot(data = fruit_data, aes(x = Fruit, y = Count)) +
  geom_col(fill = "skyblue", color = "black") + # Creates bars with colors
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "Fruit Count", 
       x = "Fruit Type", 
       y = "Count")

# Bar chart with fruit classes ordered by count (from largest to smallest)
ggplot(data = fruit_data, aes(x = reorder(Fruit, -Count), y = Count)) +
  geom_col(fill = "skyblue", color = "black") + # Creates bars with custom colors
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "Fruit Count (Ordered)", 
       x = "Fruit Type", 
       y = "Count")




# Bar chart with fruit classes ordered by count and different colors for each bar
ggplot(data = fruit_data, aes(x = reorder(Fruit, -Count), y = Count, fill = Fruit)) +
  geom_col(color = "black") + # Creates bars with automatic fill colors based on Fruit
  theme_minimal() + # Apply a minimalistic theme
  labs(title = "Fruit Count (Ordered)", 
       x = "Fruit Type", 
       y = "Count") +
  scale_fill_brewer(palette = "Set3") # Optional: Adds a nice color palette









