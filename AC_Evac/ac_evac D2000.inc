Speed of travel
#BeginMacro(Speed)
1000
#EndMacro

TODO ADD RANDOM
#BeginMacro(DoorDelay)
{1000 + 2000}
#EndMacro

Initial emergency door opening time 14 seconds
#BeginMacro(OpenDelay)
0
#EndMacro

#BeginMacro(WantRight)
( (0,0,0)=-2 and (0,1,0)=0 and (0,1,1)<(0,0,1) )
#EndMacro

#BeginMacro(WantLeft)
( (0,0,0)=-2 and (0,-1,0)=0 and (0,-1,1)<(0,0,1) )
#EndMacro
Calculate distance from emergency exit door
-1 represent a wall
Exit doors are set at zero
Distance calculated from the doors in 4 directions
#BeginMacro(DistCalc)
rule : -1           0 { (0,0,-1) = -1 }
rule : 0            0 { (0,0,-1) = 9 }
rule : {(1,0,0)+1}  0 { (0,0,0) < 0 and (1,0,0)  >= 0 }
rule : {(-1,0,0)+1} 0 { (0,0,0) < 0 and (-1,0,0) >= 0 }
rule : {(0,1,0)+1}  0 { (0,0,0) < 0 and (0,1,0)  >= 0 }
rule : {(0,-1,0)+1} 0 { (0,0,0) < 0 and (0,-1,0) >= 0 }
#EndMacro