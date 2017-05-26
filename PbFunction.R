Pb = function(m, V, A, cRolling=0.015, cDrag=0.3, pAir=1.2, g=9.8) {
  Pb = cRolling*m*g*V + (0.5*A)*pAir*cDrag*(V^3)
  return(Pb)
}