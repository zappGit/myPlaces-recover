//
//  MyTableViewCell.swift
//  myPlaces
//
//  Created by Артем Хребтов on 17.05.2021.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    static let identifier = "Cell"
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = defaultContentConfiguration().updated(for: state)
        configuration.text = "hi"
        configuration.image =  UIImage(systemName: "bell")
        
        contentConfiguration = configuration
    }

}
