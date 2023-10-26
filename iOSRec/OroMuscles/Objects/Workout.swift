//
//  Workout.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation


class Workout : NSObject {
    ///This is basic Info for the workout
    var WorkoutName : String = ""
    var WorkoutDate : String = ""
    
    var arrayIndex = 0
    var emgValue = 0.0
    var rmsValue = 0.0
    
    
    /// This is to track the timer during the workout
    var WorkoutTimer: Timer?
    @Published var elapsedTime: TimeInterval = 0
    
    ///This is part of the analysis data, likely to change when I get a better understanding of it TODO
    var WorkoutEMG : [Double] = []
    var WorkoutRMS : [Double] = []
    var WorkoutACC0 : [Double] = []
    var WorkoutACC1 : [Double] = []
    var WorkoutACC2 : [Double] = []
    var WorkoutGYR0 : [Double] = []
    var WorkoutGYR1 : [Double] = []
    var WorkoutGYR2 : [Double] = []
    var WorkoutIntensityNOW : Double = 0.0
    var WorkoutWorkCapacityNOW : Double = 0.0
    var WorkoutIntensity : [Double] = []
    var WorkoutWorkCapacity : [Double] = []
    var WorkoutRepCountLabels : [String] =  []
    var WorkoutSetsCount : Int = 0
   
