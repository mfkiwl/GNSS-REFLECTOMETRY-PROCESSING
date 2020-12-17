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
#include "IOFunc.cuh"
//READ FUNCTIONS

void readdata(int length, int offsetFromBeg, cufftComplex *data, string name)
{
	ifstream myfile;
	myfile.open(name, ios::binary);
	//float num1,num2;

	if (myfile.is_open())
	{
		myfile.seekg(offsetFromBeg * sizeof(cufftComplex));

		myfile.read((char*)data, length * sizeof(cufftComplex));
		/*int k = 0;
		while (k < length)
		{

			myfile.read((char*)&num1, sizeof(num1));
			myfile.read((char*)&num2, sizeof(num2));
			data[k].x = num1;
			data[k].y =  num2;
			k++;
		}*/
		myfile.close();
	}
	else { 
		cout << "ERROR: Unable to open file of floats for reading " << name << "\n";
		exit(1);
	}
}

void readRealData(int length, int offsetFromBeg, int bytesToRead, char *data, string name)
{
	if (length > bytesToRead) {
		cout << "Error: iput length bigger than bytesToRead\n";
		exit(0);
	}

	ifstream myfile;
	myfile.open(name, ios::binary);
	if (myfile.is_open())
	{
		myfile.seekg(offsetFromBeg * sizeof(char));
		myfile.read(data, length);

		myfile.close();
		if (length < bytesToRead) {
			cout << "Warning: length smaller than bytesToRead, " << bytesToRead - length << " Bytes filled with 0 \n Last/s incoherents will be incomplete \n";
			memset(&data[length], 0, bytesToRead - length);
		}
	}
	else { 
		cout << "ERROR: Unable to open file of Real Data for reading " << name << "\n";
		exit(1);
	}
}


void readRealData2files(int length1, int length2, int offsetFromBeg1, int offsetFromBeg2, int bytesToRead, char *data, string name1, string name2)
{
	if (length1 > bytesToRead || length2 > bytesToRead) {
		cout << "Error: iput length bigger than bytesToRead\n";
		exit(0);
	}

	ifstream myfile;
	myfile.open(name1, ios::binary);
	if (myfile.is_open())
	{
		myfile.seekg(offsetFromBeg1 * sizeof(char));
		myfile.read(data, length1);

		myfile.close();
		
	}
	else {
		cout << "ERROR: Unable to open file of Real Data for reading " << name1 << "\n";
		exit(1);
	}

	myfile.open(name2, ios::binary);
	if (myfile.is_open())
	{
		myfile.seekg(offsetFromBeg2 * sizeof(char));
		myfile.read(&data[length1], length2);

		myfile.close();

	}
	else {
		cout << "ERROR: Unable to open file of Real Data for reading " << name2 << "\n";
		exit(1);
	}


	if (length1+length2 < bytesToRead) {
		cout << "Warning: length smaller than bytesToRead, " << bytesToRead - length1-length2 << " Bytes filled with 0 \n Last/s incoherents will be incomplete \n";
		memset(&data[length1+length2], 0, bytesToRead - (length1 + length2));
	}
}




void readdataInt(int length, int offsetFromBeg, __int16 *data, string name)
{
	
	ifstream myfile;
	myfile.open(name, ios::binary);
	//float num1,num2;

	if (myfile.is_open())
	{
		myfile.seekg(offsetFromBeg * sizeof(__int16));

		myfile.read((char*)data, 2* length * sizeof(__int16));
		
		myfile.close();
	}
	else {
		cout << "ERROR: Unable to open file of Ints16 for reading " << name << "\n"; 
		exit(1);
	}

}

//WRITE FUNCTIONS

void writeIncoh(int N, cuComplex *data1, string name) {

	ofstream myfile;
	myfile.open(name, ios::binary);
	if (myfile.is_open())
	{
		for (int ii = 0; ii < N / 2; ii++)
		{
			myfile.write((char*)&data1[ii].x, sizeof(float));
			myfile.write((char*)&data1[ii].y, sizeof(float));
		}
		myfile.close();
	}

	else { 
		cout << "ERROR: Unable to open file of incoh for writting " << name << "\n"; 
		exit(1);
	}
}

