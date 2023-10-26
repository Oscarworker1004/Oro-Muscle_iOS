//
//  Device.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/7/23.
//

import UIKit
import CoreBluetooth

class Device: NSObject {
    var isStreming : Bool?
    var timer: Timer?
    
    var picoPeripheral: picoBluePeripheral!
    var centralManager: CBCentralManager!
    
    var dataStreamToggle : Bool = false
    var StreamingData : Data?
    
    
    override init() {
        isStreming = false
        dataStreamToggle = false
    }
    
    func getCharacteristicUUID() -> String {
        return "\(ParticlePeripheral.TX_CHARACTERISTIC_UUID)"
    }
    func getServiceUUID() -> String {
        return "\(ParticlePeripheral.NUS_SERVICE_UUID)"
    }
    func getBatteryLife() -> String {
        return "\(picoPeripheral.batteryPercentage)%"
    }
    func getConnection() -> String {
        if picoPeripheral != nil {
            guard !picoPeripheral.isConnected else {
                return "Connected"
            }
            return "Not Found"
        } else {
            return "Not Found"
        }
    }
    
    
    func DisconnectSensor() {
        picoPeripheral.disconnect()
        picoPeripheral =  nil
    }
    
    /////Data Stream Start / Stop
    func DataStreamToggle() {
        //TODO READ 2) The data stream is toggled here
        dataStreamToggle = !dataStreamToggle
        if dataStreamToggle == true {
            picoPeripheral.dataThread.startBLE()
            picoPeripheral.basePeripheral.setNotifyValue(true, for: picoPeripheral.characteristic)
            isStreming = true
        } else {
            picoPeripheral.dataThread.stopBLE()
            picoPeripheral.basePeripheral.setNotifyValue(false, for: picoPeripheral.characteristic)
            isStreming = false
        }
    }
}
