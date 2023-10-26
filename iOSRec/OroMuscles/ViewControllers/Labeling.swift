//
//  Labeling.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/21/23.
//

import UIKit

class Labeling: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var ExercisesCollectionView: UICollectionView!
    @IBOutlet weak var WorkoutTimerLBL: UILabel!
    @IBOutlet weak var ExerciseNameLBL: UILabel!
    @IBOutlet weak var RepCountLBL: UILabel!
    @IBOutlet weak var DurationLBL: UILabel!
    @IBOutlet weak var MuscleLBL: UILabel!
    @IBOutlet weak var IntensityLBL: UILabel!
    @IBOutlet weak var WorkCapacityLBL: UILabel!
    @IBOutlet weak var SubmitBTN: UIButton!
    
    var ListOfExercises = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayInfo()
        
        //TODO Remove later when working
        ListOfExercises = ["Anna Chicherova", "Charles Austin ", "Javier Sotomayer", "Kajsa Bergqvist",  "Ruth Beitia"]
    }
    
    
    func DisplayInfo() {
        SubmitBTN.layer.borderColor = UIColor.white.cgColor
        SubmitBTN.layer.borderWidth = 1
        SubmitBTN.layer.cornerRadius = 10
        
        /// TODO : Get real data to display
        WorkoutTimerLBL.text = ""
        ExerciseNameLBL.text = ""
        RepCountLBL.text = ""
        DurationLBL.text = ""
        MuscleLBL.text = self.SessionInfo?.currentMuslces.MuscleSelected
        IntensityLBL.text = ""
        WorkCapacityLBL.text = ""
        
        let optionClosure = {(action : UIAction) in self.CheckPopUpNav(ActionTitle: action.title)}
        MenuBTN.menu = UIMenu(options: .displayInline, children : [UIAction(title : "Setup",handler: optionClosure),
                                                                   UIAction(title : "Data", handler: optionClosure),
                                                                   UIAction(title : "Labeling",state: .on,  handler: optionClosure) ,
                                                                   UIAction(title : "Restart", handler: optionClosure)])
    }
    func CheckPopUpNav(ActionTitle : String) {
        if ActionTitle == "Setup" {
            self.NavigationSelector = "SetupConnection"
            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Data" {
            self.NavigationSelector = "DataAnalytics"
            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Labeling" {
            //            self.NavigationSelector = "Labeling"
            //            self.performSegue(withIdentifier: "PN", sender: self)
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
    ///CollectionView for Workout Segment Selection
    ////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = ExercisesCollectionView.cellForItem(at: indexPath) {
            let view4 = cell.viewWithTag(4) as! UIView
            view4.backgroundColor = UIColor(named: "AccentOrange")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListOfExercises.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCELL", for: indexPath)
        let image1 = cell.viewWithTag(1) as! UIImageView
        let label2 = cell.viewWithTag(2) as! UILabel
        let label3 = cell.viewWithTag(3) as! UILabel
        let view4 = cell.viewWithTag(4) as! UIView
        
        image1.image = UIImage(named: "Upload.png")
        label2.text = "Figuring this out"
        label3.text = "5"
        
        
        //TODO handle selection display
        //        if self.SessionInfo?.currentMuslces.MuscleSelected == temp?[indexPath.row] { //If selected, then apply orange to the view
        //            view3.backgroundColor = UIColor(named: "AccentOrange")
        //            label2.textColor = UIColor(named: "AccentOrange")
        //        } else { // not selected, the item should color grey
        //            view3.backgroundColor = UIColor(named: "DeselectedGrey")
        //            label2.textColor = UIColor.white
        //        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = view.frame.size.width
        if width > 300 { width = width / 4 - 5
        }else { width = width / 3 - 5 }
        return CGSize(width: width, height: (ExercisesCollectionView.frame.size.height)/2 - 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///Button Pressed for Saving and Navigation
    ////////////////////////////////////////////////////
    @IBAction func SubmitBTNPressed(_ sender: Any) {
        //Push workout into database
        self.SessionInfo?.postRecordings()
        
        //Segue to the start page
        self.NavigationSelector = "QuickStart"
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
