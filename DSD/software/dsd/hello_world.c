/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include "stdlib.h"
#include "sys/alt_stdio.h"
#include <sys/alt_alarm.h>
#include "sys/times.h"
#include "alt_types.h"
#include "system.h"
#include <stdio.h>
#include <unistd.h>
#include "altera_avalon_pio_regs.h"

#include "./fp_custom/fp_custom.h"

#define MXSIZE 3

float **tempmat;
/*
int alt_main()
{
	float a = 2.5;
	float b = 1.9;
	float c = 0;
	c = FP_ADD_CI(a,b);

	return 0;
}*/
/*
void rswap (float **tempmat, size_t i, size_t j){
	float *tmp = tempmat[i];
	tempmat[i] = tempmat[j];
	tempmat[j] = tmp;
}

float detmat(volatile float matrix[][MXSIZE]){
	float det = 1.0f;
	float temp = 0;

	//Copy Matrix to tempmat
	for(int i = 0; i != MXSIZE; ++i){
		for(int j = 0; j != MXSIZE; j++)
			tempmat[i][j] = matrix[i][j];
	}

	// Fill Lower with 0's
	int rswapcount = 0;
	for(int i =0; i < MXSIZE; ++i){
		if (tempmat[i][i] != 0){
			for(int j = i+1; j < MXSIZE; j++){
				rswapcount =0;
				float f = tempmat[j][i]/tempmat[i][i];
				for (int k = i; k < MXSIZE; ++k)
				{
					temp = FP_MUL_CI(f,tempmat[i][k]);
					tempmat[j][k] = FP_SUB_CI(tempmat[j][k], temp);
				}
			}
		} else {
			if ((MXSIZE - 1 - i) == rswapcount++){
				return 0;
			} else {
				for (int k = i; k < MXSIZE - 1; ++k){
					rswap(tempmat,k,k+1);
					det = FP_MUL_CI(det,-1);
				}
				i--;
			}
		}
	}
	// Calculate Determinant
	for(int i=0; i < MXSIZE; ++i)
		det = FP_MUL_CI(det, tempmat[i][i]);

	// return det
	return det;
}
*/
int main()
{
	float a = 1.5;
	float b = 0.7;
	float c = 0;

	char buf[10];


	printf("Hello from Nios II!\n");
while(1)
{
		c = FP_ADD_CI(a,b);
		//IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, c);
		gcvt(c, 10, buf);
		alt_putstr("a+b result: "); alt_putstr(buf); alt_putstr(" harblbarbls \n");

		c = FP_SUB_CI(a,b);
		//IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, c);
		gcvt(c, 10, buf);
		alt_putstr("a-b result: "); alt_putstr(buf); alt_putstr(" harblbarbls \n");

		c = FP_MUL_CI(a,b);
		//IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, c);
		gcvt(c, 10, buf);
		alt_putstr("a*b result: "); alt_putstr(buf); alt_putstr(" harblbarbls \n");

		a += 1;
		b += 1;

}



		//volatile float testmat[MXSIZE][MXSIZE];
		/*
				{{0.69978,0.5759,0.7704,0.23166,0.56864,0.71408,0.60439,0.96433,0.060995,0.43252,0.95139,0.94027,0.50912,0.088504,0.16512,0.29812,0.94498,0.040068,0.56842,0.024684},
				{0.22909,0.44614,0.21509,0.20902,0.91535,0.098112,0.99632,0.53668,0.84622,0.48986,0.46924,0.97859,0.58211,0.86201,0.45552,0.53508,0.50996,0.54672,0.73236,0.31168},
				{0.79898,0.84651,0.14129,0.60987,0.41662,0.91398,0.1278,0.88762,0.96279,0.005257,0.70728,0.49218,0.045584,0.16666,0.61687,0.17471,0.95371,0.96281,0.40995,0.95421},
				{0.76079,0.59342,0.11298,0.61232,0.088782,0.78467,0.19799,0.74971,0.3011,0.26144,0.49066,0.44169,0.87581,0.45157,0.11498,0.53226,0.4699,0.18459,0.61365,0.9053},
				{0.34075,0.053294,0.22471,0.99502,0.76747,0.15181,0.88777,0.13974,0.23321,0.34258,0.36566,0.79766,0.48395,0.28378,0.082571,0.21215,0.9329,0.042023,0.97201,0.7284},
				{0.23103,0.68759,0.2219,0.98977,0.37211,0.42109,0.060168,0.0045971,0.9351,0.013455,0.61379,0.12049,0.19421,0.54774,0.01901,0.68439,0.79172,0.44564,0.85616,0.65572},
				{0.70878,0.12864,0.22195,0.72284,0.4885,0.95484,0.08327,0.79125,0.84215,0.70083,0.65345,0.82736,0.98133,0.97144,0.087226,0.38816,0.49428,0.39574,0.38489,0.61622},
				{0.40645,0.94152,0.44705,0.82839,0.29286,0.18949,0.58583,0.51399,0.77979,0.84924,0.21398,0.74629,0.90263,0.14879,0.41413,0.2296,0.013672,0.97018,0.27313,0.21361},
				{0.94498,0.038981,0.30971,0.36555,0.61218,0.27342,0.037921,0.23104,0.5076,0.42057,0.55871,0.58682,0.62781,0.86832,0.44203,0.57513,0.24022,0.66935,0.83446,0.70774},
				{0.65369,0.70545,0.81821,0.14606,0.84916,0.053772,0.10353,0.70363,0.58244,0.81099,0.95631,0.30299,0.36896,0.48842,0.85622,0.13077,0.43788,0.73017,0.49225,0.18749},
				{0.1034,0.76583,0.58728,0.78249,0.6386,0.14843,0.39916,0.65075,0.58646,0.98992,0.88375,0.58509,0.92836,0.59091,0.24053,0.28486,0.88798,0.10965,0.47074,0.8938},
				{0.7808,0.70115,0.8712,0.64645,0.49787,0.080528,0.53771,0.86816,0.42053,0.43319,0.97133,0.57488,0.89851,0.0033887,0.84335,0.0764,0.91322,0.49497,0.14524,0.058111},
				{0.69747,0.39477,0.73547,0.99149,0.92164,0.71151,0.21588,0.34778,0.83309,0.96217,0.63181,0.20647,0.052055,0.48556,0.37484,0.38934,0.62366,0.92543,0.10029,0.32303},
				{0.10778,0.89353,0.7021,0.77503,0.34718,0.07002,0.38567,0.33065,0.15524,0.43524,0.40592,0.057104,0.088109,0.73145,0.019014,0.87048,0.46921,0.67214,0.30296,0.8535},
				{0.20634,0.46975,0.85433,0.97044,0.022079,0.52415,0.91378,0.29377,0.10935,0.20744,0.4438,0.22953,0.23862,0.53697,0.74612,0.61173,0.82415,0.42336,0.98345,0.12157},
				{0.93348,0.61559,0.13392,0.14586,0.048315,0.77817,0.36213,0.013336,0.52323,0.20243,0.0068037,0.98902,0.33439,0.98651,0.16444,0.36675,0.36264,0.31883,0.077688,0.75005},
				{0.20471,0.13074,0.1285,0.71806,0.79615,0.071494,0.54171,0.27968,0.55282,0.75597,0.33483,0.80639,0.85429,0.50155,0.019951,0.64515,0.66676,0.99178,0.26252,0.47267},
				{0.040527,0.83525,0.45743,0.28748,0.97089,0.66135,0.18283,0.85782,0.16372,0.94431,0.76955,0.042989,0.015076,0.049724,0.58534,0.61707,0.34829,0.75441,0.36284,0.30254},
				{0.5424,0.44677,0.2895,0.60307,0.74166,0.43487,0.3415,0.1511,0.14937,0.86048,0.64611,0.5424,0.25846,0.11046,0.7991,0.33769,0.12377,0.32556,0.64334,0.60232},
				{0.0043823,0.92164,0.67087,0.46813,0.27879,0.39418,0.85128,0.5525,0.060255,0.40671,0.44802,0.2647,0.72126,0.47147,0.6816,0.16555,0.46643,0.37819,0.096348,0.21239}};
		*/
		/*char buf[10];
		volatile float result;

		for (int i=0; i<MXSIZE; ++i)
		{
			for (int j=0; j<MXSIZE; ++j)
			{
				testmat[i][j] = rand();
			}

		}

		//initialize the 2D arrays used for determinant row swapping
		tempmat = malloc(MXSIZE*sizeof(float*));
			for(int i = 0; i != MXSIZE; ++i)
				tempmat[i] = malloc(MXSIZE*sizeof(float));

		clock_t exec_t1, exec_t2;
		exec_t1 = times(NULL); // get system time before starting the process

		result = detmat(testmat);
		gcvt(result, 10, buf);
		alt_putstr("result is = ");
		alt_putstr(buf);
		//for (int i = 0; i < 1000; i++){
		//	result = detmat(testmat);
		//}

		exec_t2 = times(NULL); // get system time after finishing the process
		gcvt(((double)exec_t2-(double)exec_t1) / alt_ticks_per_second(), 10, buf);
		alt_putstr(" proc time = "); alt_putstr(buf); alt_putstr(" seconds \n");

		// Free tempmat
		for(int i = 0; i != MXSIZE; ++i)
			free(tempmat[i]);
		free(tempmat);

	}*/
	return 0;
}
