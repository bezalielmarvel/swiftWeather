//
//  CustomCell.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 01/06/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
