//
//  DataZones.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/21/23.
//

import UIKit

class DataZones: UIViewController, PicoBlueDelegate {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var SubmitWorkoutBTN: UIButton!
    @IBOutlet weak var StopGoIMAGE: UIImageView!
    @IBOutlet weak var DisplyTimerLBL: UILabel!
    @IBOutlet weak var SetsBTNLBL: UIButton!
    @IBOutlet weak var IntensityIMAGE: UIImageView!
    @IBOutlet weak var WorkCapacityIMAGE: UIImageView!
    
    var timer: Timer?
    public func setPeripheral(_ peripheral: picoBluePeripheral) {
        self.SessionInfo?.currentDevice.picoPeripheral = peripheral
        self.SessionInfo?.currentDevice.picoPeripheral.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayInfo()
        self.SessionInfo?.currentDevice.picoPeripheral.connect()
        self.SessionInfo?.currentDevice.picoPeripheral.delegate = self
    }
    
    func DisplayInfo() {
        if self.SessionInfo?.currentDevice.dataStreamToggle == false {
            StopGoIMAGE.image =  UIImage(named: "WhiteCircle")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        } else {
            StopGoIMAGE.image = UIImage(named: "WhiteSquare")?.withAlignmentRectInsets(UIEdgeInsets(top: -3, left: -3, bottom: -3, right: -3))
        }
        
        DisplyTimerLBL.text = self.SessionInfo?.currentWorkout.formattedElapsedTime()
        SetsBTNLBL.setTitle("\(self.SessionInfo?.currentWorkout.WorkoutSetsCount ?? 0)", for: .normal)
        
        SubmitWorkoutBTN.layer.borderColor = UIColor.white.cgColor
        SubmitWorkoutBTN.layer.borderWidth = 1
        SubmitWorkoutBTN.layer.cornerRadius = 10
        
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
    /////////Adds the Dial to indicate the zone
    /// TODO : Get real data to display
    ////////////////////////////////////////////////////
    func ImageUpdaters(){
        let Intensity : Double = self.SessionInfo!.currentWorkout.getZoneIntensity()
        
        if  Intensity < 0.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator00.png")
        } else if  Intensity < 1.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator05.png")
        } else if  Intensity < 1.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator10.png")
        } else if  Intensity < 2.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator15.png")
        } else if  Intensity < 2.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator20.png")
        } else if  Intensity < 3.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator25.png")
        } else if  Intensity < 3.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator30.png")
        } else if  Intensity < 4.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator35.png")
        } else if  Intensity < 4.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator40.png")
        } else if  Intensity < 5.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator45.png")
        } else if  Intensity < 5.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator50.png")
        } else if  Intensity < 6.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator55.png")
        } else if  Intensity < 6.5 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator60.png")
        } else if  Intensity < 7.0 { IntensityIMAGE.image = UIImage(named: "IZoneIndicator65.png")
        } else { IntensityIMAGE.image = UIImage(named: "IZoneIndicator70.png") }
        
        let WorkCapacity : Double = self.SessionInfo!.currentWorkout.getZoneWorkCapacity()
        if WorkCapacity < 0.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator00.png")
        } else if WorkCapacity < 1.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator05.png")
        } else if WorkCapacity < 1.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator10.png")
        } else if WorkCapacity < 2.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator15.png")
        } else if WorkCapacity < 2.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator20.png")
        } else if WorkCapacity < 3.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator25.png")
        } else if WorkCapacity < 3.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator30.png")
        } else if WorkCapacity < 4.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator35.png")
        } else if WorkCapacity < 4.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator40.png")
        } else if WorkCapacity < 5.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator45.png")
        } else if WorkCapacity < 5.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator50.png")
        } else if WorkCapacity < 6.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator55.png")
        } else if WorkCapacity < 6.5 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator60.png")
        } else if WorkCapacity < 7.0 { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator65.png")
        } else { WorkCapacityIMAGE.image = UIImage(named: "IZoneIndicator70.png") }
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
    func updateDataRecive(Data: Data) {
        DispatchQueue.global(qos: .background).async {
            self.SessionInfo?.currentRecording.appendDataPacket(Data: Data)
            let ct : CTop_Wrapper = CTop_Wrapper()
            
            var CometaSignatureDataByString = [UInt8]()
            CometaSignatureDataByString.append(127)
            CometaSignatureDataByString.append(127)
            CometaSignatureDataByString.append(127)
            CometaSignatureDataByString.append(127)
            for n in 0..<Data.count {
                CometaSignatureDataByString.append(Data[n])
            }
            
            let ptr2 = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: CometaSignatureDataByString.count)
            ptr2.initialize(repeating: 1, count: CometaSignatureDataByString.count)
            for n in 0..<CometaSignatureDataByString.count {
                ptr2[n] = CUnsignedChar(CometaSignatureDataByString[n])
            }
            
            ct.ctopWtopFeedData(ptr2, Int32(CometaSignatureDataByString.count))
            
            let OUTSIZE : Int = 300
            let GetFramesResult = UnsafeMutablePointer<Double>.allocate(capacity: OUTSIZE)
            GetFramesResult.initialize(repeating: 1, count: OUTSIZE)
            let FrameCountResults: Int32 = ct.ctopWtopGetFrames(GetFramesResult, Int32(OUTSIZE), 15)
            print("\(FrameCountResults)")
            for n in 0..<FrameCountResults/15 {
                var incomingDataArray : [Double] = []
                for m in 0..<15 {
                    incomingDataArray.append(GetFramesResult[m + 15*Int(n)] )
                }
                self.SessionInfo?.currentWorkout.WorkoutIncomingDataArraySort(incomingArray: incomingDataArray)
                DispatchQueue.main.sync {
                    self.ImageUpdaters()
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
        self.NavigationSelector = "DataAnalytics"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func ZonesBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "DataZones"
        //        self.performSegue(withIdentifier: "PN", sender: self)
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
