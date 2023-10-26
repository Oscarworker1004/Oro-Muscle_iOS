//
//  SetupMuscleMap.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/20/23.
//

import UIKit

class SetupMuscleMap: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var ExercisesCollectionView: UICollectionView!
    @IBOutlet weak var ExerciseSelectionSearchBar: UITextField!
    @IBOutlet weak var BodyRightBTN: UIButton!
    @IBOutlet weak var BodyLeftBTN: UIButton!
    @IBOutlet weak var BodyMapBTN1: UIButton!
    @IBOutlet weak var BodyMapBTN2: UIButton!
    @IBOutlet weak var BodyMapBTN3: UIButton!
    @IBOutlet weak var BodyMapBTN4: UIButton!
    @IBOutlet weak var BodyMapBTN5: UIButton!
    @IBOutlet weak var BodyMapBTN6: UIButton!
    @IBOutlet weak var BodyMapBTNImage1: UIImageView!
    @IBOutlet weak var BodyMapBTNImage2: UIImageView!
    @IBOutlet weak var BodyMapBTNImage3: UIImageView!
    @IBOutlet weak var BodyMapBTNImage4: UIImageView!
    @IBOutlet weak var BodyMapBTNImage5: UIImageView!
    @IBOutlet weak var BodyMapBTNImage6: UIImageView!
    
    var searchBarText = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExercisesCollectionView.keyboardDismissMode = .onDrag
        DisplayInfo()
    }
    
    
    
    
    func DisplayInfo() {
        if self.SessionInfo?.currentMuslces.MuscleSideSelected == "Right" {
            BodyRightBTNPressed((Any).self)
        } else { BodyLeftBTNPressed((Any).self) }
        
        let optionClosure = {(action : UIAction) in self.CheckPopUpNav(ActionTitle: action.title)}
        MenuBTN.menu = UIMenu(options: .displayInline, children : [UIAction(title : "Setup", state: .on,handler: optionClosure),
                                                                   UIAction(title : "Data", handler: optionClosure),
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
    ///Button Pressed for Muscle Selection
    ////////////////////////////////////////////////////
    @IBAction func BodyRightBTNPressed(_ sender: Any) {
        self.SessionInfo?.currentMuslces.MuscleSideSelected = "Right"
        BodyLeftBTN.backgroundColor = UIColor(named: "DeselectedGrey")
        BodyRightBTN.backgroundColor = UIColor(named: "AccentOrange")
    }
    @IBAction func BodyLeftBTNPressed(_ sender: Any) {
        self.SessionInfo?.currentMuslces.MuscleSideSelected = "Left"
        BodyRightBTN.backgroundColor = UIColor(named: "DeselectedGrey")
        BodyLeftBTN.backgroundColor = UIColor(named: "AccentOrange")
    }
    @IBAction func BodyMap1BTNPressed(_ sender: Any) {
        ResetColors(Selection: 1)
    }
    @IBAction func BodyMap2BTNPressed(_ sender: Any) {
        ResetColors(Selection: 2)
    }
    @IBAction func BodyMap3BTNPressed(_ sender: Any) {
        ResetColors(Selection: 3)
    }
    @IBAction func BodyMap4BTNPressed(_ sender: Any) {
        ResetColors(Selection: 4)
    }
    @IBAction func BodyMap5BTNPressed(_ sender: Any) {
        ResetColors(Selection: 5)
    }
    @IBAction func BodyMap6BTNPressed(_ sender: Any) {
        ResetColors(Selection: 6)
    }
    func ResetColors(Selection : Int) {
        if Selection == 1 { self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Upper Leg"
            BodyMapBTNImage1.image = UIImage(named: "SelectorLegs")
        } else {BodyMapBTNImage1.image = UIImage(named: "SelectorLegsDeselected") }
        
        if Selection == 2 {  self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Lower Leg"
            BodyMapBTNImage2.image = UIImage(named: "SelectorLowerLegs")
        } else {BodyMapBTNImage2.image = UIImage(named: "SelectorLowerLegsDeselected") }
        
        if Selection == 3 {  self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Upper Body"
            BodyMapBTNImage3.image = UIImage(named: "SelectorUpperBody")
        } else { BodyMapBTNImage3.image = UIImage(named: "SelectorUpperBodyDeselected") }
        
        if Selection == 4 {  self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Arms"
            BodyMapBTNImage4.image = UIImage(named: "SelectorArms")
        } else { BodyMapBTNImage4.image = UIImage(named: "SelectorArmsDeselected") }
        
        if Selection == 5 {  self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Back / Neck"
            BodyMapBTNImage5.image = UIImage(named: "SelectorBack")
        } else {BodyMapBTNImage5.image = UIImage(named: "SelectorBackDeselected") }
        
        if Selection == 6 {  self.SessionInfo?.currentMuslces.MuscleGroupSelected = "Head"
            BodyMapBTNImage6.image = UIImage(named: "Selectorhead")
        } else {BodyMapBTNImage6.image = UIImage(named: "SelectorheadDeselected") }
        
        ExercisesCollectionView.reloadData()
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///CollectionView for Muscle Display and Selection
    ////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let temp = self.SessionInfo?.currentMuslces.MasterListOfMuscles[ self.SessionInfo!.currentMuslces.MuscleGroupSelected]
        self.SessionInfo?.currentMuslces.MuscleSelected = temp?[indexPath.row] ?? ""
        ExercisesCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.SessionInfo?.currentMuslces.MasterListOfMuscles[ self.SessionInfo!.currentMuslces.MuscleGroupSelected]?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCELL", for: indexPath)
        let image1 = cell.viewWithTag(1) as! UIImageView
        let label2 = cell.viewWithTag(2) as! UILabel
        let view3 = cell.viewWithTag(3) as! UIView
        
        var temp = self.SessionInfo?.currentMuslces.MasterListOfMuscles[ self.SessionInfo!.currentMuslces.MuscleGroupSelected]
        
        image1.image = UIImage(named: "Z" + (temp?[indexPath.row] ?? "") + ".png")
        label2.text = temp?[indexPath.row]
        
        if self.SessionInfo?.currentMuslces.MuscleSelected == temp?[indexPath.row] { //If selected, then apply orange to the view
            view3.backgroundColor = UIColor(named: "AccentOrange")
            label2.textColor = UIColor(named: "AccentOrange")
        } else { // not selected, the item should color grey
            view3.backgroundColor = UIColor(named: "DeselectedGrey")
            label2.textColor = UIColor.white
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = view.frame.size.width
        if width > 300 { width = width / 3 - 5
        }else { width = width / 2 - 5 }
        return CGSize(width: width, height: (ExercisesCollectionView.frame.size.height)/2 - 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///Searchbar changes the display array
    ////////////////////////////////////////////////////
    @IBAction func funcSearchTextEditingChanged(_ sender: Any) {
        self.SessionInfo?.currentMuslces.MasterListOfMuscles["SearchedText"] = []
        self.searchBarText = ExerciseSelectionSearchBar.text ?? ""
        self.SessionInfo?.currentMuslces.MuscleGroupSelected = "SearchedText"
        
        var SearchedTextArray : [String] = []
        for n in self.SessionInfo!.currentMuslces.MasterListOfMusclesHeadings {
            for m in (self.SessionInfo?.currentMuslces.MasterListOfMuscles[n] ?? [""]) {
                if m.lowercased().contains(searchBarText.lowercased()) {
                    SearchedTextArray.insert(m, at: 0)
                }
            }
        }
        
        self.SessionInfo?.currentMuslces.MasterListOfMuscles["SearchedText"] = SearchedTextArray
        if self.searchBarText == "" {
            BodyMap6BTNPressed((Any).self)
        }
        ExercisesCollectionView.reloadData()
    }
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Buttons Pressed for Navigation
    ////////////////////////////////////////////////////
    @IBAction func FinishMuscleSelectionBTNPressed(_ sender: Any) {
        if self.SessionInfo?.currentDevice.picoPeripheral == nil {
            self.NavigationSelector = "SetupConnection"
        } else { self.NavigationSelector = "DataAnalytics" }
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func ConnectionBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupConnection"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func TrainingPlanBTNPressed(_ sender: Any) {
        self.NavigationSelector = "SetupTrainingPlan"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func MuscleMapBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "SetupMuscleMap"
        //        self.performSegue(withIdentifier: "PN", sender: self)
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
