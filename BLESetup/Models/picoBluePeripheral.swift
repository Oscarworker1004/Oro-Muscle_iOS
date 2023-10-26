//
//  picoBluePeripheral.swift
//  BLESetup
//
//  Created by Ben on 17/07/23.
//

import UIKit
import CoreBluetooth

protocol PicoBlueDelegate {
    
    func picoDidDisconnect()
    func picoDidConnect()
    func updateDataRecive(Data : Data)
    
}

class picoBluePeripheral: NSObject,CBPeripheralDelegate, CBCentralManagerDelegate{
    
    
    
    // MARK: - Properties
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var basePeripheral: CBPeripheral!
    var characteristic : CBCharacteristic!
    var batteryPercentage = 0
    
    
    public private(set) var advertisedName    : String?
    public private(set) var RSSI              : NSNumber = 0.0
    
    public var delegate: PicoBlueDelegate?
    
    public var ConnectedPeripherals = [CBPeripheral]()
    
    public var isConnected: Bool {
        return basePeripheral.state == .connected
    }
    
    
    
    init(withPeripheral peripheral: CBPeripheral, advertisementData advertisementDictionary: [String : Any], andRSSI currentRSSI: NSNumber, using manager: CBCentralManager) {
        centralManager = manager
        basePeripheral = peripheral
        RSSI = currentRSSI
        super.init()
        advertisedName = peripheral.name
        basePeripheral.delegate = self
    }
    
    /// Connects to the Pico device.
    public func connect() {
        centralManager.delegate = self
        print("Connecting to pico device...")
        centralManager.connect(basePeripheral, options: nil)
    }
    
    /// Cancels existing or pending connection.
    public func disconnect() {
        print("Cancelling connection...")
        centralManager.cancelPeripheralConnection(basePeripheral)
        ConnectedPeripherals.removeAll()
        NotificationCenter.default.post(name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil, userInfo: ["dataArray": ConnectedPeripherals])
    }
    
    
    // MARK: - Implementation
    
    ///  service discovery
    private func discoverPicoServices() {
        print("Discovering NUS_SERVICE_UUID service...")
        basePeripheral.delegate = self
        basePeripheral.discoverServices([ParticlePeripheral.NUS_SERVICE_UUID])
    }
    
    ///  characteristic discovery
    private func discoverCharacteristicsForPicoService(_ service: CBService) {
        print("Discovering TX_CHARACTERISTIC_UUID characteristrics...")
        basePeripheral.discoverCharacteristics(
            [ParticlePeripheral.TX_CHARACTERISTIC_UUID],
            for: service)
    }
    
    
    
    
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            ConnectedPeripherals.removeAll()
            print("Central Manager state changed to \(central.state)")
            NotificationCenter.default.post(name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil, userInfo: ["dataArray": ConnectedPeripherals])
            delegate?.picoDidDisconnect()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.basePeripheral {
            print("Connected to\(String(describing: peripheral.name))")
            discoverPicoServices()
            delegate?.picoDidConnect()
            ConnectedPeripherals.append(peripheral)
            
            // Sending an array of data
            
            NotificationCenter.default.post(name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil, userInfo: ["dataArray": ConnectedPeripherals])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if error != nil {
            print(error!)
            if peripheral == self.basePeripheral {
                print(" disconnected with error")
                delegate?.picoDidDisconnect()
            }
        }else{
            print(" disconnected without error")
        }
        ConnectedPeripherals.removeAll()
        
        // Sending an array of data
        NotificationCenter.default.post(name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil, userInfo: ["dataArray": ConnectedPeripherals])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        if peripheral == self.basePeripheral {
            print(" disconnected")
            delegate?.picoDidDisconnect()
        }
    }
    
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic.uuid.uuidString)
        
        if let value = characteristic.value {
            
            print(value)
            delegate?.updateDataRecive(Data: value)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Button notifications press")
        delegate?.picoDidConnect()
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.NUS_SERVICE_UUID {
                    print(" NUS_SERVICE_UUID service found")
                    //Capture and discover all characteristics
                    discoverCharacteristicsForPicoService(service)
                    return
                }
            }
        }
        // service has not been found
        delegate?.picoDidConnect()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.TX_CHARACTERISTIC_UUID {
                    print("TX_CHARACTERISTIC_UUID characteristic found")
                    self.characteristic = characteristic
                    if let data = characteristic.value {
                        
                        let dataBytesSting = [UInt8](data)
                        
                        // Extract battery level (byte 3)
                        let batteryLevel = Int(dataBytesSting[3])
                        let battery: Float = Float(batteryLevel)
                        let batteryPercentage = ((battery - 182.0) / 27.0) * 100.0
                        self.batteryPercentage = Int(batteryPercentage)
                        
                        print("Battery Level: \(batteryLevel)")
                        
                    }
                    
                }
            }
        }
        
        
    }
    
}




