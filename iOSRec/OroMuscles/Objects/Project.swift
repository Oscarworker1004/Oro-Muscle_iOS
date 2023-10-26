//
//  Projects.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class Project : NSObject {
   ///This is the basic setup for a Project
    var _id : String = ""
    var muscleGroup : String = ""
    var analysis : [String] = []   //TODO, I'm not sure what this is yet.
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////////Decodes the JSON into this object
    /////////////////////////////////////////////////////////////////
    func DecodeProject(incomingProject : AnyObject) {
        guard let idCheck = incomingProject["_id"] as? String else{ return }
        guard let muscleGroupCheck = incomingProject["muscleGroup"] as? String else{ return }
        guard let analysisCheck = incomingProject["analysis"] as? [String] else{ return }
      
        _id = idCheck
        muscleGroup = muscleGroupCheck
//        analysis = analysisCheck //TODO Check with real data
    }
}
