##################################################################
# The purpose of this R script is to demonstrate useful functions when cleaning
# data sets. This was made mostly for my own reference and a way to practice
# these functions so it is far from perfect or comprehensive, but I will 
# share it for others who may find it helpful.
#
# Script by: Kim Fake
#
#
###################################################################

# To Clear working environment
rm(list=ls())
graphics.off()

# Load made up data --------------------------------------------------------

#load data
data <- read.csv (
  './Biology 101 Data.csv', 
  stringsAsFactors = FALSE, 
  fileEncoding = 'UTF-8-BOM'
)

# click on data in the environment frame on the right side of your screen
# to view the data.  As you can see this is data regarding students in a 
# biology class.  It contains data on each student, including their 
# Names, birth dates, sex, letter and percentage grades, the number of biology 
# classes they attended, and what they considered the strategy to their success
# in the course.

# Change data types -------------------------------------------------------

# change a numeric to an integer because these are discrete counts,
# not continuous variables
data$Classes_Attended <- as.integer(data$Classes_Attended) 

# change an integer to a numeric because these are continuous variables
data$Percent_Grade <- as.numeric(data$Percent_Grade)

#change character to category (i.e. factor)
data$Sex <- as.factor(data$Sex)
# levels just put in alphabetical order
# note it say 5 levels, when there should only be 2
# this is a good indicator that there is cleaning needed in this data

#change character to category (i.e. factor) with ordered levels
data$Letter_Grade <- factor(data$Letter_Grade,
                            levels = c("A", "B", "C", "D", "F")
                            )


# Dealing with dates ------------------------------------------------------

# dates can be written many ways and sometimes difficult to work with.
# here are some helpful tools.

# to change a data type to date use...
data$B_Day <- as.Date(data$B_Day, 
                      format= "%m/%d/%Y"
                      )
#m = 1 M = 01
#d = 1 D = 01
#y = 22, Y = 2022

# load a helpful package for manipulating dates
library(lubridate)

# separate dates into separate month, day, and year columns.
# note that I find this useful for filtering and 
# subsetting/filtering data for many purposes
data <- data %>%
  dplyr::mutate(Year = lubridate::year(B_Day), 
                Month = lubridate::month(B_Day), 
                Day = lubridate::day(B_Day))


# Look for typos ----------------------------------------------------------

# The unique function is useful for looking for typos 
# or incorrectly entered data
unique(data$Sex)
# you can see female was sometimes entered as f instead of F
# the same for males
# there is also an n that we will assume was meant to be an M

# the max and min functions are helpful for dates too
max(data$B_Day)
min(data$B_Day)
# obviously there is a typo in the year for a student's
# birthday. so we need to change the year on one of the birth dates

# Correct a typo ----------------------------------------------------------


#fix sex data typos by making everything and M or F
data$Sex[data$Sex == "m"] <- "M"
data$Sex[data$Sex == "n"] <- "M"
data$Sex[data$Sex == "f"] <- "F"

#recheck the data for sex
unique(data$Sex)
# now the typos are fixed, but we can see the levels are not
# let's fix te levels
data$Sex <- factor(data$Sex,
                            levels = c("F", "M")
)
#see that this changed the levels
unique(data$Sex)

#fix B_Day typo 
data$B_Day[data$B_Day == "1003-3-14"] <- "2003-3-14"
data$Year[data$Year == 1003] <- 2003

#recheck the birth dates
max(data$B_Day)
min(data$B_Day)
#and the years
unique(data$Year)

# Filter for specific words or phases -------------------------------------

library(tidyverse) #library with str_detect function

# filter students that attribute their success to studying
# Students that indicating some kind of studying as key to their success
# is evident by "studying"  or "flashcards" mentioned as the key to their success
students_that_study <- data %>%
  filter(
    str_detect( #detects strings of characters
      Success_Key, 
      "study|flash cards" # | means or
    )
  )
# we can see a new data frame appears in the environment pane to the right
# containing the rows with students that had study or flash cards in the
# Success_Key column


#save clean data
write.csv(
  data, 
  "./Biology 101 Data CLEAN.csv", 
)
