//
//  CTop_Wrapper.m
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/10/23.
//

#import "CTop_Wrapper.h"
#import  "CTopRecorder2.hpp"

@implementation CTop_Wrapper

-(void) HeresCTOP_Wrapper {
    CTopRecorder2 CTR;
  
}

-(int)CTOPWtopGetFrames:(double *)data: (int)buffersize: (int)num {
    CTopRecorder2 CTR;
    return CTR.topGetFrames(data, buffersize, num) ;
}

// Feed data buffer
-(void) CTOPWtopFeedData: (char *)lib: (int)len {
    CTopRecorder2 CTR;
    return CTR.topFeedData(lib, len) ;
}

// Reset
-(void) CTOPWtopReset{
    CTopRecorder2 CTR;
    CTR.topReset();
}

// Is data valid?
-(int) CTOPtopIsDataValid{
    CTopRecorder2 CTR;
    return  CTR.topIsDataValid();
}

@end
