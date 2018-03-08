ltl spec {
	[] (((state == OFF0) && button) -> <> (state == OFF1)) &&
	[] (((state == OFF1) && button) -> <> (state == OFF2)) &&
	[] (((state == OFF2) && button) -> <> (state == OFF3)) &&
	[] ((state == OFF3) -> <> (state == ON0)) &&
	[] (((state == ON0) && button) -> <> (state == ON1)) &&
	[] (((state == ON1) && button) -> <> (state == ON2)) &&
	[] (((state == ON2) && button) -> <> (state == ON3)) &&
	[] ((state == ON3) -> <> (state == OFF0)) 
}

mtype={OFF0, OFF1, OFF2, OFF3, ON0, ON1, ON2, ON3};
bit button;
byte state;
#define timeout true

active proctype alarma_fsm () {
	state = OFF0;
	do
	:: (state == OFF0) -> atomic {
		if
		:: button -> state = OFF1; button = 0
		fi
		}
	:: (state == OFF1) -> atomic {
		if
		:: button -> state = OFF2; button = 0
		fi
		}
	:: (state == OFF2) -> atomic {
		if
		:: button -> state = OFF3; button = 0
		fi
		}
	:: (state == OFF3) -> atomic {
		if
		:: timeout -> state = ON0
		fi
		}
	:: (state == ON0) -> atomic {
		if
		:: button -> state = ON1; button = 0
		fi
		}
	:: (state == ON1) -> atomic {
		if
		:: button -> state = ON2; button = 0
		fi
		}
	:: (state == ON2) -> atomic {
		if
		:: button -> state = ON3; button = 0
		fi
		}
	:: (state == ON3) -> atomic {
		if
		:: timeout -> state = OFF0
		fi
		}
	od
}
active proctype entorno () {
	do
	::if
		:: button  = 1
		:: (! button) -> skip
	fi
	od
}