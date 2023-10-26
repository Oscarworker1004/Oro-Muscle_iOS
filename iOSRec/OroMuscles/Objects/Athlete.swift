//
//  Athlete.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation


class Athlete: NSObject {
    ///This is the basic setup for an Athlete
    var _id : String = ""
    var height : String = ""
    var weight : String = ""
    var projects : [Project] = [Project()]
    var active : Bool = false
    var image : String = ""
    var users : [String] = []
    var name : String = ""
    var recordings : [Recording] = [Recording()]
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////////Decodes the JSON into this object
    /////////////////////////////////////////////////////////////////
    func DecodeAthelte(incomingAthlete : AnyObject) {
        guard let idATCheck = incomingAthlete["_id"] as? String else{ return }
        guard let heightATCheck = incomingAthlete["height"] as? String else{ return }
        guard let weightATCheck = incomingAthlete["weight"] as? String else{ return }
        guard let projectsATCheck = incomingAthlete["projects"] as? [AnyObject] else{ return }
        guard let activeATCheck = incomingAthlete["active"] as? Bool else{ return }
        guard let imageATCheck = incomingAthlete["image"] as? String else{ return }
        guard let usersATCheck = incomingAthlete["users"] as? [String] else{ return }
        guard let nameATCheck = incomingAthlete["name"] as? String else{ return }
        guard let recordingsATCheck = incomingAthlete["recordings"] as? [AnyObject] else{ return }
        
        _id = idATCheck
        height = heightATCheck
        weight = weightATCheck
        setProjects(projectList: projectsATCheck)
        active = activeATCheck
        image = imageATCheck
        users = usersATCheck
        name = nameATCheck
        setRecordings(recordinglist: recordingsATCheck)
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////
    ///////////////Pushes the Decoding into the objects
    /////////////////////////////////////////////////////////////////
    func setProjects(projectList : [AnyObject]) {
        for project in projectList {
            let newProject : Project = Project()
            newProject.DecodeProject(incomingProject: project)
            self.projects.append(newProject)
        }
    }
    func setRecordings(recordinglist : [AnyObject]) {
        for recording in recordinglist {
            let newRecording : Recording = Recording()
            newRecording.DecodeRecording(incomingRecording: recording)
            self.recordings.append(newRecording)
            
        }
    }
}
