//
//  CustomCell.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/08.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol CustomCellDelegate{
    func tableView(tableView: UITableView, changeSwitchValue: Bool, indexPath:NSIndexPath!)
}


class CustomCell: UITableViewCell {
    
    var delegate: AnyObject!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
