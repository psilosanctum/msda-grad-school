rm(list = ls())
#install.packages("tidyverse")
#install.packages("gridExtra")
#install.packages("MASS")
library(tidyverse)
library(gridExtra)
library(MASS)

data("mpg")
head(mpg)

# scatterplot of engine size (displ) and highway mileage (hwy) in mpg data. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# colored scatterplot, color based on class variable that is a factor (categorical)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# size of scatter based on factor variable. Warning as size should be applied to continuous variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# size is better suited for numeric variables such as cyl
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl))

# alpha controls the transparency of scatter. Ideal for continuous variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = cyl))

# shape controls the shape of the scatter. Here, factor variable is best suited to match to each shape.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# change the aesthetics of the entire plot by putting size, shape, color arguments outside of aes.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 19, color = "green")

# labs can be used to assign labels
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl)) + 
  labs(x = "Engine size [liters]", y = "Mileage [mpg]", title = "Efficiency", caption = "(Based on data from mpg)", tag = "a)")

# to make subplots based on multiple categories use facet_wrap. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ manufacturer, nrow = 2)

# facet_grid() can make subplots based on two categorical variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(class ~ cyl)

# draws a smooth line using local regression. Shading based on standard error
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# you can separate the lines by categories (here, drv)
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = as.factor(cyl)))

# you can combine multiple layers of geoms over each other. For e.g. combining a scatterplot and a smooth lineplot
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +     #notice that I am repeating code, which is not good
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Instead we can write the above code as
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() + 
  geom_smooth()

# you can override global aesthetic mapping by  providing local aes mappings
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) +
  geom_point() +      # this is not good, since we to color by class in the scatterplot, not differentiate in the lineplot
  geom_smooth()

# Instead we can do the above as 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +     
  geom_smooth()

# We can also give different data to different geoms. 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +     
  geom_smooth(data = filter(mpg, class == "compact"), se = FALSE) #se = false turns off shading for standard error

# create a bar chart using geom_bar. Geom_bar will autocompute counts and draw ditribution
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class))

# Creating a testing a variable demo
demo <-  tribble( ~cut, ~freq, 
                  "Fair", 1610,
                  "Good", 4906,
                  "Very Good", 12082,
                  "Premium", 13791,
                  "Ideal", 21551)
# To plot an already computed frequency, use stat = "identity"
ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

# you can also draw bar charts for proportions using prop if you don't have the frequency computed. 
# Proportion is computed for the whole group, so group = 1.
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, y = stat(prop), group = 1))

# stat_summary() creates a summary plot with median, max, and min. 
ggplot(data = mpg) + 
  stat_summary(mapping = aes(x  = class, y = hwy), fun.ymin = min, fun.ymax =  max, fun.y = median)

# bar charts also have color / fill argument that colors each category uniquely
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, color = class))
 
# or even better
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, fill = class))

# to get stacked bar chart, change the fill variable to a categorical variable that is not the x-variable.
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, fill = drv))

# Instead of stacked, if you want to separate the stacks by slight moving left and right of the tick marks, use position = "dodge"
ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, fill = drv), position = "dodge")

# histograms are very useful and can be created by geom_histogram()
ggplot(data = mpg) +
  geom_histogram(binwidth = 2, mapping = aes(x = hwy))

# gridExtra package helps make multiple plots in a grid. Let me show how the binwidth affects the histogram
plot1 = ggplot(data = mpg) +
  geom_histogram(binwidth = 0.5, mapping = aes(x = hwy)) + 
  labs(title = "Binwidth = 0.5")

plot2 = ggplot(data = mpg) +
  geom_histogram(binwidth = 1, mapping = aes(x = hwy)) + 
  labs(title = "Binwidth = 1")

plot3 = ggplot(data = mpg) +
  geom_histogram(binwidth = 2, mapping = aes(x = hwy)) + 
  labs(title = "Binwidth = 2")

plot4= ggplot(data = mpg) +
  geom_histogram(binwidth = 3, mapping = aes(x = hwy)) + 
  labs(title = "Binwidth = 3")

# putting multiple plots onto a grid
grid.arrange(plot1, plot2, plot3, plot4, ncol = 4)

# we can also create smoothed histogram, aka a density plot
ggplot(data = mpg) +
  geom_density(mapping = aes(x = hwy))

# Another useful plot is a lollipop chart: hybrid between a bar chart and scatterplot
# Let's plot mtcars data sorted by mpg, and plot the cars along with mpg values
mtcars %>% mutate(carnames = rownames(mtcars)) %>%
  arrange(mpg) %>%
  mutate(ynames = factor(carnames, levels = carnames)) %>%  #need to convert car names to factors, then it can be plotted in geom_segment()
  ggplot(aes(x = mpg, y = ynames)) + 
  geom_segment(aes(x = 0, y = ynames, xend = mpg, yend = ynames), color = "grey") + 
  geom_point()

# Jittered plots are also useful when there are overalapping points. Do position = "jitter", think of this similar to dodge for geom_bar.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# We can also flip the coordinate system. For example, switching a vertical boxplot to a horizontal boxplot.
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() + 
  coord_flip()

data("birthwt")
# 1st example 
ggplot(data = birthwt, mapping = aes(x = lwt, fill = as.factor(race))) +
  geom_histogram(binwidth = 10, alpha = 0.5) +
  scale_fill_discrete(name = "Race") +
  coord_flip()

# 2nd example
ggplot(data = birthwt, mapping = aes(x = lwt, fill = as.factor(smoke))) +
  geom_histogram(binwidth = 10) +
  scale_fill_discrete(name = "Smoker") +
  facet_wrap(~ smoke, nrow = 1)

