//
//  ExerciseDB.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class ExerciseInfo: NSObject {
    ///Master List is currently hardcoded information
    var MasterListOfExercises : [String : [String]] = [:]
    var MasterListOfExercisesHeadings :[String] = []
    
    ///This is marking which selections have been made for ease of display and memory
    var ExerciseSelectionFinished : Bool = false
    var ExercisesSelectedHeadings : [String] = []
    var ExerciseGroupSelected : String = ""
    
    ///This is marking which exercises have been selected in the current Training Session
    var ExercisesSelected : [String : [String : [Int]]] = [:]
    
    

    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    ////////////////////Master List setup on initialization
    /////////////////////////////////////////////////////////////////
    override init() {
        MasterListOfExercisesHeadings = ["All","Chest Exercises", "Shoulder Exercises", "Bicep Exercises", "Triceps Exercises", "Leg Exercises", "Back Exercises", "Glute Exercises", "Ab Exercises", "Calves Exercises", "Forearm Flexors & Grip Exercises", "Forearm Extensor Exercises"]
        
        self.MasterListOfExercises["All"] = ["Bar Dip", "Bench Press", "Cable Chest Press", "Close-Grip Bench Press", "Close-Grip Feet-Up Bench Press", "Decline Bench Press", "Dumbbell Chest Fly", "Dumbbell Chest Press", "Dumbbell Decline Chest Press", "Dumbbell Floor Press", "Dumbbell Pullover", "Feet-Up Bench Press", "Floor Press", "Incline Bench Press", "Incline Dumbbell Press", "Incline Push-Up", "Kneeling Incline Push-Up", "Kneeling Push-Up", "Machine Chest Fly", "Machine Chest Press", "Pec Deck", "Push-Up", "Push-Up Against Wall", "Push-Ups With Feet in Rings", "Resistance Band Chest Fly", "Smith Machine Bench Press", "Smith Machine Incline Bench Press", "Standing Cable Chest Fly", "Standing Resistance Band Chest Fly", "Band External Shoulder Rotation", "Band Internal Shoulder Rotation", "Band Pull-Apart", "Barbell Front Raise", "Barbell Rear Delt Row", "Barbell Upright Row", "Behind the Neck Press", "Cable Lateral Raise", "Cable Rear Delt Row", "Dumbbell Front Raise", "Dumbbell Horizontal Internal Shoulder Rotation", "Dumbbell Horizontal External Shoulder Rotation", "Dumbbell Lateral Raise", "Dumbbell Rear Delt Row", "Dumbbell Shoulder Press", "Face Pull", "Front Hold", "Lying Dumbbell External Shoulder Rotation", "Lying Dumbbell Internal Shoulder Rotation", "Machine Lateral Raise", "Machine Shoulder Press", "Monkey Row", "Overhead Press", "Plate Front Raise", "Power Jerk", "Push Press", "Reverse Dumbbell Flyes", "Reverse Machine Fly", "Seated Dumbbell Shoulder Press", "Seated Barbell Overhead Press", "Seated Smith Machine Shoulder Press", "Snatch Grip Behind the Neck Press", "Squat Jerk", "Split Jerk", "Barbell Curl", "Barbell Preacher Curl", "Bodyweight Curl", "Cable Curl With Bar", "Cable Curl With Rope", "Concentration Curl", "Dumbbell Curl", "Dumbbell Preacher Curl", "Hammer Curl", "Incline Dumbbell Curl", "Machine Bicep Curl", "Spider Curl","Barbell Standing Triceps Extension", "Barbell Lying Triceps Extension", "Bench Dip", "Close-Grip Push-Up", "Dumbbell Lying Triceps Extension", "Dumbbell Standing Triceps Extension", "Overhead Cable Triceps Extension", "Tricep Bodyweight Extension", "Tricep Pushdown With Bar", "Tricep Pushdown With Rope", "Air Squat", "Barbell Hack Squat", "Barbell Lunge", "Barbell Walking Lunge", "Belt Squat", "Body Weight Lunge", "Box Squat", "Bulgarian Split Squat", "Chair Squat", "Dumbbell Lunge", "Dumbbell Squat", "Front Squat", "Goblet Squat", "Hack Squat Machine", "Half Air Squat", "Hip Adduction Machine", "Landmine Hack Squat", "Landmine Squat", "Leg Extension", "Leg Press", "Lying Leg Curl", "Pause Squat", "Romanian Deadlift", "Safety Bar Squat", "Seated Leg Curl", "Shallow Body Weight Lunge", "Side Lunges (Bodyweight)", "Smith Machine Squat", "Squat", "Step Up", "Back Extension", "Barbell Row", "Barbell Shrug", "Block Snatch", "Cable Close Grip Seated Row", "Cable Wide Grip Seated Row", "Chin-Up", "Clean", "Clean and Jerk", "Deadlift", "Deficit Deadlift", "Dumbbell Deadlift", "Dumbbell Row", "Dumbbell Shrug", "Floor Back Extension", "Good Morning", "Hang Clean", "Hang Power Clean", "Hang Power Snatch", "Hang Snatch", "Inverted Row", "Inverted Row with Underhand Grip", "Kettlebell Swing", "Lat Pulldown With Pronated Grip", "Lat Pulldown With Supinated Grip", "One-Handed Cable Row", "One-Handed Lat Pulldown", "Pause Deadlift", "Pendlay Row", "Power Clean", "Power Snatch", "Pull-Up", "Rack Pull", "Seal Row", "Seated Machine Row", "Snatch", "Snatch Grip Deadlift", "Stiff-Legged Deadlift", "Straight Arm Lat Pulldown", "Sumo Deadlift", "T-Bar Row", "Trap Bar Deadlift With High Handles", "Trap Bar Deadlift With Low Handles", "Banded Side Kicks", "Cable Pull Through", "Clamshells", "Dumbbell Romanian Deadlift", "Dumbbell Frog Pumps", "Fire Hydrants", "Frog Pumps", "Glute Bridge", "Hip Abduction Against Band", "Hip Abduction Machine", "Hip Thrust", "Hip Thrust Machine", "Hip Thrust With Band Around Knees", "Lateral Walk With Band", "Machine Glute Kickbacks", "One-Legged Glute Bridge", "One-Legged Hip Thrust", "Romanian Deadlift", "Single Leg Romanian Deadlift", "Standing Glute Kickback in Machine", "Step Up", "Cable Crunch", "Crunch", "Dead Bug", "Hanging Leg Raise", "Hanging Knee Raise", "Hanging Sit-Up", "High to Low Wood Chop with Band", "Horizontal Wood Chop with Band", "Kneeling Ab Wheel Roll-Out", "Kneeling Plank", "Kneeling Side Plank", "Lying Leg Raise", "Lying Windshield Wiper", "Lying Windshield Wiper with Bent Knees", "Machine Crunch", "Mountain Climbers", "Oblique Crunch", "Oblique Sit-Up", "Plank", "Side Plank", "Sit-Up","Eccentric Heel Drop", "Heel Raise", "Seated Calf Raise", "Standing Calf Raise", "Barbell Wrist Curl", "Barbell Wrist Curl Behind the Back", "Bar Hang", "Dumbbell Wrist Curl", "Farmers Walk", "Fat Bar Deadlift", "Gripper", "One-Handed Bar Hang", "Plate Pinch", "Plate Wrist Curl", "Towel Pull-Up", "Barbell Wrist Extension", "Dumbbell Wrist Extension"]
        
        
        
        self.MasterListOfExercises["Chest Exercises"] = ["Bar Dip", "Bench Press", "Cable Chest Press", "Close-Grip Bench Press", "Close-Grip Feet-Up Bench Press", "Decline Bench Press", "Dumbbell Chest Fly", "Dumbbell Chest Press", "Dumbbell Decline Chest Press", "Dumbbell Floor Press", "Dumbbell Pullover", "Feet-Up Bench Press", "Floor Press", "Incline Bench Press", "Incline Dumbbell Press", "Incline Push-Up", "Kneeling Incline Push-Up", "Kneeling Push-Up", "Machine Chest Fly", "Machine Chest Press", "Pec Deck", "Push-Up", "Push-Up Against Wall", "Push-Ups With Feet in Rings", "Resistance Band Chest Fly", "Smith Machine Bench Press", "Smith Machine Incline Bench Press", "Standing Cable Chest Fly", "Standing Resistance Band Chest Fly"]
        self.MasterListOfExercises["Shoulder Exercises"] = ["Band External Shoulder Rotation", "Band Internal Shoulder Rotation", "Band Pull-Apart", "Barbell Front Raise", "Barbell Rear Delt Row", "Barbell Upright Row", "Behind the Neck Press", "Cable Lateral Raise", "Cable Rear Delt Row", "Dumbbell Front Raise", "Dumbbell Horizontal Internal Shoulder Rotation", "Dumbbell Horizontal External Shoulder Rotation", "Dumbbell Lateral Raise", "Dumbbell Rear Delt Row", "Dumbbell Shoulder Press", "Face Pull", "Front Hold", "Lying Dumbbell External Shoulder Rotation", "Lying Dumbbell Internal Shoulder Rotation", "Machine Lateral Raise", "Machine Shoulder Press", "Monkey Row", "Overhead Press", "Plate Front Raise", "Power Jerk", "Push Press", "Reverse Dumbbell Flyes", "Reverse Machine Fly", "Seated Dumbbell Shoulder Press", "Seated Barbell Overhead Press", "Seated Smith Machine Shoulder Press", "Snatch Grip Behind the Neck Press", "Squat Jerk", "Split Jerk"]
        self.MasterListOfExercises["Bicep Exercises"] = ["Barbell Curl", "Barbell Preacher Curl", "Bodyweight Curl", "Cable Curl With Bar", "Cable Curl With Rope", "Concentration Curl", "Dumbbell Curl", "Dumbbell Preacher Curl", "Hammer Curl", "Incline Dumbbell Curl", "Machine Bicep Curl", "Spider Curl"]
        self.MasterListOfExercises["Triceps Exercises"] = [ "Barbell Standing Triceps Extension", "Barbell Lying Triceps Extension", "Bench Dip", "Close-Grip Push-Up", "Dumbbell Lying Triceps Extension", "Dumbbell Standing Triceps Extension", "Overhead Cable Triceps Extension", "Tricep Bodyweight Extension", "Tricep Pushdown With Bar", "Tricep Pushdown With Rope"]
        self.MasterListOfExercises["Leg Exercises"] = ["Air Squat", "Barbell Hack Squat", "Barbell Lunge", "Barbell Walking Lunge", "Belt Squat", "Body Weight Lunge", "Box Squat", "Bulgarian Split Squat", "Chair Squat", "Dumbbell Lunge", "Dumbbell Squat", "Front Squat", "Goblet Squat", "Hack Squat Machine", "Half Air Squat", "Hip Adduction Machine", "Landmine Hack Squat", "Landmine Squat", "Leg Extension", "Leg Press", "Lying Leg Curl", "Pause Squat", "Romanian Deadlift", "Safety Bar Squat", "Seated Leg Curl", "Shallow Body Weight Lunge", "Side Lunges (Bodyweight)", "Smith Machine Squat", "Squat", "Step Up"]
        self.MasterListOfExercises["Back Exercises"] = ["Back Extension", "Barbell Row", "Barbell Shrug", "Block Snatch", "Cable Close Grip Seated Row", "Cable Wide Grip Seated Row", "Chin-Up", "Clean", "Clean and Jerk", "Deadlift", "Deficit Deadlift", "Dumbbell Deadlift", "Dumbbell Row", "Dumbbell Shrug", "Floor Back Extension", "Good Morning", "Hang Clean", "Hang Power Clean", "Hang Power Snatch", "Hang Snatch", "Inverted Row", "Inverted Row with Underhand Grip", "Kettlebell Swing", "Lat Pulldown With Pronated Grip", "Lat Pulldown With Supinated Grip", "One-Handed Cable Row", "One-Handed Lat Pulldown", "Pause Deadlift", "Pendlay Row", "Power Clean", "Power Snatch", "Pull-Up", "Rack Pull", "Seal Row", "Seated Machine Row", "Snatch", "Snatch Grip Deadlift", "Stiff-Legged Deadlift", "Straight Arm Lat Pulldown", "Sumo Deadlift", "T-Bar Row", "Trap Bar Deadlift With High Handles", "Trap Bar Deadlift With Low Handles"]
        self.MasterListOfExercises["Glute Exercises"] = ["Banded Side Kicks", "Cable Pull Through", "Clamshells", "Dumbbell Romanian Deadlift", "Dumbbell Frog Pumps", "Fire Hydrants", "Frog Pumps", "Glute Bridge", "Hip Abduction Against Band", "Hip Abduction Machine", "Hip Thrust", "Hip Thrust Machine", "Hip Thrust With Band Around Knees", "Lateral Walk With Band", "Machine Glute Kickbacks", "One-Legged Glute Bridge", "One-Legged Hip Thrust", "Romanian Deadlift", "Single Leg Romanian Deadlift", "Standing Glute Kickback in Machine", "Step Up"]
        self.MasterListOfExercises["Ab Exercises"] = ["Cable Crunch", "Crunch", "Dead Bug", "Hanging Leg Raise", "Hanging Knee Raise", "Hanging Sit-Up", "High to Low Wood Chop with Band", "Horizontal Wood Chop with Band", "Kneeling Ab Wheel Roll-Out", "Kneeling Plank", "Kneeling Side Plank", "Lying Leg Raise", "Lying Windshield Wiper", "Lying Windshield Wiper with Bent Knees", "Machine Crunch", "Mountain Climbers", "Oblique Crunch", "Oblique Sit-Up", "Plank", "Side Plank", "Sit-Up"]
        self.MasterListOfExercises["Calves Exercises"] = ["Eccentric Heel Drop", "Heel Raise", "Seated Calf Raise", "Standing Calf Raise"]
        self.MasterListOfExercises["Forearm Flexors & Grip Exercises"] = ["Barbell Wrist Curl", "Barbell Wrist Curl Behind the Back", "Bar Hang", "Dumbbell Wrist Curl", "Farmers Walk", "Fat Bar Deadlift", "Gripper", "One-Handed Bar Hang", "Plate Pinch", "Plate Wrist Curl", "Towel Pull-Up"]
        self.MasterListOfExercises["Forearm Extensor Exercises"] = ["Barbell Wrist Extension", "Dumbbell Wrist Extension"]
    }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    /////////Resets the needed info for a new Workout
    /////////////////////////////////////////////////////////////////
    func ResetWorkout() {
        ExerciseGroupSelected = "All"
        ExerciseSelectionFinished = false
        ExercisesSelected = [:]
        ExercisesSelectedHeadings = []
    }
    
    
    
    /////////////////////////////////////////////////////////////////
    ////////Returns the number of Exercises Selected
    /////////////////////////////////////////////////////////////////
    func ExercisesReturnSetCount(ExerciseNameKey : String) -> Int {
        if ExercisesSelected[ExerciseNameKey] == nil { return 0
        } else { return ExercisesSelected[ExerciseNameKey]?["SetReps"]?.count ?? 0 }
    }
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Returns the array for Reps or Weights
    /////////////////////////////////////////////////////////////////
    func ExercisesReturnSetReps(ExerciseNameKey : String) -> [Int] {
        if ExercisesSelected[ExerciseNameKey] == nil { return []
        } else {return ExercisesSelected[ExerciseNameKey]?["SetReps"] ?? [] }
    }
    func ExercisesReturnSetWeight(ExerciseNameKey : String) -> [Int] {
        if ExercisesSelected[ExerciseNameKey] == nil { return []
        } else { return ExercisesSelected[ExerciseNameKey]?["SetWeight"] ?? [] }
    }
    func ExercisesReturnSets(ExerciseNameKey : String) -> Int {
        if ExercisesSelected[ExerciseNameKey] == nil { return 0
        } else { return ExercisesSelected[ExerciseNameKey]?["Sets"]?[0] ?? 0 }
    }
    func ExercisesReturnDisplaySets(ExerciseNameKey : String) -> Bool {
        if ExercisesSelected[ExerciseNameKey] == nil { return false
        } else {
            if ExercisesSelected[ExerciseNameKey]?["DisplaySets"]?[0] == 1 { return true } else { return false }
        }
    }
    
    
    /////////////////////////////////////////////////////////////////
    ////////Saves/Edits/Removes the Reps or Weights
    /////////////////////////////////////////////////////////////////
    func ExercisesSaveExerciseSelected (ExerciseNameKey : String) {
        ExercisesSelectedHeadings.append(ExerciseNameKey)
        ExercisesSelected[ExerciseNameKey] =  [ "SetReps" : [], "SetWeight" : [], "Sets" : [0], "DisplaySets" : [0] ]
    }
    func ExercisesSaveSetReps (ExerciseNameKey : String, Reps : [Int]) {
        ExercisesSelected[ExerciseNameKey]?["SetReps"] = Reps
    }
    func ExercisesSaveSetRepsAtIndex (ExerciseNameKey : String, Rep : Int, Index : Int) {
        ExercisesSelected[ExerciseNameKey]?["SetReps"]?[Index] = Rep
    }
    func ExercisesSaveSetWeight (ExerciseNameKey : String, Weights : [Int]) {
        ExercisesSelected[ExerciseNameKey]?["SetWeight"] = Weights
    }
    func ExercisesSaveSetWeightAtIndex (ExerciseNameKey : String, Weight: Int, Index : Int) {
        ExercisesSelected[ExerciseNameKey]?["SetWeight"]?[Index] = Weight
    }
    func ExercisesSaveSets (ExerciseNameKey : String, Sets : Int) {
        ExercisesSelected[ExerciseNameKey]?["Sets"] = [Sets]
    }
    func ExercisesSaveDisplaySets (ExerciseNameKey : String, Display : Bool) {
        //Stop Displaying all other rows
        for EX in 0..<ExercisesSelectedHeadings.count {
            ExercisesSelected[ExercisesSelectedHeadings[EX]]?["DisplaySets"] = [0]
        }
        //Only Display this row
        if Display == true { ExercisesSelected[ExerciseNameKey]?["DisplaySets"] = [1] }
    }
    func ExercisesRemoveExerciseSelected (ExerciseNameKey : String) {
        ExercisesSelected.removeValue(forKey: ExerciseNameKey)
        
        if ExercisesSelectedHeadings.contains(ExerciseNameKey) == true {
            for EX in 0..<ExercisesSelectedHeadings.count {
                if ExercisesSelectedHeadings[EX] == ExerciseNameKey {
                    ExercisesSelectedHeadings.remove(at: EX)
                    break
                }
            }
        }
    }
    
}
