sunlight = read.table("sun.txt", header=T)
par(mar=c(5,6,3,2))
boxplot(sunlight$Kdown_direct~sunlight$month,
<<<<<<< HEAD
        ylab="Downwelling Solar\n kj/m2/day",
        xlab="month", col="red")
=======
  ylab="Downwelling Solar\n kj/m2/day",
  xlab="month", col="red")
>>>>>>> 3841c6502ac8de1c69d7c1a95ba19a0fe894913c

