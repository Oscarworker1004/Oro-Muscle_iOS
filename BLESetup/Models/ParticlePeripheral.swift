//
//  ParticlePeripheral.swift
//  BLESetup
//
//  Created by apple on 04/07/23.
//

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {
    
    /// MARK: - services and charcteristics Identifiers
    
    public static let Device_UUID  = CBUUID.init(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    
    public static let NUS_SERVICE_UUID  = CBUUID.init(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    public static let CCC_DESCRIPTOR_UUID  = CBUUID.init(string: "00002902-0000-1000-8000-00805f9b34fb")
    public static let BATTERY_SERVICE_UUID = CBUUID.init(string: "0000180f-0000-1000-8000-00805f9b34fb")
    
    public static let TX_CHARACTERISTIC_UUID  = CBUUID.init(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    public static let RX_CHARACTERISTIC_UUID  = CBUUID.init(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    public static let BATTERY_LEVEL_CHAR_UUID = CBUUID.init(string: "2A19")
    
}
