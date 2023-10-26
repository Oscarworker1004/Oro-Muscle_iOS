//
//  Team.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class Team : NSObject {
    ///Master List is pulled from the current_user information
    var MasterListofAthletes : [Athlete]  = []
    
    ///This is marking which athlete has been selected in the current Training Session
    var AthleteSelected : Athlete?
   
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        AthleteSelected = Athlete()
    }
    
    
    /////////////////////////////////////////////////////////////////
    /////////Resets the needed info for a new Workout
    /////////////////////////////////////////////////////////////////
    func ResetWorkout() {
        AthleteSelected = Athlete()
     }
    
    
    /////////////////////////////////////////////////////////////////
    //////////////////Decodes the JSON into this object
    /////////////////////////////////////////////////////////////////
    func DecodeTeam(team : [AnyObject]) {
        for AT in team {
            let newAthlete : Athlete = Athlete()
            newAthlete.DecodeAthelte(incomingAthlete: AT)
            self.MasterListofAthletes.append(newAthlete)
        }
    }
}
