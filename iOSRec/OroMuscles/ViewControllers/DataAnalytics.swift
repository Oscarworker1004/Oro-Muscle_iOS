//
//  DataAnalytics.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/21/23.
//

import UIKit
import CoreBluetooth
import os.log


class DataAnalytics: UIViewController, PicoBlueDelegate , UITableViewDelegate, UITableViewDataSource {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    // Create a log object for your specific category
    let log = OSLog(subsystem: "com.OnTrackApps.OroMusclesd", category: "PRECE-DEBUG")
    


    
    
    
    
    
    
    @IBOutlet weak var SelectedAthleteLBL: UILabel!
    @IBOutlet weak var SelectAthleteBTN: UIButton!
    @IBOutlet weak var AthleteNameSelecionVIEW: UIView!
    @IBOutlet weak var AthleteNameTableView: UITableView!
    @IBOutlet weak var WorkoutEditBTN: UIButton!
    @IBOutlet weak var WorkoutEditVIEW: UIView!
    @IBOutlet weak var WorkoutEditCancelBTN: UIButton!
    @IBOutlet weak var WorkoutNameTF: UITextField!
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var SubmitWorkoutBTN: UIButton!
    @IBOutlet weak var WorkoutLBL: UILabel!
    @IBOutlet weak var DisplyTimerLBL: UILabel!
    @IBOutlet weak var SetsBTNLBL: UIButton!
    @IBOutlet weak var StopGoIMAGE: UIImageView!
    @IBOutlet weak var MuscleIMAGE: UIImageView!
    @IBOutlet weak var MovementIMAGE: UIImageView!
    
    var timer: Timer?
    public func setPeripheral(_ peripheral: picoBluePeripheral) {
        self.SessionInfo?.currentDevice.picoPeripheral = peripheral
        self.SessionInfo?.currentDevice.picoPeripheral.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<450 {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineY.append(400 - Double.random(in: 0...400))
            self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS.append(400 - 0.0)
            self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG.append(400 - 0.0)

            
        }
        DisplayInfo()
        self.SessionInfo?.currentDevice.picoPeripheral.connect()
        self.SessionInfo?.currentDevice.picoPeripheral.delegate = self
    }
    
    
    
    
    
