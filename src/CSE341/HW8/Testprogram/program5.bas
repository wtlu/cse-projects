10 LET X = 15.4
20 LET Y = 78.3
30 GOSUB 90
40 LET X = 19.8
50 LET Y = 82.3
60 GOSUB 90
70 PRINT "ALL DONE NOW"
80 GOTO 140
90 PRINT "X =", X
100 PRINT "Y =", Y
110 LET D = SQR(X*X + Y*Y)
120 PRINT "DISTANCE FROM ORIGIN =", D
130 RETURN
140 END
