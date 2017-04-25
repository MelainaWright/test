
sunlight = read.table("sun.txt", header=T)
par(mar=c(5,6,3,2))
boxplot(sunlight$Kdown_direct~sunlight$month,
  ylab="Downwelling Solar\n kj/m2/day",
<<<<<<< HEAD
  xlab="month", col="red")
=======
  xlab="month", col="blue")
>>>>>>> parent of a6cb372... made graph green

