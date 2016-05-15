//All notes are in the 4th octave unless noted
//0 = C = 261 Hz
//1 = D = 294 Hz
//2 = E = 330 Hz
//3 = F = 349 Hz
//4 = G = 392 Hz
//5 = A = 440 Hz
//6 = B = 494 Hz
//7 = C_5 = 523 Hz

int instrument(int t, int note, int volume) {
	return t;
}

int frequency(int t, int hertz, int priority) {
	
}

int _frequency(int t, int frequency, int frequencyDivisor, int priority) {
	return (((t * frequency) / frequencyDivisor) % 256) / (priority > 0 ? priority : 1);
}
