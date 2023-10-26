//
//  Workout.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/3/23.
//

import Foundation

class SessionInfo: NSObject {
    ///This is what each Session using the app requires for having a sucessful workout
    
    var currentUser : CurrentUser = CurrentUser()
    ///   currentUser : holds information about the person who has logged in.
    var currentTeam : Team = Team()
    ///   currentTeam : holds information about the athletes the logged in user can access
    var currentMuslces : MuscleInfo = MuscleInfo()
    ///   currentMuscles : holds information about the muscles available and selected for the training session
    var currentExercise : ExerciseInfo = ExerciseInfo()
    ///   currentExercise : holds information about the exercises available and selected for the training session
    var currentWorkout : Workout = Workout()
    ///   currentWorkout : translates the data packets to displayable data
    var currentDevice : Device = Device()
    ///   currentDevice : holds information about the First Sensor added to the workout
    var currentRecording : Recording = Recording()
    ///   currentRecording : holds data packet information and creates the .bin file for uploading through API
    var QuickStart : Bool = false
    ///   This ito caputre the user story and aid in navigation
    
    
    
    
    /////////////////////////////////////////////////////////////////
    /////////Resets the needed info for a new Workout
    /////////////////////////////////////////////////////////////////
    func ResetWorkoutData() {
        currentTeam.ResetWorkout()
        currentMuslces.ResetWorkout()
        currentExercise.ResetWorkout()
        currentWorkout.ResetWorkout()
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    /////////////////////////// URL MongoDB  Connection
    /////////////////////////////////////////////////////////////////
    private let UserURL = "https://oro-muscles-webportal.ew.r.appspot.com/api/current_user"
    private let AthleteURL = "https://oro-muscles-webportal.ew.r.appspot.com/api/athlete"
    private let StorageAndAnalysisURL = "https://storage-analysis-api-dot-oro-muscles-webportal.ew.r.appspot.com/recordings"
    func getUserData() {
        let url = URL(string: UserURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(currentUser.UserToken)", forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET \(String(describing: error))")
                return
            }
            // make sure we got data
            guard let responseData = data else { print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {  let result = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : AnyObject ]
                let resultBody : AnyObject = result["user_data"]!
                self.DecodeCurrentUser(incomingCurrentUser: resultBody)
            } catch  { print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    func postRecordings() {
        //        Storage And Analysis API: Upload recording binary data. Retrieve analysis data.
        //        POST /recordings
        //        Request body( in multipart form data form): athlete_id, file
        //        Response: JSON status, code, message
        
        let url = URL(string: StorageAndAnalysisURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(currentUser.UserToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(currentTeam.AthleteSelected?._id)", forHTTPHeaderField: "athlete_id")
      //  request.setValue("\()", forHTTPHeaderField: "file")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling PostRecording \(String(describing: error))")
                return
            }
            // make sure we got data
            guard let responseData = data else { print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {  let result = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : AnyObject ]
                print(result)
                //                let resultBody : AnyObject = result["user_data"]!
                //                self.DecodeCurrentUser(incomingCurrentUser: resultBody)
            } catch  { print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    func getAnalysis() {
        let url = URL(string: StorageAndAnalysisURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(currentUser.UserToken)", forHTTPHeaderField: "Authorization")
        request.setValue("\(currentTeam.AthleteSelected?._id)", forHTTPHeaderField: "athlete_id")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET \(String(describing: error))")
                return
            }
            // make sure we got data
            guard let responseData = data else { print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {  let result = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String : AnyObject ]
                print(result)
                //                let resultBody : AnyObject = result["user_data"]!
                //                self.DecodeCurrentUser(incomingCurrentUser: resultBody)
            } catch  { print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
        //        GET /analysis
        //        Gets all analysis data for a specific athlete in JSON form
        //        Query Params: athlete_id
    }
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////////Decodes the JSON into this object
    /////////////////////////////////////////////////////////////////
    func DecodeCurrentUser(incomingCurrentUser : AnyObject) {
        guard let emailCheck = incomingCurrentUser["email"] as? String else { return }
        guard let idCheck = incomingCurrentUser["_id"] as? String else{ return }
        guard let athletesCheck = incomingCurrentUser["athletes"] as? [AnyObject] else{ return }
        guard let shared_athletesCheck = incomingCurrentUser["shared_athletes"] as? [AnyObject] else{ return }
        guard let roleCheck = incomingCurrentUser["role"] as? String else{ return }
        guard let organizationCheck = incomingCurrentUser["organization"] as? String else{ return }
        
        self.currentUser.UserEmail = emailCheck
        self.currentUser.UserID = idCheck
        self.currentTeam.DecodeTeam(team: athletesCheck)
        self.currentTeam.DecodeTeam(team: shared_athletesCheck)
        self.currentUser.UserRole = roleCheck
        self.currentUser.UserOrganization = organizationCheck
    }
    
}
