//
//  SetupTrainingPlanReorder.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 9/8/23.
//

import Foundation
import UIKit

class SetupTrainingPlanReorder: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var WorkoutNameLBL: UILabel!
    @IBOutlet weak var ExercisesTableView: UITableView!
    
    var SelectedRow : Int = 0
    var SelectedRowTF : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayInfo()
    }
   
    
    
    
    
    func DisplayInfo() {
        ExercisesTableView.isEditing = true
//        if SessionInfo?.currentWorkout.WorkoutName == "" {WorkoutNameLBL.text = "Workout"
//        } else { WorkoutNameLBL.text = SessionInfo?.currentWorkout.WorkoutName }
        let optionClosure = {(action : UIAction) in self.CheckPopUpNav(ActionTitle: action.title)}
        MenuBTN.menu = UIMenu(options: .displayInline, children : [UIAction(title : "Setup", state: .on,handler: optionClosure),
                                                                   UIAction(title : "Data", handler: optionClosure) ,
                                                                   UIAction(title : "Labeling", handler: optionClosure),
                                                                   UIAction(title : "Restart", handler: optionClosure) ])
        ExercisesTableView.reloadData()
    }
    func CheckPopUpNav(ActionTitle : String) {
        if ActionTitle == "Setup" {
            //            self.NavigationSelector = "SetupConnection"
            //            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Data" {
            if self.SessionInfo?.currentDevice.picoPeripheral == nil {
                self.NavigationSelector = "SetupConnection"
            } else { self.NavigationSelector = "DataAnalytics" }
            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Labeling" {
            self.NavigationSelector = "Labeling"
            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Restart" {
            let alert = UIAlertController(title: "Restart", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
                self.NavigationSelector = "QuickStart"
                self.performSegue(withIdentifier: "PN", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion:  nil)
        }
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Tableview Display for Exercises
    ////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")
          var NametoRemove = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[indexPath.row]
          self.SessionInfo?.currentExercise.ExercisesRemoveExerciseSelected(ExerciseNameKey: NametoRemove ?? "")
       
          ExercisesTableView.reloadData()
      }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[sourceIndexPath.row]
        self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.remove(at: sourceIndexPath.row)
        self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.insert(item!, at: destinationIndexPath.row)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Reload the table with those changes
        ExercisesTableView.reloadData()
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[indexPath.row] ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        let label3 = cell?.viewWithTag(3) as! UILabel
        cell?.overrideUserInterfaceStyle = .dark
        label3.text = EXName
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Buttons Pressed for Navigation
    ////////////////////////////////////////////////////
    @IBAction func EditWorkoutBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupTrainingPlanFinished"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func EditWorkoutSelectionBTNPressed(_ sender: Any) {
        SessionInfo?.currentExercise.ExerciseSelectionFinished = false
        self.NavigationSelector = "SetupTrainingPlan"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func ConnectionBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupConnection"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func TrainingPlanBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "SetupTrainingPlan"
        //        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func MuscleMapBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupMuscleMap"
        self.performSegue(withIdentifier: "PN", sender: self)
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
