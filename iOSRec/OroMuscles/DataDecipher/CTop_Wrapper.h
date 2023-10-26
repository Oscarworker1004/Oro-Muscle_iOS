//
//  CTop_Wrapper.h
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/10/23.
//
#import <Foundation/Foundation.h>

@interface CTop_Wrapper : NSObject
-(void) HeresCTOP_Wrapper;
-(int)  CTOPWtopGetFrames:(double *)data: (int)buffersize: (int)num;
-(void) CTOPWtopFeedData:(char *)lib: (int)len;
-(void) CTOPWtopReset;
-(int)  CTOPtopIsDataValid;
@end
