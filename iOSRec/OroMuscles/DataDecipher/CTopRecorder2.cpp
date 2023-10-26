//
//  CTopRecorder2.cpp
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/10/23.
//

#include "CTopRecorder2.hpp"


#include <memory>
#include <functional>
#include <iostream>
#include <fstream>


#include "SVector.h"
#include "RecordCtrl.h"

using namespace std;
using std::string;
using std::function;
using std::unique_ptr;
using std::shared_ptr;
using std::cout;
using std::endl;


// Global object

RecordCtrl gRecCtrl;


int CTopRecorder2::topGetFrames(double * data, int buffersize, int num)
{

  int i;
  
  svec<double> out;
  //out.resize(num, 0.);
  try {
    int chunks = gRecCtrl.GetData(out, num);
    //
  }

  catch (...) {
  }
  
  
  int nsize = out.isize();


  if (buffersize < nsize)
    return -1;
  
  for (i=0; i<nsize; i++) {
    data[i] = out[i];
  }
      
  return nsize;
}



void CTopRecorder2::topFeedData(char * lib, int len)
{
  if (len < 0) {
    gRecCtrl.Reset();
    return;
  }
  
 
  svec<char> buf;
  buf.resize(len, 0);
  int i;
                                      
  for (i=0; i<len; i++)
    buf[i] = lib[i];

  
  gRecCtrl.SetDataBuffer(buf);

}





void CTopRecorder2::topReset()
{
  gRecCtrl.Reset();
}


int CTopRecorder2::topIsDataValid()
{
  bool b = gRecCtrl.IsGood();

  if (b)
    return 1;
  else
    return 0;
}
