//
//  WorkoutQuickStart.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/18/23.
//

import UIKit
import Auth0

class QuickStart: UIViewController {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SessionInfo?.currentWorkout.ResetWorkout()
    }
    
    
    @IBAction func WorkoutSelectionBTNPressed(_ sender: Any) {
        self.SessionInfo?.QuickStart = false
        self.NavigationSelector = "SetupConnection"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func QuickStartBTNPressed(_ sender: Any) {
        self.SessionInfo?.QuickStart = true
        self.NavigationSelector = "SetupBLEDeviceList"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func LogoutBTNPressed(_ sender: Any) {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    print("Session cookie cleared")
                    // Delete credentials
                    self.SessionInfo?.currentUser.LogoutUser()
                    self.NavigationSelector = "AccountLogin"
                    self.performSegue(withIdentifier: "PN", sender: self)
                    
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    ////////////////////////////////////////////////////
    //////Segue
    ////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PN" {
            let CVC = segue.destination as! ProjectNavigationController
            CVC.SessionInfo = (self.SessionInfo)!
            CVC.NavigationSelector = self.NavigationSelector
        }
    }
}
