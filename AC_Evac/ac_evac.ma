#include(ac_evac.inc)

[top]
components : ac_evac

[ac_evac]
type : cell
dim : (12, 63, 2)
delay : transport
defaultDelayTime  : 100
border : nowrapped 

%Floor plane
neighbors :                  ac_evac(-2,0,0)				%used to detect door
neighbors : ac_evac(-1,-1,0) ac_evac(-1,0,0) ac_evac(-1,1,0) 	% NW, N, NE
neighbors : ac_evac(0,-1,0)  ac_evac(0,0,0)  ac_evac(0,1,0) 	% W, Orig, E
neighbors : ac_evac(1,-1,0)  ac_evac(1,0,0)  ac_evac(1,1,0)  	% SW, S, SE
neighbors :                  ac_evac(2,0,0) 				%used to detect door

%Dist plane to access floor plane
neighbors : ac_evac(-1,-1,-1) ac_evac(-1,0,-1) ac_evac(-1,1,-1) 	% NW, N, NE
neighbors : ac_evac(0,-1,-1)  ac_evac(0,0,-1)  ac_evac(0,1,-1) 	% W, Orig, E
neighbors : ac_evac(1,-1,-1)  ac_evac(1,0,-1)  ac_evac(1,1,-1)  	% SW, S, SE

%Floor plane to access dist plane
neighbors :                                   ac_evac(-2,0,1)
neighbors :                  ac_evac(-1,-1,1) ac_evac(-1,0,1) ac_evac(-1,1,1) 	% NW, N, NE
neighbors : ac_evac(0,-2,1)  ac_evac(0,-1,1)  ac_evac(0,0,1)  ac_evac(0,1,1) ac_evac(0,2,1)	% W, Orig, E
neighbors :                  ac_evac(1,-1,1)  ac_evac(1,0,1)  ac_evac(1,1,1)  	% SW, S, SE
neighbors :                                   ac_evac(2,0,1)

%Use file AC_Evac.val to initialise floor plan
initialvalue : -1
initialCellsValue : ac_evac.val

%Seating floor plane
zone : prt_seats   { (1,0,0)..(5,62,0) }
zone : stb_seats   { (6,0,0)..(10,62,0) }
%zone : floor_plane	{ (3,0,0)..(8,20,0) }
%zone : wall	{(0,0,0)..(0,20,0) (11,0,0)..(11,20,0)}

%Distance plane
zone : dist_plane 	{ (0,0,1)..(11,62,1) }

localtransition : evac-rule

[dist_plane]
#Macro(DistCalc)
rule : {(0,0,0)} 100 { t }

