import UIKit
import CoreBluetooth

class MainViewController: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet weak var tblOfList: UITableView!
    @IBOutlet weak var btnOfScan: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    // MARK: - Properties
    
    let headerTitles = ["Connecetd Devices","Available Devices"]
    
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals = [picoBluePeripheral]()
    private var picoPeripheral: picoBluePeripheral!
    var ConnectedPeripherals = [CBPeripheral]()
    
    // MARK: - UIViewController
    
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
        
        // Observing data
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name:Notification.Name("sendConnecetdPeripheralDetails"), object: nil)
    }
    
    
    
    @IBAction func btnNextAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NextViewController") as? NextViewController
        vc?.setPeripheral(picoPeripheral)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    
    
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = picoBluePeripheral(withPeripheral: peripheral, advertisementData: advertisementData, andRSSI: RSSI, using: centralManager)
        
        if let name = peripheral.name{
            if name.contains("picoblue"){
                discoveredPeripherals.removeAll()
                centralManager.stopScan()
                picoPeripheral = newPeripheral
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
            
            self.btnNext.isHidden = true
            
            tblOfList.reloadData()
        }
        
        if ConnectedPeripherals.isEmpty && discoveredPeripherals.isEmpty{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                
                self.viewDidAppear(true)
            }
        }
    }
}

//MARK: Table View

extension MainViewController : UITableViewDelegate,UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! listCell
        
        if indexPath.section == 1 {
            let peripheral = discoveredPeripherals[indexPath.row]
            cell.lblOfDeviceName?.text = peripheral.advertisedName
            cell.lblOfMacAddress.text = "UUID : \(peripheral.basePeripheral.identifier)"
            cell.dissconnectBtn.isHidden = true
            btnNext.isHidden = true
            cell.dissconnectBtn.addTarget(self, action: #selector(dissconnectBtnTapped(_:)), for: .touchUpInside)
            
        }else{
            
            let peripheral = ConnectedPeripherals[indexPath.row]
            cell.lblOfDeviceName?.text = peripheral.name
            cell.lblOfMacAddress.text = "UUID : \(peripheral.identifier)"
            cell.dissconnectBtn.isHidden = false
            btnNext.isHidden = false
            cell.dissconnectBtn.addTarget(self, action: #selector(dissconnectBtnTapped(_:)), for: .touchUpInside)
            
        }
        
        return cell
        
    }
    
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let peripheral = discoveredPeripherals[indexPath.row]
            
            centralManager.stopScan()
            picoPeripheral.connect()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }else{
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func dissconnectBtnTapped(_ sender: UIButton) {
        
        picoPeripheral.disconnect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            self.viewDidAppear(true)
        }
    }
    
}

