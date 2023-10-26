//
//  MuscleInfo.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class MuscleInfo : NSObject {
    ///Master List is currently hardcoded information,
    ///   - changing the name in this list will change the photo pulled from the assets folder
    var MasterListOfMuscles : [String : [String] ] = [:]
    var MasterListOfMusclesHeadings :[String] = []
    
    ///This is marking which muscle has been selected in the current Training Session
    var MuscleGroupSelected : String = ""
    var MuscleSelected : String = ""
    var MuscleSideSelected : String = ""
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    ////////////////////Master List setup on initialization
    /////////////////////////////////////////////////////////////////
    override init() {
        MasterListOfMusclesHeadings = ["Upper Leg", "Lower Leg", "Upper Body", "Arms","Back / Neck","Head"]
        MuscleGroupSelected = MasterListOfMusclesHeadings[0]
        
        MasterListOfMuscles["Upper Leg"] = ["Adductor Longus","Adductor Magnus", "Vastus Lateralis", "Vastus Medialis", "Rectus Femoris", "Tensor Fasciae Latae", "Gluteus Maximus", "Gluteus Medius", "Biceps Femoris- Long Head", "Biceps Femoris - Short Head", "Semimembranosus", "Semitendinosus"]
        MasterListOfMuscles["Lower Leg"] = ["Gastroocnemius Lateralis","Gastrocnemium Medialis", "Soleus", "Peroneus Brevis", "Peroneus Longus", "Tibialis Anterior"]
        MasterListOfMuscles["Upper Body"] = ["Deltoideus p. Acromialis (medius)","Deltoideus p. Clavicularis (anterior)", "Deltoideus p. Scapularis (posterior)", "Pectoralis Major", "Serratus Anterior" , "Internus / Transverse Abdominis", "Obliques Externus Abdominis", "Rectus Abdominis" ]
        MasterListOfMuscles["Arms"] = ["Biceps Brachii  - Long Head","Biceps Brachii - Short Head", "Brachialis", "Triceps Brachii Lateral Head", "Triceps Brachii Long Head", "Brachioradialis", "Flexor carpi Radialis", "Flexor carpi Ulnaris", "Interosseous (Abductor Pollicis Brevis", "Smaller Forearm Extensors"]
        MasterListOfMuscles["Back / Neck"] = ["Erector Spine - Iliocostalis","Erector Spinae - Longissimus", "Erector Spinae - Spinalis", "Infraspinatus", "Latissimus Dorsi", "Multifidus Lumbar Region", "Trapezius p. Descendenz", "Trapezius p. Ascendenz", "Trapezius p. Transversus", "Neck Extensors", "Sternocleidomastoid"]
        MasterListOfMuscles["Head"] = ["Frontalis","Masseter"]
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////
    /////////Resets the needed info for a new Workout
    /////////////////////////////////////////////////////////////////
    func ResetWorkout() {
        MuscleGroupSelected = MasterListOfMusclesHeadings[0]
        MuscleSelected = ""
        MuscleSideSelected = ""
    }
}
