//
//  Recordings.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class Recording : NSObject {
    ///This is the basic setup for a recording
    var _id : String = ""
    var Description : String = ""
    var analyzed : Bool = false
    var muscleGroup : String = ""
    var dataUpload : String = ""
    var tpUpload : [AnyObject] = [] //TODO I'm not sure what this is yet.
    
    //Added for upload
    var dataPacketArray : [Data] = []
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        
    }
    
    func appendDataPacket(Data: Data){
        dataPacketArray.append(Data)
    }
    
    
    /////////////////////////////////////////////////////////////////
    //////////////////Decodes the JSON into this object
    /////////////////////////////////////////////////////////////////
    func DecodeRecording(incomingRecording : AnyObject) {
        guard let idCheck = incomingRecording["_id"] as? String else{ return }
        guard let DescriptionCheck = incomingRecording["description"] as? String else{ return }
        guard let analyzedCheck = incomingRecording["analyzed"] as? Bool else{ return }
        guard let muscleGroupCheck = incomingRecording["muscleGroup"] as? String else{ return }
        guard let dataUploadCheck = incomingRecording["dataUpload"] as? String else{ return }
        guard let datatpUpload  = incomingRecording["tpUpload"] as? [AnyObject] else{ return }
        
        _id = idCheck
        Description = DescriptionCheck
        analyzed = analyzedCheck
        muscleGroup = muscleGroupCheck
        dataUpload = dataUploadCheck
        tpUpload = datatpUpload
    }
}
