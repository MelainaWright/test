###################################
#Week 4: visualization; ggplot
#05/12/2017

#read in data
thinshallow = read.table("resthin.shallow.txt", header=T)
thindeep = read.table("resthin.deep.txt", header=T)
clim=read.table("sierraclim.txt",header=T)

#make sure you have libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)
library(lubridate)



#######################simple example########################################
# #GGPLOT is a "grammer of graphics", in other words a set of elements (like words, phrases) that you can put together to make a plot. A "grammer" is more flexible than standard plotting; but a bit harder to learn In ggplot, we combine the following element:
# data: a data set used to generate the plot
# geoms visual character of the plot- boxplot, scatter plot
# aesthetics what gets put into the geom
# themes characteristics of plotting environment (axis label font...)
# GGPLOT is organized in a way that you can build a very complex plot by adding pieces to it


# basic plot
ggplot(clim, aes(y=tmax, x=month))+geom_point()

# would look bettter as a boxplot
#turn things to factors in ggplot to make it work, it interprets it as a category not a number!!!!!!!!!!!!!!!!!!!!!!!
ggplot(clim, aes(y=tmax, x=as.factor(month)))+geom_boxplot()

# save the basic plot so we can add to it
p=ggplot(clim, aes(y=tmax, x=as.factor(month)))+geom_boxplot()

p+labs(y="Maximum Temperature", x="Month")
p = p + labs(y="Maximum Temperature", x="Month")
p





#################################titles#######################################################
# themes are used to control character of the plot
#(see labs and titles) but themes give you alot of control on your plot elements

# plot.title
# axis.title
# axis.title.x
# axis.title.y
# axis.text
# axis.text.y
# I'll also show you the use of expression to write math symbols as labs
#  More on all the options that can be found with themes


pclr =ggplot(clim, aes(y=tmax, x=as.factor(month)))+geom_boxplot()
pclr = pclr + labs(y="Maximum Temperature", x="Month")
pclr = pclr+theme(axis.text= element_text(face="bold", colour="red", size=14))
pclr = pclr +  geom_hline(yintercept=0, col="yellow", size=4)
pclr

#lets say we want to color in the boxes - this is inside the boxplto so can't add
p = ggplot(clim, aes(y=tmax, x=as.factor(month)))+geom_boxplot(col="rosybrown3", fill="red")
p
# useful to see color options
colors()

p = p + labs(y= expression(paste("Maximum Temperature ",C**degree)), x="Month") 
p= p+theme(axis.text= element_text(face="bold", colour="steelblue", size=14), 
           axis.title=element_text(face="italic", size=14))
p 
p = p+  ggtitle("Monthly Temperature in Sierras")
p

# notice how themes keep inheriting - so you can call theme multiple times
p + coord_flip() 
p=p + coord_flip() + theme(plot.margin=unit(c(1,3,1,3),"cm")) # top right bottom left
p
p = p + theme(plot.title=element_text(size=16, hjust=0.5), plot.background=element_rect(fill="peachpuff1")) 
p

# to display more than one plot (a "matrix" or grid of plots)

grid.arrange(p,pclr)
# or to control to make by col
grid.arrange(p, pclr, ncol=2)

# there are also built in themes
pclr = pclr+theme_bw()
pclr






############################different types of plots (geoms)############################################################
# There are many different geoms (geometries) - lets try the standard ones
# scatter plot


p2=ggplot(clim, aes(x=tmax, y=tmin))+geom_point(col="blue", shape=9, size=rel(4))
p2
p2=p2+labs(x="Max Temp C", y="Min Temp C") 
p2 = p2+ ggtitle("How does daily maximim and min temp compare")
p2 = p2 + geom_abline(intercept=0,slope=1, colour="yellow", size=4)
p2

#density plot
p3=ggplot(clim, aes(x=rain))+geom_density()
p3
p3 = ggplot(subset(clim, clim$rain > 0), aes(x=rain))+geom_density(fill="blue")
#p4=ggplot(clim, aes(x=date,y=rain))+geom_line()+ggtitle("Line Graph")
p3
#fix issue with date
clim$date = mdy(paste(clim$month, clim$day, clim$year, sep="/"))
p4=ggplot(clim, aes(x=date,y=rain))+geom_line()+ggtitle("Line Graph")
p4
grid.arrange(p,p2,p3,p4)





