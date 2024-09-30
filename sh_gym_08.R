#Bubble plot with R for Cancer survival rate

library(ggplot2)
library(readxl)


surv <- structure(list(sn = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), 
    id = c(1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6), 
    cancer_site = c("Cancer_1", "Cancer_2", "Cancer_3", "Cancer_4", "Cancer_5", "Cancer_6", 
    "Cancer_1", "Cancer_2", "Cancer_3", "Cancer_4", "Cancer_5", "Cancer_6"), 
    total = c(500, 4000, 3500, 250, 5000, 4900, 500, 4000, 3500, 250, 5000, 4900), 
    surv_rate = c(0.400, 0.420, 0.750, 0.790, 0.980, 0.960, 0.115, 0.160, 0.550, 0.750, 0.850, 0.875), 
    surv_year = c("1-year", "1-year", "1-year", "1-year", "1-year", "1-year", "5-year", "5-year", "5-year", "5-year", "5-year", "5-year")), 
    class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA, -12L))

#change the decimal % to real % figure
surv$surv_rate <- surv$surv_rate * 100


# Order cancer_site based on id
surv$cancer_site <- factor(surv$cancer_site, levels = c("Liver", "Lung", "Colorectal", "Cervix", "Prostate", "Breast"))

# Create the bubble chart
ggplot(surv, aes(x = cancer_site, y = surv_rate, size = total, color = surv_year)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(3, 15), guide = "none") +  # Adjust size range for bubbles
  #geom_text(aes(label = paste0(surv_rate, "%")), vjust = 1.5, hjust = 0.5, size = 4) +  # Add percentage labels next to bubbles
  labs(x = "Cancer Site", y = "Survival Rate (%)", title = "Survival Rate by Cancer Site and Year") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 14, angle = 45, hjust = 1),  # Make X-axis font bigger
    #axis.text.y = element_blank(),  # Remove Y-axis values
    panel.grid = element_blank(),  # Remove grid lines
    axis.line = element_line(color = "black"),  # Add main X and Y axis lines
    panel.border = element_blank()  # Remove the box around the plot
  ) +
  scale_color_manual(values = c("1-year" = "blue", "5-year" = "red")) + 
  guides(color = guide_legend(title = "Survival Year"))




# Create the bubble chart with grid
ggplot(surv, aes(x = cancer_site, y = surv_rate, size = total, color = surv_year)) +
  geom_point(alpha = 0.7) + 
  scale_size(range = c(3, 15), guide = "none") +  # Adjust size range for bubbles
  # geom_text(aes(label = paste0(surv_rate, "%")), vjust = 1.5, hjust = 0.5, size = 4) +  # Add percentage labels next to bubbles
  labs(x = "Cancer Site", y = "Survival Rate (%)", title = "Survival Rate by Cancer Site and Year") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 14, angle = 45, hjust = 1),  # Make X-axis font bigger
    # axis.text.y = element_blank(),  # Remove Y-axis values if needed
    #panel.grid.major = element_line(color = "gray90", size = 0.5),  # Faint minimal grid lines
    panel.grid.minor = element_line(color = "gray95", size = 0.25),  # Even fainter minor grid lines
    axis.line = element_line(color = "black"),  # Add main X and Y axis lines
    panel.border = element_blank()  # Remove the box around the plot
  ) +
  scale_color_manual(values = c("1-year" = "blue", "5-year" = "red")) + 
  guides(color = guide_legend(title = "Survival Year"))