    var WorkoutMovementLineY : [Double] = []
    var WorkoutMovementLineRMS : [Double] = []
    var WorkoutMovementLineEMG : [Double] = []

    
    ///This is part of the analysis data for displaying the Triangle Movement.
    var WorkoutDisplayTrianglemaxWidth : Double  = 0
    var WorkoutDisplayTrianglemaxHeight : Double  = 0
    var WorkoutDisplayTrianglePoint0X : Double = 0
    var WorkoutDisplayTrianglePoint0Y : Double = 0
    var WorkoutDisplayTrianglePoint1X : Double = 0
    var WorkoutDisplayTrianglePoint1Y : Double = 0
    var WorkoutDisplayTrianglePoint2X : Double = 0
    var WorkoutDisplayTrianglePoint2Y : Double = 0
    
    
    let emgQueue = DispatchQueue(label: "oromuscles.workout.emgAccess", attributes: .concurrent)
    let rmsQueue = DispatchQueue(label: "oromuscles.workout.rmsAccess", attributes: .concurrent)
    let acc0Queue = DispatchQueue(label: "oromuscles.workout.acc0Access", attributes: .concurrent)
    let acc1Queue = DispatchQueue(label: "oromuscles.workout.acc1Access", attributes: .concurrent)
    let acc2Queue = DispatchQueue(label: "oromuscles.workout.acc2Access", attributes: .concurrent)
    let gyr0Queue = DispatchQueue(label: "oromuscles.workout.gyr0Access", attributes: .concurrent)
    let gyr1Queue = DispatchQueue(label: "oromuscles.workout.gyr1Access", attributes: .concurrent)
    let gyr2Queue = DispatchQueue(label: "oromuscles.workout.gyr2Access", attributes: .concurrent)
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        
    }
    
    /////////////////////////////////////////////////////////////////
    /////////Resets the needed info for a new Workout
    /////////////////////////////////////////////////////////////////
     func ResetWorkout() {
         elapsedTime = 0
        // WorkoutRepCountLabels = []  TODO Remove later
         WorkoutIntensityNOW = 0.0
         WorkoutWorkCapacityNOW = 0.0
         WorkoutIntensity = []
         WorkoutWorkCapacity = []
     }
     
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Brings in and sorts the  Incoming Data
    /////////////////////////////////////////////////////////////////
    func WorkoutIncomingDataArraySort(incomingArray : [Double]) {
       //TODO READ 10.1) READ 10 calls this method. This saves the raw data from GetFrames. add methods need help. DisplayTrianglePoint methods are fine.
        
        // 0= Frame
        // 1=EMG
        // 2=RMS
        // 3-5 =ACC-0, 1, 2
        // 6-8 =GYR-0, 1, 2
        addWorkoutEMG(val: incomingArray[1])
        addWorkoutRMS(val: incomingArray[2])
        addWorkoutACC0(val: incomingArray[3])
        addWorkoutACC1(val: incomingArray[4])
        addWorkoutACC2(val: incomingArray[5])
        addWorkoutGYR0(val: incomingArray[6])
        addWorkoutGYR1(val: incomingArray[7])
        addWorkoutGYR2(val: incomingArray[8])
        
        // 9-10  = Triangle point 0  (x, y)
        // 11-12 = Triangle point 1  (x, y)
        // 13-14 = Triangle point 2  (x, y)
        WorkoutDisplayTrianglePoint0X = incomingArray[9]
        WorkoutDisplayTrianglePoint0Y = incomingArray[10]
        WorkoutDisplayTrianglePoint1X = incomingArray[11]
        WorkoutDisplayTrianglePoint1Y = incomingArray[12]
        WorkoutDisplayTrianglePoint2X = incomingArray[13]
        WorkoutDisplayTrianglePoint2Y = incomingArray[14]
        
        
        Calculations()
    }
    
    
    /////////////////////////////////////////////////////////////////
    ///////////Redo the values for WC and Intensity
    /////////////////////////////////////////////////////////////////
    //TODO READ 10.2) Currently these are being added to the arrays.
    func addWorkoutEMG(val : Double){
        emgQueue.async(flags: .barrier) {
            self.WorkoutEMG.append(val)
            self.emgValue = val
        }
    }
    func addWorkoutRMS(val : Double){
        rmsQueue.async(flags: .barrier) {
            self.WorkoutRMS.append(val)
            self.rmsValue = val
        }
    }
    func addWorkoutACC0(val : Double){
        acc0Queue.async(flags: .barrier) {
            self.WorkoutACC0.append(val)
        }
    }
    func addWorkoutACC1(val : Double){
        acc1Queue.async(flags: .barrier) {
            self.WorkoutACC1.append(val)
        }
    }
    func addWorkoutACC2(val : Double){
        acc2Queue.async(flags: .barrier) {
            self.WorkoutACC2.append(val)
        }
    }
    func addWorkoutGYR0(val : Double){
        gyr0Queue.async(flags: .barrier) {
            self.WorkoutGYR0.append(val)
        }
    }
    func addWorkoutGYR1(val : Double){
        gyr1Queue.async(flags: .barrier) {
            self.WorkoutGYR1.append(val)
        }
    }
    func addWorkoutGYR2(val : Double){
        gyr2Queue.async(flags: .barrier) {
            self.WorkoutGYR2.append(val)
        }

    }
    
    func Calculations () {
        //TODO READ 10.3) Problem :  use RMSAnalyze on the raw data..? This is where the raw data from GetFrames need to be translated to the WorkCapacity and Intensity
        
        
        //These are the variable that need answers
        //WorkoutMovementLineY.append(5) // The Y will display and then shift to display only the last entries that still fit on the screen
        
        WorkoutSetsCount = 3
        
        WorkoutIntensityNOW  = 4.0 //TODO Scales the number between min = 0 and max = 7
        WorkoutWorkCapacityNOW  = 5.0 //TODO Scales the number between min = 0 and max = 7
        
        if  WorkoutIntensity.count < 5 { //Just adding this until tthere's real info to show
            WorkoutIntensity.append(5) //each entry in this array need to be between min = 0 and max = 7 for display
            WorkoutWorkCapacity.append(5) //each entry in this array need to be between min = 0 and max = 7 for display
            WorkoutRepCountLabels.append("\(WorkoutRepCountLabels.count)")
        }
        //once these are filled, display will happen automatically
    }
    
    func getZoneIntensity() -> Double {
        //TODO Scales the number between min = 0 and max = 7
        let WI : Double = WorkoutIntensityNOW
       
        //Sends that value out for display
        return WI
    }
    func getZoneWorkCapacity() -> Double {
        //TODO Scales the number between min = 0 and max = 7
        let WC : Double = WorkoutWorkCapacityNOW
      
        //Sends that value out for display
        return WC
    }
    func resetDisplayGraphs() {
        //After a certain amount of dead time, I believe that the display graphs are reset
        WorkoutIntensity.removeAll()
        WorkoutWorkCapacity.removeAll()
        WorkoutRepCountLabels.removeAll()
    }
    
    /////////////////////////////////////////////////////////////////
    ///////////Functions for scaling the triangle display
    /////////////////////////////////////////////////////////////////
    func setWorkoutDisplayTriangle(maxWidth : Double, maxHeight : Double) {
        WorkoutDisplayTrianglemaxHeight  = maxHeight
        WorkoutDisplayTrianglemaxWidth = maxWidth
    }
    //Formula used to create scaling is X/X = X/X
    // X/ImageWidth = GivenPoint / Range
    // X = GivenPoint * ImageWidth / Range
    //Adjustment is made with width/2 or height /2 to move the center to be in the middle of the image instead of the top left of the image.
    func getWorkoutDisplayTrianglePoint0X( ) -> Int {
        let X : Int = Int(WorkoutDisplayTrianglePoint0X * WorkoutDisplayTrianglemaxWidth / 8 + WorkoutDisplayTrianglemaxWidth / 2)
        return X }
    func getWorkoutDisplayTrianglePoint0Y( ) -> Int {
        let Y : Int = Int(WorkoutDisplayTrianglePoint0Y * WorkoutDisplayTrianglemaxHeight / 8 + WorkoutDisplayTrianglemaxHeight / 2)
        return Y }
    func getWorkoutDisplayTrianglePoint1X( ) -> Int {
        let X : Int = Int(WorkoutDisplayTrianglePoint1X * WorkoutDisplayTrianglemaxWidth / 8 + WorkoutDisplayTrianglemaxWidth / 2)
        return X }
    func getWorkoutDisplayTrianglePoint1Y( ) -> Int {
        let Y : Int = Int(WorkoutDisplayTrianglePoint1Y * WorkoutDisplayTrianglemaxHeight / 8 + WorkoutDisplayTrianglemaxHeight / 2)
        return Y }
    func getWorkoutDisplayTrianglePoint2X( ) -> Int {
        let X : Int = Int(WorkoutDisplayTrianglePoint2X * WorkoutDisplayTrianglemaxWidth / 8 + WorkoutDisplayTrianglemaxWidth / 2)
        return X }
    func getWorkoutDisplayTrianglePoint2Y( ) -> Int {
        let Y : Int = Int(WorkoutDisplayTrianglePoint2Y * WorkoutDisplayTrianglemaxHeight / 8 + WorkoutDisplayTrianglemaxHeight / 2)
        return Y }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    ///Timer Display
    /////////////////////////////////////////////////////////////////
    func startStop() {
        // If the timer is running, stop it
        if let timer = WorkoutTimer{
            timer.invalidate()
            WorkoutTimer = nil
            elapsedTime = 0
        } else {
            // Start the timer
            WorkoutTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
                // Update the elapsed time
                self?.elapsedTime += timer.timeInterval
            })
        }
    }
    func formattedElapsedTime() -> String {
         // Format the elapsed time as a stopwatch time
         let hours = Int(elapsedTime) / (60 * 60) % 24
         let minutes = Int(elapsedTime) / 60 % 60
         let seconds = Int(elapsedTime) % 60
         let milliseconds = Int(elapsedTime * 100) % 100
         
         // Return the formatted time
         return String(format: "%02d:%02d:%02d:%02d", hours, minutes, seconds, milliseconds)
     }
}
