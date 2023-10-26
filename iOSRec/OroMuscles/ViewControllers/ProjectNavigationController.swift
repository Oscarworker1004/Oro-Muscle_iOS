//
//  ProjectNavigationController.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/18/23.
//

import UIKit

// A centrallized way to approach navigation.
class ProjectNavigationController: UIViewController {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if NavigationSelector == "SetupTrainingPlan" && SessionInfo?.currentExercise.ExerciseSelectionFinished == true {
            NavigationSelector = "SetupTrainingPlanFinished"
        }
        self.performSegue(withIdentifier: NavigationSelector ?? "WorkoutQuickStart", sender: self)
    }
    
    
    
    ////////////////////////////////////////////////////
    //////Segue
    ////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountLogin" {
            let CVC = segue.destination as! AccountLogin
        } else if segue.identifier == "QuickStart" {
            SessionInfo?.ResetWorkoutData()
            let CVC = segue.destination as! QuickStart
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupConnection" {
            let CVC = segue.destination as! SetupConnection
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupTrainingPlan" {
            let CVC = segue.destination as! SetupTrainingPlan
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupMuscleMap" {
            let CVC = segue.destination as! SetupMuscleMap
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupTrainingPlanFinished" {
            let CVC = segue.destination as! SetupTrainingPlanFinished
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupTrainingPlanReorder" {
            let CVC = segue.destination as! SetupTrainingPlanReorder
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "DataAnalytics" {
            let CVC = segue.destination as! DataAnalytics
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "DataGraphs" {
            let CVC = segue.destination as! DataGraphs
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "DataZones" {
            let CVC = segue.destination as! DataZones
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "Labeling" {
            let CVC = segue.destination as! Labeling
            CVC.SessionInfo = (self.SessionInfo)!
        } else if segue.identifier == "SetupBLEDeviceList" {
            let CVC = segue.destination as! SetupBLEDeviceList
            CVC.SessionInfo = (self.SessionInfo)!
        } 
    }
}
