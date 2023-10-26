//
//  WorkoutSetup.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/18/23.
//

import UIKit

class SetupConnection: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var SelectedAthleteLBL: UILabel!
    @IBOutlet weak var WorkoutNameTF: UITextField!
    @IBOutlet weak var WorkoutDateLBL: UILabel!
    @IBOutlet weak var DeviceLBL: UILabel!
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var AthleteNameTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayInfo()
        AthleteNameTableView.keyboardDismissMode = .onDrag
        WorkoutNameTF.delegate = self
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view to resign the first responder status.
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func DisplayInfo() {
        AthleteNameTableView.reloadData()
        AthleteNameTableView.backgroundColor = UIColor.black
        AthleteNameTableView.isHidden = true
        WorkoutNameTF.text = self.SessionInfo?.currentWorkout.WorkoutName
        
        if SessionInfo?.currentTeam.AthleteSelected?.name == "" {
            if self.SessionInfo?.currentTeam.MasterListofAthletes.isEmpty == false {
                SelectedAthleteLBL.text = self.SessionInfo?.currentTeam.MasterListofAthletes[0].name
                SessionInfo?.currentTeam.AthleteSelected = self.SessionInfo?.currentTeam.MasterListofAthletes[0]
            } else {
                SelectedAthleteLBL.text = "No Athletes to Choose From"
            }
        } else {
            SelectedAthleteLBL.text = SessionInfo?.currentTeam.AthleteSelected?.name
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        WorkoutDateLBL.text = formatter.string(from: Date())
        
        DeviceLBL.text = self.SessionInfo?.currentDevice.getConnection()
        if DeviceLBL.text == "Connected" { DeviceLBL.textColor = .green }
        
        
        let optionClosure = {(action : UIAction) in self.CheckPopUpNav(ActionTitle: action.title)}
        MenuBTN.menu = UIMenu(options: .displayInline, children : [UIAction(title : "Setup", state: .on,handler: optionClosure),
                                                                   UIAction(title : "Data", handler: optionClosure) ,
                                                                   UIAction(title : "Labeling", handler: optionClosure),
                                                                   UIAction(title : "Restart", handler: optionClosure) ])
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
    /////////////Button Press for Athlete Pick
    ////////////////////////////////////////////////////
    @IBAction func SelectAthleteBTNPressed(_ sender: Any) {
        self.view.endEditing(true)
        if self.SessionInfo?.currentTeam.MasterListofAthletes.isEmpty == false {
            AthleteNameTableView.isHidden = !AthleteNameTableView.isHidden
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedAthleteLBL.text = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row].name
        SessionInfo?.currentTeam.AthleteSelected = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row]
        AthleteNameTableView.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SessionInfo?.currentTeam.MasterListofAthletes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row].name
        return cell!
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////
    ///////////Button Presses for Navigation
    ////////////////////////////////////////////////////
    @IBAction func SensorConnect1BTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupBLEDeviceList"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func ConnectionBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "SetupConnection"
        //        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func TrainingPlanBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupTrainingPlan"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func MuscleMapBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupMuscleMap"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    
    
    
    ////////////////////////////////////////////////////
    //////Segue
    ////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.SessionInfo?.currentWorkout.WorkoutName = WorkoutNameTF.text ?? ""
        
        if segue.identifier == "PN" {
            let CVC = segue.destination as! ProjectNavigationController
            CVC.SessionInfo = (self.SessionInfo)!
            CVC.NavigationSelector = self.NavigationSelector
        }
    }
}
