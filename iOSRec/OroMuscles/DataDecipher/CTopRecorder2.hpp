//
//  CTopRecorder2.hpp
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/10/23.
//

//#ifndef CTopRecorder2_hpp
//#define CTopRecorder2_hpp

//#include <stdio.h>
class CTopRecorder2 {
    public :
    // Retrieve the results
    int topGetFrames(double * data, int buffersize, int num);
    
    // Feed data buffer
    void topFeedData(char * lib, int len);
    
    // Reset
    void topReset();
    
    // Is data valid?
    int topIsDataValid();
};


//#endif
