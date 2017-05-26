###############################################################
#ESM 262: programming
#5/19/17

###############################################################
#simple example of a function:

# documentation that describes inputs, outputs and what the function does:
# FUNCTION NAME = function(inputs, parameters) {
#   body of the function (manipulation of inputs)
#     return(values to return)
# }
#save functions as an individual file: programname.R, so that can save them into a package in the future
#read into R by source("programname.R")
#any variables you use in your program will not be recognized/do not live outside of the function

#example:
power_gen = function(height, flow, rho=1000, g=9.8, Keff=0.8) {
  result = rho * height * flow * g * Keff
  return(result)
}
#rho=1000 is a default value

#plug in example values:
#power_gen(20,1) is the same as power_gen(height=20, flow=1)
power_gen(15, 2)


################################################################
#error-checking:

#ex. make it so can't input a negative value for height
power_gen = function(height, flow, rho=1000, g=9.8, Keff=0.8) {
  
  # make sure inputs are positive
  if (height < 0) return(NA)
  if (flow < 0) return(NA)
  if (rho < 0) return(NA)
  
  # calculate power
  result = rho * height * flow * g * Keff
  
  return(result)
} 
#return(NA) means that it outputs a warning value if height<0


###########################################################
#documentation should be put in a different R script than the function

#example:
# One of the equations used to compute automobile fuel efficiency is as follows this is
# the power required to keep a car moving at a given speed
# Pb = crolling * m *g*V + 1/2 A*pair*cdrag*V3

Pb = function(m, V, A, cRolling=0.015, cDrag=0.3, pAir=1.2, g=9.8) {
  Pb = cRolling*m*g*V + (0.5*A)*pAir*cDrag*(V^3)
  return(Pb)
}
v=seq(from=0, to=100, by=10) #run for mult values of V
Pb(31752, v, 9)


# where crolling and cdrag are rolling and aerodynamic resistive
# coefficients, typical values are 0.015 and 0.3, respectively.
# V: is vehicle speed (assuming no headwind) in m/s (or mps)
# m: is vehicle mass in kg
# A is surface area of car (m2)
# g: is acceleration due to gravity (9.8 m/s2)
# pair = density of air (1.2kg/m3)
# Pb is power in Watts
# Write a function to compute power, given a truck of m=31752 kg (parameters for a
#                                                                 heavy truck) for a range of different highway speeds
# plot power as a function of speed
# how does the curve change for a lighter vehicle
# Note that 1mph=0.477m/s


#will work if give it a vector of speeds
autopower = function(cdrag=0.3, crolling=0.015,pair=1.2,g=9.8,V,m,A) {
  P = crolling*m*g*V + 1/2*A*pair*cdrag*V**3
  return(P)
} 
v=seq(from=0, to=100, by=10)
plot(v, power(V=0.447*v, m=31752, A=25))
lines(v, power(V=0.447*v, m=61752, A=25)) 


#########################################################
#generate data to test and use function

# sequence
flow.ex = seq(from=1, to=100, by=5)
height.ex = 10
plot(flow.ex, power_gen(flow.ex, height=height.ex))


#random sample
#random numbers
# uniform distribution
Keff.sen = runif(min=0.5, max=1, n=10) #generates random numbers between 0.5 and 1


# run model over uniform distribution, one column for every value of Keff sensitivity coefficient, create value for power for each value of sensitivity coefficients
res = matrix(ncol=length(Keff.sen), nrow=length(flow.ex))
for (i in 1:length(Keff.sen))
  res[,i]=power_gen(flow.ex, height=height.ex, Keff.sen[i])


#alternatively, applies your function to a range of different values
Keff.sen = runif(min=0.5, max=1, n=10)
flow.ex=seq(from=1, to=10)
height.ex=10
res=apply(as.matrix(Keff.sen),1, power_gen, flow=flow.ex,
          height=height.ex)
#the 1 means apply the function across row and 2 means across the column

# for boxplot boxes are usually by columns, so transpose
boxplot(t(res), label=flow.ex, ylab="power (MW)", xlab="flow rate (m3/
        s)")




