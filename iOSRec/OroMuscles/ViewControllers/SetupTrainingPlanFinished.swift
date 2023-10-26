//
//  SetupTrainingPlanFinished.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/20/23.
//

import UIKit

class SetupTrainingPlanFinished: UIViewController, UITableViewDelegate, UITableViewDataSource  {
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
        
        ExercisesTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true)}
    @objc func keyboardWillShow(notification: NSNotification) {
        //Move the screen if the cell is was hidden from view with the keyboard
        if SelectedRow > 2 || (SelectedRowTF > (14 - SelectedRow) && SelectedRowTF < 50)  || SelectedRowTF > (54 - SelectedRow) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + 150
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //Reset the screen if the cell is was hidden from view with the keyboard
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    
    func DisplayInfo() {
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
    @IBAction func TableTextFieldUpdated(_ sender: Any) {
        for n in 0 ..< (self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.count ?? 0) {
            let EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[n] ?? ""
            if let cell = self.ExercisesTableView.cellForRow(at: NSIndexPath(row: n, section: 0) as IndexPath) {
                if self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) == true {
                    let textfield5 = cell.viewWithTag(5) as! UITextField
                    let ChangeCheck1 : Int = self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName) ?? 0
                    let ChangeCheck2 : Int = Int(textfield5.text ?? "0") ?? 0
                    self.SessionInfo?.currentExercise.ExercisesSaveSets(ExerciseNameKey: EXName, Sets: Int(textfield5.text ?? "0") ?? 0)
                    
                    if (self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName) ?? 0) > 25 {
                        self.SessionInfo?.currentExercise.ExercisesSaveSets(ExerciseNameKey: EXName, Sets: 25)
                        textfield5.text = "25"
                        
                    }
                    
                    var tempREPS : [Int] = []
                    var tempWEIGHT : [Int] = []
                    for i in 0..<(self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName))!{
                        if let textfieldREP = cell.viewWithTag(10 + i) as? UITextField { tempREPS.append(Int(textfieldREP.text ?? "0") ?? 0) }
                        if let textfieldWEIGHT = cell.viewWithTag(50 + i) as? UITextField { tempWEIGHT.append(Int(textfieldWEIGHT.text ?? "0") ?? 0) }
                    }
                    self.SessionInfo?.currentExercise.ExercisesSaveSetReps(ExerciseNameKey: EXName, Reps: tempREPS)
                    self.SessionInfo?.currentExercise.ExercisesSaveSetWeight(ExerciseNameKey: EXName, Weights: tempWEIGHT)
                    
                    if ChangeCheck1 != ChangeCheck2 {
                        self.ExercisesTableView.reloadData()
                        if let cellNEW = self.ExercisesTableView.cellForRow(at: NSIndexPath(row: n, section: 0) as IndexPath) {
                            let textfield5NEW = cellNEW.viewWithTag(5) as! UITextField
                            textfield5NEW.becomeFirstResponder()
                        }
                    }
                    
                }
            }
        }
        
    }
    @IBAction func TextfieldSelected(_ sender: Any) {
        for n in 0 ..< (self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.count ?? 0) {
            let EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[n] ?? ""
            if let cell = self.ExercisesTableView.cellForRow(at: NSIndexPath(row: n, section: 0) as IndexPath) {
                if self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) == true {
                    let textfield5 = cell.viewWithTag(5) as! UITextField
                    if textfield5.isFirstResponder {
                        SelectedRow = n
                        SelectedRowTF = 5
                    }
                    
                    for i in 0..<(self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName))!{
                        let textfieldREP = cell.viewWithTag(10 + i) as! UITextField
                        let textfieldWEIGHT = cell.viewWithTag(50 + i) as! UITextField
                        if textfieldREP.isFirstResponder {
                            SelectedRow = n
                            SelectedRowTF = 10 + i
                        }
                        if textfieldWEIGHT.isFirstResponder {
                            SelectedRow = n
                            SelectedRowTF = 50 + i
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Toggle that row to show
        let EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[indexPath.row] ?? ""
        let EXDSets : Bool = self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) ?? false
        self.SessionInfo?.currentExercise.ExercisesSaveDisplaySets(ExerciseNameKey: EXName, Display: !(EXDSets) )
        
        
        //Reload the table with those changes
        ExercisesTableView.reloadData()
        
        //Pull the cursor back to the last editted spot in case it pulls away
        if (self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) ?? false) == true  && self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName) == 0 {
            if let cell = self.ExercisesTableView.cellForRow(at: NSIndexPath(row: indexPath.row, section: 0) as IndexPath) {
                let textfield5 = cell.viewWithTag(5) as! UITextField
                textfield5.becomeFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SessionInfo?.currentExercise.ExercisesSelectedHeadings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[indexPath.row] ?? ""
        let EXSets : Int = self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName) ?? 0
        
        //Cell Layout Configuration
        if (self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) ?? false) == false  {
            //This is the unselected exercise list
            let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
            let image1 = cell?.viewWithTag(1) as! UIImageView
            let image2 = cell?.viewWithTag(2) as! UIImageView
            let label3 = cell?.viewWithTag(3) as! UILabel
            
            label3.text = EXName
            image1.image = UIImage(named: "Upload.png")
            return cell!
            
        } else if (self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) ?? false) == true {
            //This is the Selected exercise list to ask for Sets Info
            let cell = tableView.dequeueReusableCell(withIdentifier: "STARTSET")
            let image1 = cell?.viewWithTag(1) as! UIImageView
            let image2 = cell?.viewWithTag(2) as! UIImageView
            let label3 = cell?.viewWithTag(3) as! UILabel
            let textfield5 = cell?.viewWithTag(5) as! UITextField
            
            label3.text = EXName
            image1.image = UIImage(named: "Upload.png")
            
            if String(EXSets) != "0" { textfield5.text = String(EXSets) } else {textfield5.text = "" }
            
            
            //To reset the vaules in the Textfields. Keep them from populating other row's textfields.
            for i in 0..<25 {
                let textfieldREP = cell?.viewWithTag(10 + i) as! UITextField
                let textfieldWEIGHT = cell?.viewWithTag(50 + i) as! UITextField
                textfieldREP.text = ""
                textfieldWEIGHT.text = ""
            }
            let EXReps : [Int] = (self.SessionInfo?.currentExercise.ExercisesReturnSetReps(ExerciseNameKey: EXName))!
            let EXWeight : [Int] = (self.SessionInfo?.currentExercise.ExercisesReturnSetWeight(ExerciseNameKey: EXName))!
            
            for i in 0..<EXSets {
                let textfieldREP = cell?.viewWithTag(10 + i) as! UITextField
                let textfieldWEIGHT = cell?.viewWithTag(50 + i) as! UITextField
                
                if String(EXReps[i]) != "0" {textfieldREP.text = String(EXReps[i]) } else {textfieldREP.text = ""}
                if String(EXWeight[i]) != "0" {textfieldWEIGHT.text = String(EXWeight[i]) } else {textfieldWEIGHT.text = ""}
            }
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
            let image1 = cell?.viewWithTag(1) as! UIImageView
            let image2 = cell?.viewWithTag(2) as! UIImageView
            let label3 = cell?.viewWithTag(3) as! UILabel
            
            label3.text = "Accident"
            image1.image = UIImage(named: "Upload.png")
            
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var EXName : String = self.SessionInfo?.currentExercise.ExercisesSelectedHeadings[indexPath.row] ?? ""
        var EXSets : Int = self.SessionInfo?.currentExercise.ExercisesReturnSets(ExerciseNameKey: EXName) ?? 0
        if (self.SessionInfo?.currentExercise.ExercisesReturnDisplaySets(ExerciseNameKey: EXName) ?? false) == false{
            return 70
        } else {
            return CGFloat(70 + 37 + EXSets * 43)
        }
    }
    
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Buttons Pressed for Navigation
    ////////////////////////////////////////////////////
    @IBAction func ReorderWorkoutBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupTrainingPlanReorder"
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
