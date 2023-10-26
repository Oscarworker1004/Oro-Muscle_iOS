//
//  SetupBLEDeviceListListCell.swift
//  Previously called :
//  BLEListCell.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 8/5/23.
//

import UIKit

class SetupBLEDeviceListListCell: UITableViewCell {

        @IBOutlet weak var lblOfDeviceName: UILabel!
        @IBOutlet weak var lblOfMacAddress: UILabel!
        
        @IBOutlet weak var dissconnectBtn: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