[exit]
%Exit
%TODO add check sime time greater than ... 14sec
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit down
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (-1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit up
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,1,0)=9 and (time >= #Macro(OpenDelay))} %exit right
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,-1,0)=9 and (time >= #Macro(OpenDelay))} %exit left

[prt_seats]
%TODO add check sime time greater than ... 14sec
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit down
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (-1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit up
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,1,0)=9 and (time >= #Macro(OpenDelay))} %exit right
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,-1,0)=9 and (time >= #Macro(OpenDelay))} %exit left

%Leaving down(has priority), up next
rule : 0 #Macro(Speed) {(0,0,0)=-2 and (1,0,0)=0 and (1,0,1)<=(0,0,1)} %move down
rule : 0 #Macro(Speed) {(0,0,0)=-2 and ((-1,0,0)=0 and (-1,0,1)<(0,0,1)) and ((-2,0,0)!=-2 or (-2,0,1)<(-1,0,1))} %move up

%Leaving right giving way to up/down trafic but not if heading away from ilse
rule : 0 #Macro(Speed) {#Macro(WantRight) and ((-1,1,0)!=-2) and (1,1,0)!=-2} %move right with give way to down and up
rule : 0 #Macro(Speed) {#Macro(WantRight) and (1,1,0)!=-2 and ((-1,1,0)=-2 and (-1,1,1)<(0,1,1))} %When next row right is exit row (moving up)
rule : 0 #Macro(Speed) {#Macro(WantRight) and (-1,1,0)!=-2 and ((1,1,0)=-2 and (1,1,1)<(0,1,1))} %When next row right is exit row (moving down)
%Leaving left giving way to up/down trafic but not if heading away from ilse
rule : 0 #Macro(Speed) {#Macro(WantLeft) and ((-1,-1,0)!=-2) and (1,-1,0)!=-2} %move left with give way to down and up
rule : 0 #Macro(Speed) {#Macro(WantLeft) and (1,-1,0)!=-2 and ((-1,-1,0)=-2 and (-1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)
rule : 0 #Macro(Speed) {#Macro(WantLeft) and (-1,-1,0)!=-2 and ((1,-1,0)=-2 and (1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)

%Entering cell
rule : -2 #Macro(Speed) {(0,0,0)=0 and (-1,0,0)=-2 and (-1,0,1)>=(0,0,1)} %receive from up
rule : -2 #Macro(Speed) {(0,0,0)=0 and (1,0,0)=-2 and (1,0,1)>(0,0,1)} %receive from down
rule : -2 #Macro(Speed) {(0,0,0)=0 and (0,-1,0)=-2 and (0,-1,1)>=(0,0,1)} %receive from left
rule : -2 #Macro(Speed) {(0,0,0)=0 and (0,1,0)=-2 and (0,1,1)>(0,0,1) and (0,2,1)>(0,1,1)} %receive from right

%else don't change
rule : {(0,0,0)} #Macro(Speed) { t } 

[stb_seats]
%Exit
%TODO add check sime time greater than ... 14sec
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit down
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (-1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit up
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,1,0)=9 and (time >= #Macro(OpenDelay))} %exit right
rule : 0 #Macro(DoorDelay) {(0,0,0)=-2 and (0,-1,0)=9 and (time >= #Macro(OpenDelay))} %exit left

%Leaving up(has priority), down next
rule : 0 #Macro(Speed) {(0,0,0)=-2 and (1,0,0)=0 and (1,0,1)<=(0,0,1) and ((2,0,0)!=-2 or (2,0,1)<(1,0,1)) } %move down
rule : 0 #Macro(Speed) {(0,0,0)=-2 and (-1,0,0)=0 and (-1,0,1)<(0,0,1)} %move up

%Leaving right giving way to up/down trafic but not if heading away from ilse
rule : 0 #Macro(Speed) {#Macro(WantRight) and ((-1,1,0)!=-2) and (1,1,0)!=-2} %move right with give way to down and up
rule : 0 #Macro(Speed) {#Macro(WantRight) and (1,1,0)!=-2 and ((-1,1,0)=-2 and (-1,1,1)<(0,1,1))} %When next row right is exit row (moving up)
rule : 0 #Macro(Speed) {#Macro(WantRight) and (-1,1,0)!=-2 and ((1,1,0)=-2 and (1,1,1)<(0,1,1))} %When next row right is exit row (moving down)
%Leaving left giving way to up/down trafic but not if heading away from ilse
rule : 0 #Macro(Speed) {#Macro(WantLeft) and ((-1,-1,0)!=-2) and (1,-1,0)!=-2} %move left with give way to down and up
rule : 0 #Macro(Speed) {#Macro(WantLeft) and (1,-1,0)!=-2 and ((-1,-1,0)=-2 and (-1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)
rule : 0 #Macro(Speed) {#Macro(WantLeft) and (-1,-1,0)!=-2 and ((1,-1,0)=-2 and (1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)

%Entering cell
rule : -2 #Macro(Speed) {(0,0,0)=0 and (-1,0,0)=-2 and (-1,0,1)>=(0,0,1)} %receive from up
rule : -2 #Macro(Speed) {(0,0,0)=0 and (1,0,0)=-2 and (1,0,1)>(0,0,1)} %receive from down
rule : -2 #Macro(Speed) {(0,0,0)=0 and (0,-1,0)=-2 and (0,-1,1)>=(0,0,1)} %receive from left
rule : -2 #Macro(Speed) {(0,0,0)=0 and (0,1,0)=-2 and (0,1,1)>(0,0,1) and (0,2,1)>(0,1,1)} %receive from right

%else don't change
rule : {(0,0,0)} #Macro(Speed) { t } 

[floor_plane]
%Exit
%TODO add check sime time greater than ... 14sec
rule : 0 #Macro(DoorDelay) { (0,0,0)=-2 and (1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit down
rule : 0 #Macro(DoorDelay) { (0,0,0)=-2 and (-1,0,0)=9 and (time >= #Macro(OpenDelay))} %exit up
rule : 0 #Macro(DoorDelay) { (0,0,0)=-2 and (0,1,0)=9 and (time >= #Macro(OpenDelay))} %exit right
rule : 0 #Macro(DoorDelay) { (0,0,0)=-2 and (0,-1,0)=9 and (time >= #Macro(OpenDelay))} %exit left

%Leaving down(has priority), up next
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (1,0,0)=0 and (1,0,1 <=(0,0,1)} %move down
rule : 0 #Macro(Speed) { (0,0,0)=-2 and ((-1,0,0)=0 and (-1,0,1)<(0,0,1)) and ((-2,0,0)!=-2 or (-2,0,1)<(-1,0,1))} %move up

%Leaving right, left giving way to up/down trafic but not if heading away from ilse
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,1,0)=0 and ((-1,1,0)!=-2) and (1,1,0)!=-2 and (0,1,1)<=(0,0,1)} %move right with give way to down and up
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,1,0)=0 and ((-1,1,0)=-2 and (-1,1,1)<(0,1,1))} %When next row right is exit row (moving up)
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,1,0)=0 and ((1,1,0)=-2 and (1,1,1)<(0,1,1))} %When next row right is exit row (moving down)
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,-1,0)=0 and ((-1,-1,0)!=-2) and (1,-1,0)!=-2 and (0,-1,1)<(0,0,1)} %move left with give way to down and up
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,-1,0)=0 and ((-1,-1,0)=-2 and (-1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)
rule : 0 #Macro(Speed) { (0,0,0)=-2 and (0,-1,0)=0 and ((1,-1,0)=-2 and (1,-1,1)<(0,-1,1))} %When next row left is exit row (moving up)

%Entering cell
rule : -2 #Macro(Speed) { (0,0,0)=0 and (-1,0,0)=-2 and (-1,0,1)>=(0,0,1)} %receive from up
rule : -2 #Macro(Speed) { (0,0,0)=0 and (1,0,0)=-2 and (1,0,1)>(0,0,1)} %receive from down
rule : -2 #Macro(Speed) { (0,0,0)=0 and (0,-1,0)=-2 and (0,-1,1)>=(0,0,1)} %receive from left
rule : -2 #Macro(Speed) { (0,0,0)=0 and (0,1,0)=-2 and (0,1,1)>(0,0,1) and (0,2,1)>(0,1,1)} %receive from right

%else don't change
rule : {(0,0,0)} #Macro(Speed) { t } 

[evac-rule]
rule : {(0,0,0)} #Macro(Speed) { t } 