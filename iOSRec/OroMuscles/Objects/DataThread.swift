//
//  DataThread.swift
//  OroMuscles
//
//  Created by Siver Solutions LLC on 10/6/23.
//

import Foundation
import OSLog


class DataThread : NSObject {
    var m_busy : Bool = false
    var m_run : Bool = false
    var m_newData : Bool = false
    var m_threadComplete = false
    var m_data : [UInt8]?
    var SessionInfo : SessionInfo?
    var incomingDataArray : [Double]?
    var FrameCountResults : Int32 = 0
    var GetFramesResult = UnsafeMutablePointer<Double>.allocate(capacity: 0)

    let log = OSLog(subsystem: "com.OnTrackApps.OroMusclesd", category: "PRECE-DEBUG")

    
    
    func processBLE(Data: Data)
    {
        wait()
        
        m_busy = true
        if (m_data == nil || m_data?.count != Data.count + 4)
        {
            m_data = [UInt8](repeating: 0, count: Data.count + 4);
            m_data?[0] = 127
            m_data?[1] = 127
            m_data?[2] = 127
            m_data?[3] = 127
        }
        
        for i in 0..<Data.count {
            m_data?[i+4] = Data[i]
        }
        
        m_busy = false
        m_newData = true
    }
    
    
    private func wait() {
        while m_busy {
            do {
                try Thread.sleep(forTimeInterval: 0.001)
            } catch {
                print("error trying to get the thread to wait")
            }
        }
    }
    
    func stopBLE() {
        m_run = false
        
        os_log("It is hitting the start StopBLE function", log: log, type: .debug)
        
    }
    
    func startBLE() {
        m_run = true
        GetFramesResult.initialize(to: 0.0)
        startUpdateThread()
    }
    
    func startUpdateThread() {
        
        DispatchQueue.global(qos: .background).async { [self] in
            // self.SessionInfo?.currentRecording.appendDataPacket(Data: Data)
            
            // Log a message with a specific log level
            //os_log("It is hitting the start Update Thread function or the background thread", log: log, type: .debug)
            
            let ct : CTop_Wrapper = CTop_Wrapper()
            
            while m_run {
                if m_newData {
                    //Process Data Here ===================
                    
                    m_newData = false
                    wait()
                    m_busy = true
                    
                    //Copy the contents of the data stream into the local uint8 array to set up for further processing.
                    var CometaSignatureDataByString = [UInt8]()
                    for dataString in m_data! {
                        CometaSignatureDataByString.append(dataString)
                    }
                    
                    m_busy = false
                    
                    //TODO READ 7) The incoming data packet w/signature gets a space allocation and sent in the FeedData method (Manfred created all the C files in the Data Decipher folder).
                    let ptr2 = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: CometaSignatureDataByString.count)
                    ptr2.initialize(repeating: 1, count: CometaSignatureDataByString.count)
                    for n in 0..<CometaSignatureDataByString.count {
                        ptr2[n] = CUnsignedChar(CometaSignatureDataByString[n])
                    }
                    
                    let arrayString = self.arrayToString(CometaSignatureDataByString)
                    os_log("Data stream value prior to hitting the C function: %@", log: log, type: .debug, arrayString)
                    
                    ct.ctopWtopFeedData(ptr2, Int32(CometaSignatureDataByString.count))
                    
                    //TODO READ 8) The data stuffed in gets pulled back out with the GetFrames method.
                    //TODO READ 8.1) Problem : After ~0.7 seconds, the GetFrames method stops reliably returning information
                    let OUTSIZE : Int = 300
                    GetFramesResult = UnsafeMutablePointer<Double>.allocate(capacity: OUTSIZE)
                    GetFramesResult.initialize(repeating: 1, count: OUTSIZE)
                    FrameCountResults = ct.ctopWtopGetFrames(GetFramesResult, Int32(OUTSIZE), 15)
                    
                    
                    os_log("The FrameCount Results from calling the getFrames method: %d", log: log, type: .debug, FrameCountResults)
                    
                }//end if statement
            }//end while statement
        }//end function
    }
    
    
    // Function to convert array to string
    func arrayToString<T>(_ array: [T]) -> String {
        return array.map { String(describing: $0) }.joined(separator: ", ")
    }
    
}
