#include <stdio.h>

//All notes are in the 4th octave unless noted
//0 = C = 261 Hz
//1 = D = 294 Hz
//2 = E = 330 Hz
//3 = F = 349 Hz
//4 = G = 392 Hz
//5 = A = 440 Hz
//6 = B = 494 Hz
//7 = C5 = 523 Hz

int instrument(int t, int note, int priority, int octaveShift, int keyShift) {
	int freq = 0;
	switch(note) {
		case 0:
		freq = 261;
		break;
		case 1:
		freq = 294;
		break;
		case 2:
		freq = 330;
		break;
		case 3:
		freq = 349;
		break;
		case 4:
		freq = 392;
		break;
		case 5:
		freq = 440;
		break;
		case 6:
		freq = 494;
		break;
		case 7:
		freq = 523;
		break;
	}
	if(octaveShift < 0) {
		int i;
		for(i = 0; i > octaveShift; i--) {
			freq /= 2;
		}
	} else if(octaveShift > 0) {
		int i;
		for(i = 0; i < octaveShift; i++) {
			freq *= 2;
		}
	}
	if(keyShift < 0) {
		int i;
		for(i = 0; i > keyShift; i--) {
			freq *= 94387;
			freq /= 100000;
		}
	} else if(keyShift > 0) {
		int i;
		for(i = 0; i < keyShift; i++) {
			freq *= 105946;
			freq /= 100000;
		}
	}
	return frequency(t, freq, priority);
}

//FIX: STARTING AT T = 18505, THERE IS A STRANGE BUZZING NOISE AND WEIRD CHARACTERS OUTPUTTED
//I NEED SLEEP BECAUSE THE REASON IS PROBABLY VERY OBVIOUS
//yeah it was obvious the int is overflowing kill me
//i guess when t goes negative it makes the sound of the spawn of satan
//gotta check and make sure the t is positive because
//honestly fuck ints right now
int frequency(int t, int hertz, int priority) {
	return (((256 * (unsigned int)t * hertz) / 8000) % 256) / (priority > 0 ? priority : 1);
}