#Example: want to see how sensitive estimates of Pb are across a range of speeds given random variation in drag coefficients:
Pb = function(m, V, A, cDrag=0.3, cRolling=0.015, pAir=1.2, g=9.8) {
  Pb = cRolling*m*g*V + (0.5*A)*pAir*cDrag*(V^3)
  return(Pb)
}

cDrag.ex = runif(min=0.2, max=0.4, n=10)
V.ex=seq(from=1, to=10)

PowerGeneration=apply(as.matrix(cDrag.ex),1, Pb, m=31752, V=V.ex, A=9)
#apply function to data in the array (the matrix)
#need to make sure that ones have defaults for go to the left and those that don't have a default for, go to the right in the function otherwise apply wont work (it works here because the non-default parameters came first=good)

#or can do (may be wrong)
PowerGeneration2 = matrix(ncol=length(cDrag.ex), nrow=length(V.ex))
for (i in 1:length(cDrag.ex))
  PowerGeneration2[,i]=Pb(m=31752, V=V.ex, A=9, cDrag.ex[i])



#Another example: range of flow rates and heights and Keff from normal distrib:
Keff.sen = rnorm(mean=0.8, sd=0.1, n=20)
flow.ex = c(5,2,3,5,10)
height.ex = c(10,9,11,12,5)
res = apply(as.matrix(Keff.sen),1, power_gen, flow=flow.ex, height=height.ex)
boxplot(t(res), ylab="Power (MW)", xlab="Days")




#randomly sample from possible flow rates (not a random uniform distrib): 
height.ex = seq(from=20,to=0, by=-2)
possible.flow.rates = c(2,10,12)
flow.ex = sample(possible.flow.rates, replace=T, size=length(height.ex)) #replace means once take a variable, put it back; sample from possible flow rates
res = power_gen(flow=flow.ex, height=height.ex)
plot(res, type="l",lwd=3, col="red",ylab="Power (MW)", xlab="Days")



######################################################################
#factors: tell R that are dealing with a category rather than a number

a=c(1,5,2.5,9,5,2.5)
mean(a)

a=as.factor(c(1,5,2.5,9,5,2.5))
mean(a) #doesnt work because is factor
summary(a) #will tell you how many of each number you have

possible.fish = as.factor(c("salmon", "steelhead", "shark", "tuna", "cod"))
catch1= sample(possible.fish, size=10, replace=T)
catch1
#can count the number of times you catch cod or salmon etc.
summary(catch1)
mean(summary(catch1)) #mean count of something
max(summary(catch1)) #max count of something
which.max(summary(catch1))#which category had the max freq!!!!!!!!!!!!!


#example: simpson's diversity index: # of indiv in each species/ total number of spp
summary(((catch1)/sum(summary(catch1)))**2) #???


compute_simpson_index = function(species) {
  species = as.factor(species)
  tmp = (summary(species)/sum(summary(species))) ** 2
  diversity = sum(tmp)
  return(diversity)
}

catch1 = sample(possible.fish, size=10, replace=T)
catch2 = as.factor(c(rep("salmon", times=6),
                       rep("cod",times=4)))
compute_simpson_index(catch1)
#[1] 0.26
compute_simpson_index(catch2)
#[1] 0.52



###########################################################
#list: numbers of rows can be diff for diff columns, group diff variables, mostly use to return a bunch of variables from a function

