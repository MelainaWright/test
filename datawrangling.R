#############################################################
#ESM 262
#4/28/17
#datawrangling part 1 - importing and tidying
#book: R for data wrangling, Grolemund and Wickham

install.packages("tidyverse")
library(tidyverse)

###############################################################
#tibbles

#tibble is like a data frame but easier to work with

X = as_tibble(iris) #alt minus to get the arrow

#factors can only have the names in the set list. it's a controlled character column. can't create a new column and make setosa = shark

#create tibble from scratch
tibble(
  x=1:5,
  y=1,
  z=x^2 + y
) #length of y is 1 so repeated it so it was 5 big as per what x is; y=1:3 wouldn't work; so unlike with dataframe, can have length 1 or length of x

#can have a column name in a tibble that is a number (unlike dataframe)
tb <- tibble(
  ":)" = "smile")

df <- tibble(
x=runif(5),
y=rnorm(5))

#put in console
#Wright, Melaina (""sharklady""), "11,3 Foobar Terrace"
#make it understand that quotes are not to protect the data but are part of the data name
#doubled double quote = single quote. single double quote quotes everything until the next double quote

getwd()
setwd("C:/Users/melai/Documents/BrenSpring2017/ESM262/test2/wrangle")

heights = read.csv("data/heights.csv")
#can tell it how to read a column in as numeric or whatever


#####################################################################
#importing terrible data


##excel would read the bottom stuff as a csv but the beginning metadata, it couldn't deal with this
#; kelp abundance in this transect
#; collected in 2001
#;
#transect,point,abundance
#786,8,5.5

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip=2) #ignore first two lines of code

read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment= "#")

#has no column names, don't treat the first row as column names
read_csv("1,2,3\n4,5,6", col_names = FALSE)

#has no column names, don't treat the first row as column names, give it column names
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))


##########################################################################
#importing terrible data example/parsing

ca = read_csv("data/CA_Features_20170401.zip")

#unzipped it but is not deliminated correctly
ca = read_delim("data/CA_Features_20170401.zip", delim="|")
#parsed means what function it used to create columns into integers, for example
View(ca)

#parsing - breaking it up into chunks that recognize and give name to chunk
#have different functions to break it up
x = parse_logical(c("TRUE","FALSE", "NA")) #works, returns a vector of logical values
str(x) #more verbose representation of what it is

y= parse_logical(c("TRUE","FALSE","NA", 42)) #didnt work
problems(y)
View(problems(y)) #expected 1/0/T/F/TRUE/FALSE but got the value 42

#when reads in characters, assumes characters are in UTF-8 format (look it up). R can read tildes and wear language characters and stuff


#want to test to see if a vector is a factor; build a vector of the acceptable values (levels)
fruit <- c("apple","banana")
parse_factor(c("apple","banana","sharks"), levels = fruit) #see if they are factors that meet our constraint of having to be apple and banana
Z = parse_factor(c("apple","banana","banana"), levels = fruit) #tells what the levels are when type Z into console


parse_datetime("2010-10-01") #year, month, day
#check to see if vector has the types of data you think it does and then convert those values if it doesnt
#convert vector of character value into other types if it is possible to be done
guess_parser("2017-04-28") #tells you what it thinks it is. it says it is a date
guess_parser("3/7/2017") #thinks it is a character, not a date
str(parse_guess("2017-04-28")) #says it knows it is a date


#force read csv to apply specific typing to stuff when it gets imported in
challenge <- read_csv(readr_example("challenge.csv")) #there are issues starting in row1001 where the x column doesn't look like an integer, instead it has "trailing characters" so use a double (a number like 1.123 or 45849; don't have to have decimals)

#force numbers to be read by a diff type; read the x column with this function and y column with this function
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)


tail(challenge) #last few values look like dates so change to dates
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

#if did challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001) wouldn't have had to manually guess b/c would have included the trouble columns and it would've known it should be double and date


#######################################################################
#Unknown and 99999999 (for age) and 0 (for lat and long coordinates) values

#"unknown" value in data
ca$PRIMARY_LAT_DMS <- parse_character(ca$PRIMARY_LAT_DMS, na="Unknown") #got a vector back; need to stuff it back into the original data, so stuff it in; take this guy and then replace itself
#what if have like 9999999 as a fake number for an unknown age (do same thing just put 9999 instead of unknown)
#successfully gets rid of unknowns and na; NA droped out because were doing a comparison/sort
#can read it in and change unknowns to NAs at the same time


#######################################################################
#write data after cleaned up it

getwd()
write_csv(challenge,"challenge.csv") #forgot it is doubles not integer and dates not NA
read_csv("challenge.csv") #can then read it in as double and date

library(feather)
write_feather(challenge, "challenge.feather") #save tibble as a feather andthen can read into python
read_feather("challenge.feather") #has metadata in it and will remember that this column is a date and this one is a double, etc.


###########################################################################################
#tidying: table rearrangement

#got a tibble, types of data are correct, dealt with missing data; but it is not organized the write way to do what you want to do with it

#example of badly arranged data; info of the content is the same but is not arranged the same way in the following tables:
View(table1)
View(table2) #column describes what the next column means
View(table3) #two values smudged together in same cell
View(table4a) #variable values get converted into column names
View(table4b)

#want to reformat everything to be in the format of table 1. Every variable has its own column. Every obs has its own row. Each cell has its own value in it -> first normal form
#each row=a coherent observation, select rows
#aggregrate by variable in columns
#every cell has a value that is calcuable


#gathering######################################

#gathering for table 4a example to collapse values into a single column
tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
#%>%take what comes out of doing what goes before and make it the first argument of the next function

#same thing
tidy4a <- gather(table4a, `1999`, `2000`, key = "year", value = "cases")
View(tidy4a)


tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")


#join tables together###########################
left_join(tidy4a, tidy4b)




#spreading#######################################
spread(table2, key = type, value = count)



#separating####################################
table3 %>% 
  separate(rate, into = c("cases", "population"))