##############################aethetics#######################################################
# easy to visualize your data in ways that highlight different attributes - this can help you to see multiple dimensions at once There are multiple ways to do this
# 
# color/size/shape (within plots)
# facets (between plots)
# Lets start with color We can use a more interesting data set thindeep
# 
# This dataset is results of a simulation experiment that looks at the impacts of different levels of forest thinning on water and carbon fluxes for a site in the California Sierra
# 
# The site/plot is simulated for 10 years following the thinning experiment.
# The thinning experiment is repeated for different start dates within a 50 year historic climate record,
# And for different thinning intensities
# And for different types of thinning that try to maximize or minimize sharing of water between trees



# ok lets look at how biomass recovers
p1=ggplot(thindeep, aes(x=as.factor(wy), y=plantc))+geom_boxplot()
p1 = p1+labs(x="Years since thinning", y="Biomass")
p1 = p1 +theme(axis.text= element_text(face="bold", size=14), 
               plot.margin = unit(c(15,15,15,5),"pt"), axis.title = element_text(size=14))
p1
# but boxplots include all thinning intensities - maybe we want to separate those out

p1=ggplot(thindeep, aes(x=as.factor(wy), y=plantc, col=as.factor(thin)))+geom_boxplot()
p1 = p1+labs(x="Years since thinning", y="Biomass")
p1 = p1 +theme(axis.text= element_text(face="bold", size=14), 
               plot.margin = unit(c(15,15,15,5),"pt"), axis.title = element_text(size=14))

# or we could base the filling of the boxplots on thinning intensity

p1=ggplot(thindeep, aes(x=as.factor(wy), y=plantc, fill=as.factor(thin)))+geom_boxplot()
p1 = p1+labs(x="Years since thinning", y="Biomass")
p1 = p1 +theme(axis.text= element_text(face="bold", size=14), 
               plot.margin = unit(c(15,15,15,5),"pt"), axis.title = element_text(size=14))





####################################themes####################################################
# control formatting and scale_color_discrete to control content There are many other ways to change color maps - see
# 
# scale_colour_hue
# scale_fill_hue
# scale_color_brewer
# scale_color_brewer
# Brewer is really cool and comes up with nice options for you and gives you a menu of color scheme for sequential vs divergin vs qualitative data and has optins that are printer friendly, color blind friendly -to check it out -
#   colors that work
# implemented R color palettes
# more R and colors
# or for continues
# scale_color_continuous


# assuming qualitative
p1 + scale_fill_brewer(type="qual", palette="Dark2")
p1 + scale_fill_brewer(type="qual", palette="Set3")

# but actually sequential so can using diverging palettes - diverse from center
p1 + scale_fill_brewer(type="div", palette="PiYG")

# but actually sequential so can using diverging palettes - diverse from center
p1 + scale_fill_brewer(type="seq", palette="BuGn")

# and can add names
lnms = c("None","Low","Med","High")
p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms)

# using themes to change legend format - position
p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position="bottom")

p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position=c(0.1,0.9))

p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position=c(0.1,0.9), legend.background=element_rect(fill="seashell2")) 





#################################summarize graphs (take mean)######################################################3
#automatically summarize graph and added to our plot Lets say we also want to show the means as lines


# assuming qualitative
p1 + scale_fill_brewer(type="qual", palette="Dark2")
p1 + scale_fill_brewer(type="qual", palette="Set3")

# but actually sequential so can using diverging palettes - diverse from center
p1 + scale_fill_brewer(type="div", palette="PiYG")

# but actually sequential so can using diverging palettes - diverse from center
p1 + scale_fill_brewer(type="seq", palette="BuGn")

# and can add names
lnms = c("None","Low","Med","High")
p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms)

# using themes to change legend format - position
p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position="bottom")

p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position=c(0.1,0.9))

p1 + scale_fill_brewer(type="seq", palette="BuGn", name="Thin Intensity", labels=lnms) +
  theme(legend.position=c(0.1,0.9), legend.background=element_rect(fill="seashell2")) 





##########################facets: separate things into different graphs################################################
#lets say we wanted a separate graph for each thinning intensity so we could see how decade impacted recovery


# first lets color by decade/scenario
p2 = ggplot(thindeep, aes(x=wy, y=plantc, col=as.factor(scen)))+ stat_summary(fun.y="mean",geom="line", aes(col=as.factor(scen)))
p2
# now lets separate out the thinning intensities
p2= p2+facet_wrap(~as.factor(thin))
p2

# make prettier
p2 = ggplot(thindeep, aes(x=wy, y=plantc, col=as.factor(scen)))+ stat_summary(fun.y="mean",geom="line", size=2, aes(col=as.factor(scen)))
p2= p2+facet_wrap(~as.factor(thin)) 
p2 + scale_color_brewer(type="qual", palette="Set3", name="Decade") 
p2