#' Describe diversity based on a list of species
#'
#' Compute a species diversity index
#' @param species list of species (names, or code)
#' @return list with the following items
#' \describe{
#' \item{num}{ Number of distinct species}
#' \item{simpson}{Value of simpson diversity index}
#' \item{dominant}{Name of the most frequently occuring species}
#' }
#' @examples
#'
computediversity(c("butterfly","butterfly","mosquito","butterfly","ladybug","
                   ladybug"))

computediversity = function(species) {
  species = as.factor(species)
  tmp = (summary(species)/sum(summary(species))) ** 2
  diversity = sum(tmp)
  nspecies = length(summary(species))
  tmp = which.max(summary(species))
  dominant = names(summary(species)[tmp])
  return(list(num=nspecies, simpson=diversity, dominant=dominant))
} 
#returns three things when run function


#another example where return a list:
autopower = function(cdrag=0.3, crolling=0.015,pair=1.2,g=9.8,V,m,A) {
  P = crolling*m*g*V + 1/2*A*pair*cdrag*V**3
  maxP = max(P)
  minP = min(P)
  meanP = mean(P)
  return(list(P=P, maxP=maxP, minP=minP, meanP=meanP))
}

autopower(V=seq(from=0,to=100), m=12000, A=400)$maxP
#[1] 72176400


#or can group variables into a data frame:
costs = c(73,44)
quality = c("G","G")
purchased = c(100,22)
sales2 = data.frame(costs=costs, quality=quality,
                     purchased=purchased)



#another example of returning multiple things from a function:
Pb = function(m, V, A, cDrag=0.3, cRolling=0.015, pAir=1.2, g=9.8) {
  Pb = cRolling*m*g*V + (0.5*A)*pAir*cDrag*(V^3)
  maxPb= max(Pb)
  medPb = median(Pb)
  return(list(Pb=Pb, maxPb=maxPb, medPb=medPb))
}
Pb(V=10, m=12000, A=400)
Pb(V=seq(from=1, to=100), m=12000, A=400)$medPb
  

####################################
#ifelse, and making a function that does diff calculations for diff parameter values

#another example, good that can get an output that can be used as an input for different things
#' Compute seasonal mean flows
#'
#' This function computes winter and summer flows from a record
#’ @param str data frame with columns month and streamflow
compute_seasonal_meanflow = function(str) {
  
  str$season = ifelse( str$month %in%
                         c(1,2,3,10,11,12),"winter","summer")
  
  tmp = subset(str, str$season=="winter")
  mean.winter = mean(tmp$streamflow)
  
  tmp = subset(str, str$season=="summer")
  mean.summer = mean(tmp$streamflow)
  return(list(summer=mean.summer, winter=mean.winter))
}



#if month is these values then is winter, but if not it is summer
#If can also be used to choose what you return from a function #' Compute seasonal mean flows
#'
#' This function computes winter and summer flows from a record
#’ @param str data frame with columns month and streamflow

#if change kind, it will calculate different things; for example, if put "min" will calculate the min

#need a column that has "streamflow" and "tmp" and "season" in data for the function to work; need to tell user that need those columns

str=read.table("str.txt")

compute_seasonal_flow = function(str, kind="mean") {

  str$season = ifelse( str$month %in%
                         c(1,2,3,10,11,12),"winter","summer")
  
  
  tmp = subset(str, str$season=="winter")
  if(kind=="mean") winter= mean(tmp$streamflow)
  if(kind=="max") winter= max(tmp$streamflow)
  if(kind=="min") winter=min(tmp$streamflow)
  
  tmp = subset(str, str$season=="summer")
  if(kind=="mean") summer= mean(tmp$streamflow)
  if(kind=="max") summer= max(tmp$streamflow)
  if(kind=="min") summer=min(tmp$streamflow)
  
  return(list(summer=summer, winter=winter))
}


############################################################
#use parameter to make decisions about what do example:

#' compute annual yield NPV
#'
#' Function to compute yeild of different fruits as a function of annual temperature and precipitation
#' @param T annual temperature (C)
#' @param P annual precipitation (mm)
#' @param ts slope on temperature
#' @param tp slope on precipitation
#' @param intercept (kg)
#' @param irr Y or N (default N)
#’ @param discount (default=0.02)
#’ @price price $ (default=2)
#' @return total yield in kg and NPV of yield

compute_yield_NPV = function(T, P, ts, tp, intercept, irr=“N”, discount=0.02, price=2) {
  if ((length(T) != length(P)) & (irr==“N”) ) {
    return(“annual precip and annual T are not the same length”)
  }
  yield = rep(0, times=length(T))
  for ( in 1:length(T)) {
    if (irr=="N"){
      yield[i] = tp*P[i] + ts*T[i] + intercept
      yieldnpv[i] = compute_NPV(yield[i]*price, discount, i)
    }
    else {
      yield[i] = ts*T[i] + intercept
      yieldnpv[i] = compute_NPV(yield[i]*price, discount, i)
    }
    return(list(totalyield=sum(yield), profit=sum(yieldnpv))
  }



  
#######################################################################
#for loops

  #for values between 1:n, perform these statements
for (i in 1:n) { statements}
  
x=0 #give initial condition
for (alpha in 1:4) { x = x+alpha}
  #do what is in {} for 1, 2, 3, and 4
  
for(i in 1:10) {x=x+i}
#10 could be a vector that put in


#nest loops inside of each other, example loop over time and space (one loop calls another loop)
compute_NPV = function(value, time, discount) {
  result = value / (1 + discount)**time
  result
}

#calc NPV for range of interest rates and range of damages that might occur in future; store results in a maxtrix with each row for each damage and column for discount rate; want to run function for each possible combo of discount rate and damage so nest the for loops!!!!
damages = c(25,33,91,24)
discount.rates = seq(from=0.01, to=0.04, by=0.005)
yr=10
npvs = as.data.frame(matrix(nrow=length(damages), ncol=length(discount.rates)))
for (i in 1:length(damages)) {
  for (j in 1:length(discount.rates)) {
  npvs[i,j]= compute_npv(net=damages[i], dis=discount.rates[j],yr )
   }
 }
#does all values of discount rates for the first value for damages; do inner loop and finish it and then go to next value of outerloop, so do i=25 for each discount rate in the sequence and then i=33
npvs
# V1 V2 V3 V4 V5 V6 V7
# 1 22.63217 21.54168 20.50871 19.52996 18.60235 17.72297 16.88910
# 2 29.87447 28.43502 27.07149 25.77955 24.55510 23.39432 22.29362
# 3 82.38111 78.41172 74.65170 71.08905 67.71255 64.51161 61.47634
# 4 21.72689 20.68001 19.68836 18.74876 17.85825 17.01405 16.21354

#rename columns and rows to make it easier to understand
colnames(npvs)=discount.rates
rownames(npvs)=damages
npvs
#    0.01     0.015    0.02     0.025    0.03     0.035    0.04
# 25 22.63217 21.54168 20.50871 19.52996 18.60235 17.72297 16.88910
# 33 29.87447 28.43502 27.07149 25.77955 24.55510 23.39432 22.29362
# 91 82.38111 78.41172 74.65170 71.08905 67.71255 64.51161 61.47634
# 24 21.72689 20.68001 19.68836 18.74876 17.85825 17.01405 16.21354


#gather gives what each npv is for each discount rates
library(tidyr)
npvs = gather(npvs, 1:7, key=dis, value=npv)
head(npvs)
ggplot(npvs, aes(x=npv, col=as.factor(dis)))
+geom_density(size=2)+scale_color_brewer(type="seq",
                                         name="Discount") 

  

######################################################
#while loop, accumulate something until reach a threshold value, don't know how long it will take a pop to reach a certain size

#keep adding numbers until alpha gets to 100
alpha = 0
x = 0
while (alpha < 100) { alpha = alpha + x; x = x+1}
x
# [1] 15
alpha
# [1] 105
# 
# alpha = (1+2+3+4+5+6+7+8+9+10+11+12+13+14) = 105


#another example:
yr=1
pollutant.level = 5
while (pollutant.level < 30 ) {
  pollutant.level = pollutant.level + 0.01* pollutant.level
  yr = yr + 1
  }




########################################################
#loop in a function

#bring in some variables, do error checking (if length of temp and precip isn't the same, return an error), initialize the yield value, calc NPV for arrays, for each value in temp if don't have irrigation this is the value for yield, 


compute_yield_NPV = function(T, P, ts, tp, intercept, irr=“N”, discount=0.02, price=2) {
  if ((length(T) != length(P)) & (irr==“N”) ) {
    return(“annual precip and annual T are not the same length”)
  }
  yield = rep(0, times=length(T))
  yieldnpv=rep(0, times=length(T))
  for ( in 1:length(T)) {
    if (irr=="N"){
      yield[i] = tp*P[i] + ts*T[i] + intercept
      yieldnpv[i] = compute_NPV(yield[i]*price, discount, i)
    }
    else {
      yield[i] = ts*T[i] + intercept
      yieldnpv[i] = compute_NPV(yield[i]*price, discount, i)
    }
    return(list(totalyield=sum(yield), profit=sum(yieldnpv))
  }


  
  #open file and source it on R to open the function


