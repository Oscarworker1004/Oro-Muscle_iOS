//
//  SetupTrainingPlan.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/20/23.
//

import UIKit

class SetupTrainingPlan: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var ExercisesTableView: UITableView!
    @IBOutlet weak var CreateExerciseVIEW: UIView!
    @IBOutlet weak var ExerciseNameTF: UITextField!
    @IBOutlet weak var AddExerciseBTN: UIButton!
    @IBOutlet weak var CancelBTN: UIButton!
    @IBOutlet weak var ExerciseSelectionSearchBar: UITextField!
    
    var searchBarText = String()
    var CurrentSelection : String = "" // This is the currently selected CATEGORY
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExercisesTableView.keyboardDismissMode = .onDrag
        CurrentSelection = (self.SessionInfo?.currentExercise.MasterListOfExercisesHeadings[0])!
        DisplayInfo()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }
    
    
    
    
    
    
    func DisplayInfo() {
        CancelBTN.layer.borderColor = UIColor.white.cgColor
        CancelBTN.layer.borderWidth = 1
        CancelBTN.layer.cornerRadius = 10
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if let cell = ExercisesTableView.cellForRow(at: indexPath) {
            let image2 = cell.viewWithTag(2) as! UIImageView
            var temp = self.SessionInfo?.currentExercise.MasterListOfExercises[CurrentSelection]
            if SessionInfo?.currentExercise.ExercisesSelected[(temp![indexPath.row])] == nil {
                self.SessionInfo?.currentExercise.ExercisesSaveExerciseSelected(ExerciseNameKey: (temp![indexPath.row]))
                image2.image = UIImage(named: "OrangeSelectionCheckMark.png")
            } else {
                self.SessionInfo?.currentExercise.ExercisesRemoveExerciseSelected(ExerciseNameKey: (temp![indexPath.row]))
                image2.image = nil
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.SessionInfo?.currentExercise.MasterListOfExercises[CurrentSelection]?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell Layout Configuration
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        let image1 = cell?.viewWithTag(1) as! UIImageView
        let image2 = cell?.viewWithTag(2) as! UIImageView
        let label3 = cell?.viewWithTag(3) as! UILabel
        
        var temp = self.SessionInfo?.currentExercise.MasterListOfExercises[CurrentSelection]
        label3.text = temp![indexPath.row]
        image1.image = UIImage(named: "Upload.png")
        if SessionInfo?.currentExercise.ExercisesSelected[(temp![indexPath.row])] != nil {
            image2.image = UIImage(named: "OrangeSelectionCheckMark.png")
        } else {
            image2.image = nil
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///Searchbar changes the display array
    ////////////////////////////////////////////////////
    @IBAction func funcSearchTextEditingChanged(_ sender: Any) {
        self.SessionInfo?.currentExercise.MasterListOfExercises["SearchedText"] = []
        self.searchBarText = ExerciseSelectionSearchBar.text ?? ""
        CurrentSelection = "SearchedText"
        
        var SearchedTextArray : [String] = []
        //        for n in self.SessionInfo!.currentExercise.MasterListOfExercisesHeadings {
        var n : String = self.SessionInfo!.currentExercise.MasterListOfExercisesHeadings[0]
        for m in (self.SessionInfo?.currentExercise.MasterListOfExercises[n] ?? [""]) {
            if m.lowercased().contains(searchBarText.lowercased()) {
                SearchedTextArray.insert(m, at: 0)
            }
        }
        //        }
        
        self.SessionInfo?.currentExercise.MasterListOfExercises["SearchedText"] = SearchedTextArray
        if self.searchBarText == "" {
            CurrentSelection = (self.SessionInfo?.currentExercise.MasterListOfExercisesHeadings[0])!
        }
        ExercisesTableView.reloadData()
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///Create Exercise adds and updates display
    ////////////////////////////////////////////////////
    @IBAction func CreateExerciseBTNPressed(_ sender: Any) {
        CreateExerciseVIEW.isHidden = !CreateExerciseVIEW.isHidden
    }
    @IBAction func CreateExerciseCancelBTNPressed(_ sender: Any) {
        ExerciseNameTF.text = ""
        CreateExerciseVIEW.isHidden = true
        self.view.endEditing(true)
    }
    @IBAction func CreateExerciseAddExerciseBTNPressed(_ sender: Any) {
        if  ExerciseNameTF.text != "" {
            self.SessionInfo?.currentExercise.MasterListOfExercises["All"]?.append(ExerciseNameTF.text ?? "N/A")
            CreateExerciseVIEW.isHidden = true
            ExercisesTableView.reloadData()
            ExerciseNameTF.text = ""
            self.view.endEditing(true)
        }
    }
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Buttons Pressed for Navigation
    ////////////////////////////////////////////////////
    @IBAction func FinishWorkoutSelectionBTNPressed(_ sender: Any) {
        SessionInfo?.currentExercise.ExerciseSelectionFinished = true
        self.NavigationSelector = "SetupTrainingPlanFinished"
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
