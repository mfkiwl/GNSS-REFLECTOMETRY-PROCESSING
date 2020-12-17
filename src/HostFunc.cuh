//==========================================================================
// Author: Oriol Cervelló (oriol.cn [at] protonmail.com) 
//==========================================================================
// License: GNU GPLv3.0
// Copyright (C) 2019  Oriol Cervelló
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//==========================================================================
#ifndef LIBRARIES
#define LIBRARIES
#include <math.h>
#include <fstream>
#include <iostream>
#include <string>
#include <stdio.h>
#include <cufft.h>
#include <ctime>
#include <chrono>
#include <npps.h>
#define PI 3.14159265
using namespace std;
#endif

#include "GlobalFunc.cuh"
#include "IOFunc.cuh"

#ifndef FUNCERR
#define FUNCERR



//ERROR CHECK
#define CUDA_ERROR_CHECK

#define CudaSafeCall( err ) __cudaSafeCall( err, __FILE__, __LINE__ )
#define CudaCheckError()    __cudaCheckError( __FILE__, __LINE__ )
#define cufftSafeCall(err)      __cufftSafeCall(err, __FILE__, __LINE__)

static const char *_cudaGetErrorEnum(cufftResult error)
{
	switch (error)
	{
	case CUFFT_SUCCESS:
		return "CUFFT_SUCCESS";

	case CUFFT_INVALID_PLAN:
		return "CUFFT_INVALID_PLAN";

	case CUFFT_ALLOC_FAILED:
		return "CUFFT_ALLOC_FAILED";

	case CUFFT_INVALID_TYPE:
		return "CUFFT_INVALID_TYPE";

	case CUFFT_INVALID_VALUE:
		return "CUFFT_INVALID_VALUE";

	case CUFFT_INTERNAL_ERROR:
		return "CUFFT_INTERNAL_ERROR";

	case CUFFT_EXEC_FAILED:
		return "CUFFT_EXEC_FAILED";

	case CUFFT_SETUP_FAILED:
		return "CUFFT_SETUP_FAILED";

	case CUFFT_INVALID_SIZE:
		return "CUFFT_INVALID_SIZE";

	case CUFFT_UNALIGNED_DATA:
		return "CUFFT_UNALIGNED_DATA";
	}

	return "<unknown>";
}

inline void __cufftSafeCall(cufftResult err, const char *file, const int line)
{
#ifdef CUDA_ERROR_CHECK
	if (CUFFT_SUCCESS != err) {
		fprintf(stderr, "CUFFT error in file '%s', line %d\n : %s\n", __FILE__, __LINE__, _cudaGetErrorEnum(err));
		cudaDeviceReset();
		exit(EXIT_FAILURE);
	}
#endif

	return;
}

inline void __cudaSafeCall(cudaError err, const char *file, const int line)
{
#ifdef CUDA_ERROR_CHECK
	if (cudaSuccess != err)
	{
		fprintf(stderr, "CudaSafeCall error in file '%s' in line %i : %s.\n",
			__FILE__, __LINE__, cudaGetErrorString(err));
		cudaDeviceReset();
		exit(EXIT_FAILURE);
	}
#endif

	return;
}

inline void __cudaCheckError(const char *file, const int line)
{
#ifdef CUDA_ERROR_CHECK
	cudaError err = cudaGetLastError();
	if (cudaSuccess != err)
	{
		fprintf(stderr, "Cuda error in file '%s' in line %i : %s.\n",
			__FILE__, __LINE__, cudaGetErrorString(err));
		cudaDeviceReset();
		exit(EXIT_FAILURE);
	}
#endif

	return;
}
//END ERROR CHECK
#endif





#ifndef HOSTFUNC
#define HOSTFUNC


void readConfig(const char *, int, int *, int *, int *, int *, int*, int *, int *, int*
	,  int *, int *, float *, string *, string *,int *, int *,bool *, int *,int *,string *,bool *, int *,int *);
void checkInputConfig(int , const char **, int , int , int , int , int , int, int, int, int
	,  int *, int *, float *, string *, string *, int , int,bool, int*, int,string,  bool , int *, int *);
void planifftFunction(int , int , int , cufftHandle *);
void planfftFunction(int , int , int , cufftHandle *);
size_t planMemEstimate(int, int, int);
void prepareReference(int, int, int, cufftComplex *, cufftComplex *, string);
void prepareData(int *, int *, int, char *, string *,
	char *, int, int, int, int, cufftComplex *
	, int, int, cufftComplex *, chrono::nanoseconds *, chrono::nanoseconds *
	, chrono::nanoseconds *, int *, int );
void maxCompute(int, Npp32f *, int,  Npp32f *, int *, Npp8u *,int);
void stdCompute(int, Npp32f *, int, Npp32f *, int *, Npp8u *, int,int,Npp32f *);


#endif
