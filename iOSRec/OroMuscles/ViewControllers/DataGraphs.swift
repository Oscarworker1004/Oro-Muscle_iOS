//
//  DataGraphs.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 6/21/23.
//

import UIKit
import Charts

class DataGraphs: UIViewController , ChartViewDelegate , PicoBlueDelegate{
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var MenuBTN: UIButton!
    @IBOutlet weak var SubmitWorkoutBTN: UIButton!
    @IBOutlet weak var StopGoIMAGE: UIImageView!
    @IBOutlet weak var DisplyTimerLBL: UILabel!
    @IBOutlet weak var SetsBTNLBL: UIButton!
    @IBOutlet weak var IntensityChartVIEW: UIView!
    @IBOutlet weak var WorkCapacityChartVIEW: UIView!
    @IBOutlet weak var IntensityWIDTH: NSLayoutConstraint!
    @IBOutlet weak var WorkCapacityWIDTH: NSLayoutConstraint!
    @IBOutlet weak var IntensityCHART: BarChartView!
    @IBOutlet weak var WorkCapacityCHART: BarChartView!
    
    var timer: Timer?
    public func setPeripheral(_ peripheral: picoBluePeripheral) {
        self.SessionInfo?.currentDevice.picoPeripheral = peripheral
        self.SessionInfo?.currentDevice.picoPeripheral.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayInfo()
        MakeCharts()
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
                                                                   UIAction(title : "Labeling", handler: optionClosure) ,
                                                                   UIAction(title : "Restart", handler: optionClosure)])
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
    ///Resizes the Chart Width based off # of entries
    ////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        if self.view.frame.size.width - 50 > CGFloat(25 + self.SessionInfo!.currentWorkout.WorkoutRepCountLabels.count * 17) {
            IntensityWIDTH.constant = CGFloat(25 + self.SessionInfo!.currentWorkout.WorkoutRepCountLabels.count * 17)
            WorkCapacityWIDTH.constant = CGFloat(25 + self.SessionInfo!.currentWorkout.WorkoutRepCountLabels.count * 17)
        } else{
            IntensityWIDTH.constant = self.view.frame.size.width - 50
            WorkCapacityWIDTH.constant = self.view.frame.size.width - 50
        }
    }
    
    
    
    
    ////////////////////////////////////////////////////
    ///Draws the Charts for Intensity and Work Capacity
    /// TODO : Get real data to display
    ////////////////////////////////////////////////////
    func MakeCharts() {
        var entriesIN = [ChartDataEntry]()
        var setColorsIN : [UIColor] = []
        for i in 0..<(self.SessionInfo?.currentWorkout.WorkoutIntensity.count ?? 0) {
            entriesIN.append(BarChartDataEntry(x: Double(i), y: (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! ))
            if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 1.0 { setColorsIN.append(UIColor(named: "IZone1")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 2.0 { setColorsIN.append(UIColor(named: "IZone2")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 3.0 { setColorsIN.append(UIColor(named: "IZone3")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 4.0 { setColorsIN.append(UIColor(named: "IZone4")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 5.0 { setColorsIN.append(UIColor(named: "IZone5")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 6.0 { setColorsIN.append(UIColor(named: "IZone6")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutIntensity[i])! <= 7.0 { setColorsIN.append(UIColor(named: "IZone7")!)
            }
        }
        let setIN = BarChartDataSet(entries: entriesIN)
        setIN.colors = setColorsIN
        let dataIN = BarChartData(dataSet: setIN)
        dataIN.barWidth = Double(0.60)
        dataIN.setDrawValues(false)
        IntensityCHART.data = dataIN
        
        var entriesWC = [ChartDataEntry]()
        var setColorsWC : [UIColor] = []
        for i in 0..<(self.SessionInfo?.currentWorkout.WorkoutWorkCapacity.count ?? 0) {
            entriesWC.append(BarChartDataEntry(x: Double(i), y: (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! ))
            if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 1.0 { setColorsWC.append(UIColor(named: "IZone1")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 2.0 { setColorsWC.append(UIColor(named: "IZone2")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 3.0 { setColorsWC.append(UIColor(named: "IZone3")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 4.0 { setColorsWC.append(UIColor(named: "IZone4")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 5.0 { setColorsWC.append(UIColor(named: "IZone5")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 6.0 { setColorsWC.append(UIColor(named: "IZone6")!)
            } else if (self.SessionInfo?.currentWorkout.WorkoutWorkCapacity[i])! <= 7.0 { setColorsWC.append(UIColor(named: "IZone7")!)
            }
        }
        let setWC = BarChartDataSet(entries: entriesWC)
        setWC.colors = setColorsWC
        let dataWC = BarChartData(dataSet: setWC)
        dataWC.barWidth = Double(0.60)
        dataWC.setDrawValues(false)
        WorkCapacityCHART.data = dataWC
        
        
        IntensityCHART.xAxis.labelTextColor = UIColor.white
        IntensityCHART.xAxis.labelPosition = .bottom
        IntensityCHART.xAxis.drawGridLinesEnabled = false
        IntensityCHART.xAxis.drawAxisLineEnabled = false
        IntensityCHART.rightAxis.enabled = false
        IntensityCHART.legend.enabled = false
        IntensityCHART.leftAxis.axisMinimum = 0.0
        IntensityCHART.leftAxis.axisMaximum = 7.0
        IntensityCHART.leftAxis.drawAxisLineEnabled = false
        IntensityCHART.leftAxis.drawGridLinesEnabled = false
        IntensityCHART.leftAxis.drawLabelsEnabled = false
        IntensityCHART.drawGridBackgroundEnabled = false
        IntensityCHART.scaleYEnabled = false
        IntensityCHART.scaleXEnabled = false
        IntensityCHART.pinchZoomEnabled = false
        IntensityCHART.doubleTapToZoomEnabled = false
        IntensityCHART.highlighter = nil
        IntensityCHART.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.SessionInfo!.currentWorkout.WorkoutRepCountLabels)
        IntensityCHART.xAxis.granularity = 1.0
        
        ///Work Capacity
        WorkCapacityCHART.xAxis.labelTextColor = UIColor.white
        WorkCapacityCHART.xAxis.labelPosition = .bottom
        WorkCapacityCHART.xAxis.drawGridLinesEnabled = false
        WorkCapacityCHART.xAxis.drawAxisLineEnabled = false
        WorkCapacityCHART.rightAxis.enabled = false
        WorkCapacityCHART.legend.enabled = false
        WorkCapacityCHART.leftAxis.axisMinimum = 0.0
        WorkCapacityCHART.leftAxis.axisMaximum = 7.0
        WorkCapacityCHART.leftAxis.drawAxisLineEnabled = false
        WorkCapacityCHART.leftAxis.drawGridLinesEnabled = false
        WorkCapacityCHART.drawGridBackgroundEnabled = false
        WorkCapacityCHART.leftAxis.drawLabelsEnabled = false
        WorkCapacityCHART.scaleYEnabled = false
        WorkCapacityCHART.scaleXEnabled = false
        WorkCapacityCHART.pinchZoomEnabled = false
        WorkCapacityCHART.doubleTapToZoomEnabled = false
        WorkCapacityCHART.highlighter = nil
        WorkCapacityCHART.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.SessionInfo!.currentWorkout.WorkoutRepCountLabels)
        WorkCapacityCHART.xAxis.granularity = 1.0
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
                    self.MakeCharts()
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
        self.NavigationSelector = "DataZones"
        self.performSegue(withIdentifier: "PN", sender: self)
    }
    @IBAction func GraphsBTNPressed(_ sender: Any) {
        //        self.NavigationSelector = "DataGraphs"
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
