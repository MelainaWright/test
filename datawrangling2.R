########################################################################
#ESM 262
#5/5/17
#datawrangling part 2 - transforming and relating
#book: R for data wrangling, Grolemund and Wickham

library(tidyverse)

#######################################################################
#once data is reasonably glitch free (data wrangling part 1), how do you slice and dice it?

install.packages("nycflights13")

library(nycflights13)

View(flights)
#date is broken up into three columns: a day, month, year = easier to pick our specific days, months or years

#dplyr has the following functions:
  #filter - pick out rows based on specific values of a specific variable (day value = 1)
  #arrange - display things in a particular order
  #select - pull specific columns out of data frame (subset of specific columns in dataset)
  #mutate - creates new columns based on values of existing columns (new column that has combined values)
  #summarise - takes mult values and turns into a single value (aggregate function)
  #group_by - instead of operating on every value individually, operate on a group of values (mean delay of flight on the whole table, can group it by first day of month vs 15th day of month)

#filter####################################################
jan1 <- filter(flights, month==1, day==1) #pick out all data from january and the first day of january; reads row, applies conditions in filter, and if works then adds it to new table you are creating

(dec25 <- filter(flights, month == 12, day == 25)) #print out results and save it as a variable
View(dec25)



#comparisons#############################################################################
filter(flights, month=1) #tells you need a == so you test for equality

flights %>% filter(month==1) %>% filter(day==1) %>% count()
#count how many things you feed into it



#storing more digits#########
sqrt(2)^2 == 2.0 #the answer is false. why? b/c R turns the sqrt(2) into an irrational number (computer can only store so many digits) and then squaring that number (the approximation of sqrt2); it's not doing the algebra

print(sqrt(2), digits =7)#store number of sig figs you specify, can do up to 22 digits

print(sqrt(2)^2, digits =14) #it now works


#near#######################
#test to see if values are pretty close

near(sqrt(2) ^ 2,  2)


##############################################################################################
#logical expressions: combine with boolean operators

# xor (one or the other but not both)
# | (either or both)
# & (both)
#! (not what follows the !)

filter(flights, month ==11 | month ==12)

#filter(flights, month == 11|12) is wrong, it won't work


# A useful short-hand for this problem is x %in% y. This will select every row where x is one of the values in y. We could use it to rewrite the code above: if you have a lot of or this or that or etc.
#   
nov_dec <- filter(flights, month %in% c(11, 12))


#departed within two hours of what they said they were going to:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)



#####################################################################################
#Missing values (cont. from part 1)

#if do NA>5, your result is NA; 10==NA would yield NA; once NA gets into the calculation, everything it touches becomes a NA

#NA is not equal to itself since we don't know what it is
#Let x be Mary's age. We don't know how old she is.
x <- NA
#Let y be John's age. We don't know how old he is.
y <- NA
#Are John and Mary the same age?
x == y
# #> [1] NA
#We don't know!

#If you want to determine if a value is missing, use is.na():
is.na(x)
# #> [1] TRUE


###########################################################################
#arrange, sort by columns in the order you specify

arrange(flights, year, month, day) #sort by year then month then day

arrange(flights, desc(arr_delay)) #re-order by a column in descending order
#can't sort missing values so by default, it pushes them all to the end



########################################################################
#selecting columns with select()
#pull specific columns out of table. create a subset of columns from the data set and specify their order

select(flights, year, month, day) #or select(flights, day, month, year) changes the order

#do rearrangement and rewrite old table
x <- select(flights, year, month, day)
x <- select(x, day, month, year)

#can rename column as copy it:
x <- select(x, dd=day, mm=month, yyyy=year) 

select(flights, year:day) #select all columns between year and day

select(flights, -(year:day)) #remove certain columns

rename(flights, tail_num = tailnum) #takes the whole data set and only rename one column at a time

select(flights, time_hour, air_time, everything()) #select time_hour and air_time and move them to the beginning of the table and then stick everything else after it



#####################################################################################
#mutate: add new column that is a function of an existing column

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
#take flights data set and then take any of the columns that ends in delay, the columns years:day, and then select column distance and airtime
View(flights_sml)


mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)
#add a new column that is called gain which is the column arr_dela minus the dep_delay column; add a new column that is called speed which is the distance column divided by the air_time column times 60



mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)


##do same thing but only want to keep new columns
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)


##############################################################################
#arithmetic operators: the usual +-/* and x/sum(x) for mean of column

#Modular arithmetic: %/% (integer division) and %% (remainder)
#3/2 = 1.5; but a computer, 3/2 = 1 remainder 1; so use 3%/%2 = 1, if use 3%%2 = 1; 10%%x -> 0,...,9

#Example: 1210 %/% 100 = 12; 1210 %% 100 = 10
#good for figuring out which decade you are in



################################################################################
#grouping

#summarise creates a column whose value is a summarization of another column

summarise(flights, delay = mean(dep_delay, na.rum=TRUE)) #just get a single row (collapse a bunch of rows into one value)

#mean delay for different categories of stuff; take what defines these groups and then summarize this value just for those groups; gives the mean departure day for each day of the year
by_day <- group_by(flights, year, month, day) #adds hidden info to table
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)) #summarise now operates over those groups that are hidden in the table

#ungroup() to get rid of grouping

#group flights dataset by destination, then summarise by mean distance, delay and number of flights. summary of what done, filter ones that have at least 20 flights that aren't going to honolulu
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")


#na.rm = TRUE remove the NA's which is important because will prevent from taking the mean of a column (mean of column would be NA otherwise)
#example:
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

#summarise_all will allow you to calc mean to all columns you typed in


########################################################################
#########################################################################
#HW will be to grab a data set and clean it up and do a few simple operations on it, california features dataset probably
#hasn't finished writing up the assignment yet, due before class next Friday
#when submit, give link to repository and name of file

#monday at 2pm in her office, office hours for naomi tague



