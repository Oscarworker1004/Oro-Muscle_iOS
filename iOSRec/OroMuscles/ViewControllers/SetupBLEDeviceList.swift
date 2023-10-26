//
//  SetupBLEDeviceList.swift
//  Previously called :
//  BLEMainViewController.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/5/23.
//
import UIKit
import CoreBluetooth

class SetupBLEDeviceList: UIViewController, CBCentralManagerDelegate {
    var SessionInfo : SessionInfo?
    var NavigationSelector : String?
    
    @IBOutlet weak var tblOfList: UITableView!
    @IBOutlet weak var btnOfScan: UIButton!
    
    let headerTitles = ["Connected Devices","Available Devices"]
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals = [picoBluePeripheral]()
    var ConnectedPeripherals = [CBPeripheral]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        discoveredPeripherals.removeAll()
        tblOfList.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centralManager.delegate = self
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.NUS_SERVICE_UUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager()
        tblOfList.backgroundColor = .black
        // Observing data
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil)
        
        //If there's a sensor that's already connected, add it to the connected list
        ConnectedPeripherals.removeAll()
        if self.SessionInfo?.currentDevice.picoPeripheral != nil {
            ConnectedPeripherals.append((self.SessionInfo?.currentDevice.picoPeripheral.basePeripheral)!)
        }
    }
    
    
    
    
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = picoBluePeripheral(withPeripheral: peripheral, advertisementData: advertisementData, andRSSI: RSSI, using: centralManager)
        
        if let name = peripheral.name{
            if name.contains("picoblue"){
                discoveredPeripherals.removeAll()
                centralManager.stopScan()
               // self.SessionInfo?.currentDevice.picoPeripheral = newPeripheral
                discoveredPeripherals.append(newPeripheral)
                tblOfList.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print(error!)
        }else{
            print(" disconnected without error in MainView")
        }
        ConnectedPeripherals.removeAll()
        tblOfList.reloadData()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Central is not powered on")
            ConnectedPeripherals.removeAll()
            discoveredPeripherals.removeAll()
            tblOfList.reloadData()
        } else {
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.NUS_SERVICE_UUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    
    @objc func handleDataNotification(_ notification: Notification) {
        if let data = notification.userInfo,
           let dataArray = data["dataArray"] {
            // Process the received array
            ConnectedPeripherals.removeAll()
            print("Received array data: \(dataArray)")
            ConnectedPeripherals = dataArray as! [CBPeripheral]
            if !ConnectedPeripherals.isEmpty{
                discoveredPeripherals.removeAll()
            }
            tblOfList.reloadData()
        }
        
        if ConnectedPeripherals.isEmpty && discoveredPeripherals.isEmpty{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.viewDidAppear(true)
            }
        }
    }
    
    
    @IBAction func backBTNPressed(_ sender: Any) {
        if self.SessionInfo?.QuickStart == true  && self.SessionInfo?.currentDevice.picoPeripheral == nil {
            self.NavigationSelector = "QuickStart"
        } else if self.SessionInfo?.QuickStart == true  {
            self.NavigationSelector = "DataAnalytics"
        } else { self.NavigationSelector = "SetupConnection" }
        self.performSegue(withIdentifier: "PN", sender: self)
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

//MARK: Table View

extension SetupBLEDeviceList : UITableViewDelegate,UITableViewDataSource {
    
    //This is strictly visuals for the headers of the tableview sections.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 155)
        let label = UILabel()
        label.text = headerTitles[section]
        label.frame = CGRect(x: 15, y: 5, width: 200, height: 25)
        label.textAlignment = .center
        label.textColor = UIColor(named: "AccentOrange") //UIColor(white: 40/100, alpha: 1.0)
        label.font = UIFont(name: "Galvji", size: 13)
        view.addSubview(label)
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return discoveredPeripherals.count
        }else {
            return ConnectedPeripherals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! SetupBLEDeviceListListCell
        
        if indexPath.section == 1 {
            let peripheral = discoveredPeripherals[indexPath.row]
            cell.lblOfDeviceName?.text = peripheral.advertisedName
            cell.lblOfMacAddress.text = "UUID : \(peripheral.basePeripheral.identifier)"
            cell.dissconnectBtn.isHidden = true
            cell.dissconnectBtn.addTarget(self, action: #selector(dissconnectBtnTapped(_:)), for: .touchUpInside)
        } else {
            let peripheral = ConnectedPeripherals[indexPath.row]
            cell.lblOfDeviceName?.text = peripheral.name
            cell.lblOfMacAddress.text = "UUID : \(peripheral.identifier)"
            cell.dissconnectBtn.isHidden = false
            cell.dissconnectBtn.addTarget(self, action: #selector(dissconnectBtnTapped(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let peripheral = discoveredPeripherals[indexPath.row]
            centralManager.stopScan()
            self.SessionInfo?.currentDevice.picoPeripheral = peripheral
            self.SessionInfo?.currentDevice.picoPeripheral.connect()
            //            picoPeripheral.connect()
            tableView.deselectRow(at: indexPath, animated: true)
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func dissconnectBtnTapped(_ sender: UIButton) {
        self.SessionInfo?.currentDevice.DisconnectSensor()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.viewDidAppear(true)
        }
    }
}
