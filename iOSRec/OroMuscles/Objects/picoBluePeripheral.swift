//
//  picoBluePeripheral.swift
//  BLESetup
//
//  Created by Ben on 17/07/23.
//

import UIKit
import CoreBluetooth
import os.log

protocol PicoBlueDelegate {
    
    func picoDidDisconnect()
    func picoDidConnect()
    func updateDataRecive(Data : Data)
    
}


class picoBluePeripheral: NSObject,CBPeripheralDelegate, CBCentralManagerDelegate{
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var basePeripheral: CBPeripheral!
    var characteristic : CBCharacteristic!
    var dataThread : DataThread!
    var batteryPercentage = 0
    var DataPacketSkipNumber :Int = 0
    // Create a log object for your specific category
    let log = OSLog(subsystem: "com.OnTrackApps.OroMusclesd", category: "PRECE-DEBUG")
    var numFirstZero = 0
    var correctFirstBit = 0
    var correctSecondBit = 0
    var correctThirdBit = 0
    
    
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
        dataThread = DataThread()
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
    
    // Function to convert array to string
    func arrayToString<T>(_ array: [T]) -> String {
        return array.map { String(describing: $0) }.joined(separator: ", ")
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //TODO READ 3) The data packet from the cometa device comes in here
        if let value = characteristic.value {
                var dataBytesSting = [UInt8](value)
                
                if(correctThirdBit > 0)
                {
                    dataBytesSting[2] = UInt8(correctThirdBit)
                }
            
                if(correctThirdBit > 255)
                {
                        correctFirstBit = 0
                        correctSecondBit = 0
                        correctThirdBit = 0
                }
            
                //If the first bit in the datastream is not equal to the number it is supposed to be, that means that the datastream reset itself and we need to chage the number to be the correct value in the datastream
               // if (correctFirstBit != dataBytesSting[0]) {
                    if(correctFirstBit > 255) {
                        correctFirstBit = 0
                        dataBytesSting[0] = UInt8(correctFirstBit)
                        correctSecondBit = correctSecondBit + 1
                        if(correctSecondBit <= 255)
                        {
                            dataBytesSting[1]  = UInt8(correctSecondBit)
                        }
                    }
                    else
                    {
                        dataBytesSting[0] = UInt8(correctFirstBit)
                        dataBytesSting[1] = UInt8(correctSecondBit)
                    }
                //}
            
                if(correctSecondBit > 255)
                {
                    correctSecondBit = 0
                    correctThirdBit = correctThirdBit + 1
                    dataBytesSting[2] = UInt8(correctThirdBit)
                }
            
            
            
                //PUT IN A LOG STATEMENT HERE PRINTING OUT THE VALUES OF THE ARRAY PRIOR TO HITTING THE C FUNCTION
                //let arrayString = self.arrayToString(dataBytesSting)
               // os_log("Intial data stream values: %@", log: log, type: .debug, arrayString)

            
            
                //Put in a log statement here printing out the data values this is equivalent to the processBLE method in Android (well more like equivalent to "On Characteristic changed" function in Android/Bluetooth library
                // Extract battery level (byte 3)
                let batteryLevel = Int(dataBytesSting[3])
                let battery: Float = Float(batteryLevel)
                batteryPercentage = Int( ((battery - 182.0) / 27.0) * 100.0 )
                //TODO READ 4) This gives the data packet to individual view controllers
            
                let dataBytes = Data(dataBytesSting)
            
                dataThread.processBLE(Data: dataBytes)
                correctFirstBit = correctFirstBit + 1
                delegate?.updateDataRecive(Data: dataBytes)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
       // print("Button notifications press")
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
                        
                        print("Battery Percentage: \(batteryPercentage)%")
                    }
                }
            }
        }
    }
}
