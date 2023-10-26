//
//  NextViewController.swift
//  BLESetup
//
//  Created by Ben on 17/07/23.
//

import UIKit
import CoreBluetooth

class NextViewController: UIViewController, PicoBlueDelegate {
    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblServiceUuid: UILabel!
    @IBOutlet weak var lblCharUuid: UILabel!
    @IBOutlet weak var lblBattryInfo : UILabel!
    @IBOutlet weak var lblDataBytes: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var btnGetDataStream: UIButton!
    @IBOutlet weak var btnStopDataStream: UIButton!
    
    var batteryLevel = 0
    var isStreming = false
    var timer: Timer?
    
    
    // MARK: - Properties
    
    private var picoPeripheral: picoBluePeripheral!
    private var centralManager: CBCentralManager!
    
    // MARK: - Public API
    
    public func setPeripheral(_ peripheral: picoBluePeripheral) {
        picoPeripheral = peripheral
        
        title = peripheral.advertisedName
        peripheral.delegate = self
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblDeviceName.text = picoPeripheral.advertisedName?.capitalized
        self.lblCharUuid.text = "Characteristic UUID : \n \(ParticlePeripheral.TX_CHARACTERISTIC_UUID)"
        self.lblServiceUuid.text = "Service UUID : \n \(ParticlePeripheral.NUS_SERVICE_UUID)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.lblBattryInfo.text = "\(self.picoPeripheral.batteryPercentage)%"
        }
        
        guard !picoPeripheral.isConnected else {
            // everything is already setup
            self.lblStatus.text = "Connected"
            return
        }
        
        picoPeripheral.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // picoPeripheral.disconnect()
        timer?.invalidate()
        super.viewDidDisappear(animated)
    }
    
    @IBAction func btnBackAction( sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getDataStreamAction( sender: Any) {
        picoPeripheral.basePeripheral.setNotifyValue(true, for: picoPeripheral.characteristic)
        isStreming = true
        btnGetDataStream.isEnabled = false
        
      
    }
    @IBAction func StopDataStreamAction( sender: Any) {
       
        picoPeripheral.basePeripheral.setNotifyValue(false, for: picoPeripheral.characteristic)
        isStreming = false
        btnGetDataStream.isEnabled = true
    }
    
    
}

extension NextViewController {
    
    
    func picoDidConnect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            print("NextView Connecetd")
            self.lblStatus.text = "Connected"
            if self.isStreming{
                self.picoPeripheral.basePeripheral.setNotifyValue(true, for: self.picoPeripheral.characteristic)
            }
        }
    }
    
    func picoDidDisconnect() {
        DispatchQueue.main.async { [self] in
            print("NextViewDissconnected")
            self.lblStatus.text = "Not Connected"
            self.picoPeripheral.connect()
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.reconnectPeripheral), userInfo: nil, repeats: true)
            
        }
    }
    
    // Function to attempt reconnection to the peripheral
    @objc func reconnectPeripheral() {
        
        if !self.picoPeripheral.isConnected{
            // Attempt to reconnect to the peripheral
            picoPeripheral.connect()
        }else{
            self.timer?.invalidate()
        }
        
    }
    
    
    func updateDataRecive(Data : Data){
        
        let dataBytesSting = [UInt8](Data)
        
        // Extract battery level (byte 3)
        let batteryLevel = Int(dataBytesSting[3])
        let battery: Float = Float(batteryLevel)
        let batteryPercentage = ((battery - 182.0) / 27.0) * 100.0
        print("Battery Level: \(batteryLevel)")
        lblBattryInfo.text = "\(Int(batteryPercentage))%"
        self.batteryLevel = Int(batteryPercentage)
        
        let dataString = dataBytesSting.map { String($0) }.joined(separator: " ")
        print("Characteristic value: \(dataString)")
        lblDataBytes.text = "\(dataString)"
       
    }
   
}