void writeMaxs(int N, Npp32f *dataMaxValue, int *dataMaxPos, Npp32f *hostarrayStd, Npp32f *hostarrayMean, float doppler, string name, int iteration, int ddmRes,
	int ddmQuant, int origIncohNum) {
	float freq, aux;
	ofstream myfile;
	myfile.open(name, ios::binary);//
	if (myfile.is_open())
	{
		for (int ii = 0; ii < N; ii++)
		{
			aux = float(dataMaxPos[ii]);
			freq = doppler - (ddmRes * (ddmQuant / 2)) + ((ii / (origIncohNum))*(ddmRes));
			myfile.write((char*)&aux, sizeof(float));
			myfile.write((char*)&dataMaxValue[ii], sizeof(float));
			myfile.write((char*)&hostarrayMean[ii], sizeof(float));
			myfile.write((char*)&hostarrayStd[ii], sizeof(float));
			myfile.write((char*)&freq, sizeof(float));
			//myfile <<float( dataMaxPos[ii])<< " "<<dataMaxValue[ii] << " " << hostarrayMean[ii] << " " << hostarrayStd[ii] << " " << freq << " ";
		}
		myfile.close();
	}

	else {
		cout << "ERROR: Unable to open file of Maxs " << name << "\n";
		exit(1);
	}
}

void writedata(int N, cufftComplex *data1, string name) {

	ofstream myfile;
	myfile.open(name, ios::binary);
	if (myfile.is_open())
	{
		myfile.write((char*)data1, N * sizeof(cufftComplex));
		/*for (int ii = 0; ii < N; ii++)
		{

			myfile.write((char*)&data1[ii].x, sizeof(float));
			myfile.write((char*)&data1[ii].y, sizeof(float));
		}*/
		myfile.close();
	}

	else {
		cout << "ERROR: Unable to open file of data to write " << name << "\n";
		exit(1);
	}
}

void writetime(int N, string name, long long *readtime, long long *writetime, long long *looptime
	, long long *mask_elapsed_secs, long long *extenddop_elapsed_secs, long long *doppler_elapsed_secs,
	long long *fft_elapsed_secs, long long *mult_elapsed_secs, long long *ifft_elapsed_secs,
	long long *incho_elapsed_secs, long long *max_elapsed_secs, long long *savep_elapsed_secs, long long *std_elapsed_secs) {

	ofstream myfile;
	myfile.open(name);
	if (myfile.is_open())
	{
		myfile << "Atempt\t\tReadT.\t\tMask\t\tExtend\t\tDoppler\t\tFFT\t\tMul\t\tIFFT\t\tIncoh\t\tMax\t\tSaveP.\t\tSTD\t\tWriteT.\t\tLoopT." << "\n";
		for (int ii = 0; ii < N; ii++)
		{
			myfile << ii << "\t\t" << readtime[ii] << "\t\t" << mask_elapsed_secs[ii] << "\t\t"
				<< extenddop_elapsed_secs[ii] << "\t\t" << doppler_elapsed_secs[ii] << "\t\t"
				<< fft_elapsed_secs[ii] << "\t\t" << mult_elapsed_secs[ii] << "\t\t"
				<< ifft_elapsed_secs[ii] << "\t\t"
				<< incho_elapsed_secs[ii] << "\t\t" << max_elapsed_secs[ii] << "\t\t"
				<< savep_elapsed_secs[ii] << "\t\t" << std_elapsed_secs[ii] << "\t\t"
				<< writetime[ii] << "\t\t" << looptime[ii] << "\n";

		}
		myfile.close();
	}

	else {
		cout << "ERROR: Unable to open file of times " << name << "\n";
		exit(1);
	}
}