    func DisplayInfo() {
        AthleteNameTableView.reloadData()
        AthleteNameTableView.backgroundColor = UIColor.black
        AthleteNameSelecionVIEW.isHidden = true
        
        WorkoutNameTF.text = self.SessionInfo?.currentWorkout.WorkoutName
        WorkoutEditVIEW.isHidden = true
        
        if self.SessionInfo?.currentDevice.dataStreamToggle == false {
            StopGoIMAGE.image =  UIImage(named: "WhiteCircle")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        } else {
            StopGoIMAGE.image = UIImage(named: "WhiteSquare")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        }
        
        DisplyTimerLBL.text = self.SessionInfo?.currentWorkout.formattedElapsedTime()
        SetsBTNLBL.setTitle("\( self.SessionInfo?.currentWorkout.WorkoutSetsCount ?? 0)", for: .normal)
        
        SubmitWorkoutBTN.layer.borderColor = UIColor.white.cgColor
        SubmitWorkoutBTN.layer.borderWidth = 1
        SubmitWorkoutBTN.layer.cornerRadius = 10
        
        WorkoutEditCancelBTN.layer.borderColor = UIColor.white.cgColor
        WorkoutEditCancelBTN.layer.borderWidth = 1
        WorkoutEditCancelBTN.layer.cornerRadius = 10
        
        
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
        
        
        WorkoutLBL.text = self.SessionInfo?.currentWorkout.WorkoutName
        
        let optionClosure = {(action : UIAction) in self.CheckPopUpNav(ActionTitle: action.title)}
        MenuBTN.menu = UIMenu(options: .displayInline, children : [UIAction(title : "Setup",handler: optionClosure),
                                                                   UIAction(title : "Data", state: .on, handler: optionClosure) ,
                                                                   UIAction(title : "Labeling", handler: optionClosure),
                                                                   UIAction(title : "Restart", handler: optionClosure) ])
    }
    func CheckPopUpNav(ActionTitle : String) {
        if ActionTitle == "Setup" {
            self.NavigationSelector = "SetupConnection"
            self.performSegue(withIdentifier: "PN", sender: self)
        } else if ActionTitle == "Data" {
            //            self.NavigationSelector = "DataAnalytics"
            //            self.performSegue(withIdentifier: "PN", sender: self)
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
            AthleteNameSelecionVIEW.isHidden = !AthleteNameSelecionVIEW.isHidden
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedAthleteLBL.text = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row].name
        SessionInfo?.currentTeam.AthleteSelected = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row]
        AthleteNameSelecionVIEW.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print(self.SessionInfo?.currentTeam.MasterListofAthletes.count)
        return self.SessionInfo?.currentTeam.MasterListofAthletes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = self.SessionInfo?.currentTeam.MasterListofAthletes[indexPath.row].name
        return cell!
    }
    
    
     
     ////////////////////////////////////////////////////
     ///Button Press for Workout Name Update
     ////////////////////////////////////////////////////
    @IBAction func WorkoutEditBTNPressed(_ sender: Any) {
        WorkoutEditVIEW.isHidden = !WorkoutEditVIEW.isHidden
    }
    @IBAction func WorkoutEditSaveBTNPressed(_ sender: Any) {
        self.SessionInfo?.currentWorkout.WorkoutName = WorkoutNameTF.text ?? ""
        WorkoutLBL.text = self.SessionInfo?.currentWorkout.WorkoutName
        WorkoutEditVIEW.isHidden = true
        self.view.endEditing(true)
    }
    @IBAction func WorkoutEditCancelBTNPressed(_ sender: Any) {
        WorkoutNameTF.text = self.SessionInfo?.currentWorkout.WorkoutName
        WorkoutEditVIEW.isHidden = true
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////
    /////////Draws the Muscle Image
    /// TODO : Get real data to display
    ////////////////////////////////////////////////////
    func drawOnMuscleIMAGE() -> UIImage {
        let emgValue =  self.SessionInfo?.currentWorkout.emgValue
        let rmsValue = self.SessionInfo?.currentWorkout.rmsValue
        
        //TODO Remove later when working (Open)
        if self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG.count ?? 0 > 500 {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG.remove(at: 0)
            self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG.append(400 - (emgValue ?? 0))
        } else {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG.append(400 - (emgValue ?? 0))
            
        }
        
        if self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS.count ?? 0 > 500 {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS.remove(at: 0)
            self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS.append(400 - (rmsValue ?? 0))
        } else {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS.append(400 - (rmsValue ?? 0))
        }
        
        if self.SessionInfo?.currentWorkout.WorkoutMovementLineY.count ?? 0 > 500 {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineY.remove(at: 0)
            self.SessionInfo?.currentWorkout.WorkoutMovementLineY.append(400 - (rmsValue ?? 0))
        } else {
            self.SessionInfo?.currentWorkout.WorkoutMovementLineY.append(400 - Double.random(in: 0...400))
        }
        //TODO Remove later when working
        
        
        let image : UIImage = UIImage()
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(MuscleIMAGE.image?.size ?? CGSize(width: 100, height: 100))
        
        // Draw the starting image in the current context as background
        image.draw(at: CGPoint.zero)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        for n in 1..<(self.SessionInfo?.currentWorkout.WorkoutMovementLineY.count ?? 0) {
            let StartX_EMG : Double =  (Double(n) * 3.0) //Double(MovementIMAGE.frame.maxX) -
            let StartY_EMG = self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG[n-1] ?? 0
            let EndX_EMG :  Double = (Double(n + 1) * 3.0)
            let EndY_EMG = self.SessionInfo?.currentWorkout.WorkoutMovementLineEMG[n] ?? 0
            
            let StartX_RMS : Double =  (Double(n) * 3.0) //Double(MovementIMAGE.frame.maxX) -
            let StartY_RMS = self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS[n-1] ?? 0
            let EndX_RMS : Double = (Double(n + 1) * 3.0)
            let EndY_RMS = self.SessionInfo?.currentWorkout.WorkoutMovementLineRMS[n] ?? 0
            
            // Draw the EMG line
            context.setLineWidth(2.0)
            context.setStrokeColor(UIColor.red.cgColor)
            context.move(to: CGPoint(x: StartX_EMG, y: StartY_EMG))
            context.addLine(to: CGPoint(x: EndX_EMG, y: EndY_EMG))
            context.strokePath()
            
            //Draw the RMS line
            context.setLineWidth(2.0)
            context.setStrokeColor(UIColor.blue.cgColor)
            context.move(to: CGPoint(x: StartX_RMS, y: StartY_RMS))
            context.addLine(to: CGPoint(x: EndX_RMS, y: EndY_RMS))
            context.strokePath()
        }
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
    
    
    
    
    ////////////////////////////////////////////////////
    /////////Draws the Muscle Image
    ////////////////////////////////////////////////////
    func drawOnMovementIMAGE() -> UIImage {
        let image : UIImage = UIImage()
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(MovementIMAGE.image?.size ?? CGSize(width: 100, height: 100))
        
        // Draw the starting image in the current context as background
        image.draw(at: CGPoint.zero)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        self.SessionInfo?.currentWorkout.setWorkoutDisplayTriangle(maxWidth: Double(MovementIMAGE.image?.size.width ?? 0), maxHeight: Double(MovementIMAGE.image?.size.height ?? 0))
        let TopLeftX : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint0X() ?? 0
        let TopLeftY : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint0Y() ?? 0
        let TopRightX : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint1X() ?? 0
        let TopRightY : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint1Y() ?? 0
        let BottomX : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint2X() ?? 0
        let BottomY : Int = self.SessionInfo?.currentWorkout.getWorkoutDisplayTrianglePoint2Y() ?? 0
        
        
        // Draw a red line
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        context.move(to: CGPoint(x: TopLeftX, y: TopLeftY))
        context.addLine(to: CGPoint(x: TopRightX, y: TopRightY))
        context.strokePath()
        
        // Draw a white line
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.white.cgColor)
        context.move(to: CGPoint(x: TopLeftX, y: TopLeftY))
        context.addLine(to: CGPoint(x: BottomX, y: BottomY))
        context.strokePath()
        
        
        // Draw a green line
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.green.cgColor)
        context.move(to: CGPoint(x: TopRightX, y: TopRightY))
        context.addLine(to: CGPoint(x: BottomX, y: BottomY))
        context.strokePath()
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
    
    
    
    
    
    ////////////////////////////////////////////////////
    ////Functions for the peripheral delegate
    ////////////////////////////////////////////////////
    func picoDidConnect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if self.SessionInfo?.currentDevice.isStreming ?? false {
                self.SessionInfo?.currentDevice.picoPeripheral.basePeripheral.setNotifyValue(true, for: (self.SessionInfo?.currentDevice.picoPeripheral.characteristic)!)
            }
        }
    }
    func picoDidDisconnect() {
        DispatchQueue.main.async { [self] in
            self.SessionInfo?.currentDevice.picoPeripheral.connect()
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.reconnectPeripheral), userInfo: nil, repeats: true)
        }
    }
    @objc func reconnectPeripheral() {
        if !(self.SessionInfo?.currentDevice.picoPeripheral.isConnected ?? false){
            self.SessionInfo?.currentDevice.picoPeripheral.connect()
        } else {
            self.timer?.invalidate()
        }
    }
    
    // Function to convert array to string
    func arrayToString<T>(_ array: [T]) -> String {
        return array.map { String(describing: $0) }.joined(separator: ", ")
    }
    
    

    
    func updateDataRecive(Data: Data) {
        DispatchQueue.global(qos: .background).async {
            //self.SessionInfo?.currentRecording.appendDataPacket(Data: Data)
                        
            Thread.sleep(forTimeInterval: 0.001)
            
            let FrameCountResults = (self.SessionInfo?.currentDevice.picoPeripheral.dataThread.FrameCountResults)!
            let GetFramesResult = (self.SessionInfo?.currentDevice.picoPeripheral.dataThread.GetFramesResult)!
            
          //  print(FrameCountResults)
            
            //TODO READ 9) The result is a multiple of 15, this print statement is just looking for how many data frames have come out.
            for n in 0..<FrameCountResults/15 {
                var incomingDataArray : [Double] = []
                for m in 0..<15 {
                    incomingDataArray.append(GetFramesResult[m + 15*Int(n)] )
                }
                
                //TODO READ 10) Each frame gets sent to the currentWorkout to get sorted out. (Your work will mainly be to fix this step)
                self.SessionInfo?.currentWorkout.WorkoutIncomingDataArraySort(incomingArray: incomingDataArray)
                
                //TODO READ 11) The display gets thrown back to the main thread beccause UI work can only be on the main thread.
                DispatchQueue.main.sync {
                    self.MovementIMAGE.image = self.drawOnMovementIMAGE()
                    self.MuscleIMAGE.image = self.drawOnMuscleIMAGE()
                    self.DisplyTimerLBL.text = self.SessionInfo?.currentWorkout.formattedElapsedTime()
                   self.SetsBTNLBL.setTitle("\( self.SessionInfo?.currentWorkout.WorkoutSetsCount ?? 0)", for: .normal)
                }
            }
        }
    }
    
    
    
    
    
    ////////////////////////////////////////////////////
    //////////////////////////Button Pressed for
    /////////////////Data Feed to Start or Stop
    ////////////////////////////////////////////////////
    @IBAction func RecordBTNPressed(_ sender: Any) {
        //TODO READ 1) The process begins with the user pressing this button
        self.SessionInfo?.currentDevice.DataStreamToggle()
        if self.SessionInfo?.currentDevice.dataStreamToggle == false {
            StopGoIMAGE.image =  UIImage(named: "WhiteCircle")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            self.SessionInfo?.currentWorkout.startStop()
        } else {
            StopGoIMAGE.image = UIImage(named: "WhiteSquare")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
            self.SessionInfo?.currentWorkout.startStop()
        }
    }
    
    
    
    
    ////////////////////////////////////////////////////
    //////////Buttons Pressed for Navigation
    ////////////////////////////////////////////////////
    @IBAction func SubmitWorkoutBTNPressed(_ sender: Any) {
        //Push workout into database
        self.SessionInfo?.postRecordings()
        
        self.NavigationSelector = "QuickStart"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func AnalyticsBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "DataAnalytics"
        //        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func ZonesBTNPressed(_ sender: Any) {
        self.NavigationSelector = "DataZones"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func GraphsBTNPressed(_ sender: Any) {
        self.NavigationSelector = "DataGraphs"
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
