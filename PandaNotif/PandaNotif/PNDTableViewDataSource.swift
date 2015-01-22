//
//  PNDTableViewDataSource.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/22.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class PNDTableViewDataSource: NSObject, UITableViewDataSource{
    let vc = ViewController()
    var tableView = UITableView()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 0{
            return vc.texts.count
        }else{
            return vc.alarmTimes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
            cell.textLabel?.text = vc.texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
            let customCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomCell
            //customCell.delegate = self
            if vc.enabled[indexPath.row] == true{
                customCell.enabledSwitch.on = true
                customCell.repeatLabel.enabled = true
                customCell.snoozeLabel.enabled = true
                customCell.timeLabel?.textColor = UIColor.blackColor()
                customCell.descriptionLabel?.textColor = UIColor.blackColor()
            }else{
                customCell.enabledSwitch.on = false
                customCell.repeatLabel.enabled = false
                customCell.snoozeLabel.enabled = false
                customCell.timeLabel?.textColor = UIColor.grayColor()
                customCell.descriptionLabel?.textColor = UIColor.grayColor()
            }
            
            if vc.repeats[indexPath.row] != "0000000"{
                customCell.repeatLabel.alpha = 1.0
            }else{
                customCell.repeatLabel.alpha = 0
            }
            
            if vc.snoozes[indexPath.row] == true{
                customCell.snoozeLabel.alpha = 1.0
            }else{
                customCell.snoozeLabel.alpha = 0
            }
            customCell.timeLabel?.text = vc.alarmTimes[indexPath.row]
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = vc.labels[indexPath.row]
            customCell.enabledSwitch.addTarget(vc, action: "onClickEnabledSwicth:", forControlEvents: .ValueChanged)
            customCell.setNeedsLayout()
            customCell.layoutIfNeeded()
            
            return customCell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.tag == 1{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.tag == 1{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1{
            switch editingStyle {
            case .Delete:
                vc.alarmTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            default:
                return
            }
        }
    }
}
