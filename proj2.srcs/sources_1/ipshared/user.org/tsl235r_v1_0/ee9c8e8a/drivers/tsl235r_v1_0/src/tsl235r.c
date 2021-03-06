

/***************************** Include Files *******************************/
#include "tsl235r.h"

/************************** Function Definitions ***************************/

volatile static int PWDetRefClkFrequency = 10000000;
volatile static int UpperCalibratedThreshold = 1000;
volatile static int LowerCalibratedThreshold = 10;
volatile static int UpperScaledThreshold = 1023;
volatile static int LowerScaledThreshold = 0;


int TSL235R_GetFrequency(void* baseaddr_p) {

	int PWMCycTime;
	int PWMFreq = 0;

	u32 *tsl235rHiTimePort = (u32*) baseaddr_p;

	PWMCycTime = (int) *tsl235rHiTimePort * 2;

	PWMFreq = PWDetRefClkFrequency / PWMCycTime;

	return PWMFreq;
}

int TSL235R_GetIntensity(void* baseaddr_p) {

	int frequency;

	frequency = TSL235R_GetFrequency(baseaddr_p);

	return map(frequency, LowerCalibratedThreshold, UpperCalibratedThreshold, 
			LowerScaledThreshold, UpperScaledThreshold);
}

void 	TSL235R_SetMinThreshold(void* baseaddr_p) {

	LowerCalibratedThreshold = TSL235R_GetFrequency(baseaddr_p);
}

void 	TSL235R_SetMaxThreshold(void* baseaddr_p) {

	UpperCalibratedThreshold = TSL235R_GetFrequency(baseaddr_p);
}

void  TSL235R_SetScaledLimits(int lower, int upper) {

	LowerScaledThreshold = lower;
	UpperScaledThreshold = upper;
}

int map(int x, int in_min, int in_max, int out_min, int out_max) {
	if ((in_max - in_min) > (out_max - out_min)) {
		return (x - in_min) * (out_max - out_min+1) / (in_max - in_min+1) + out_min;
	}
	else {
		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}
}
