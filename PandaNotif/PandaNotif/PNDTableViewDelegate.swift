//
//  PNDTableViewDelegate.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/22.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//
/*
import UIKit

class PNDTableViewDelegate: NSObject,UITableViewDelegate {
    let vc = ViewController()
    let calculate = PNDAlarmCalculateClass()
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        if tableView.tag == 0{
            vc.minuteTableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch vc.texts[indexPath.row]{
            case "3分後":
                vc.minuteSet(.Minute,number:3,date: calculate.localDate())
            case "5分後":
                vc.minuteSet(.Minute,number:5,date: calculate.localDate())
            case "10分後":
                vc.minuteSet(.Minute,number:10,date: calculate.localDate())
            case "15分後":
                vc.minuteSet(.Minute,number:15,date: calculate.localDate())
            case "30分後":
                vc.minuteSet(.Minute,number:30,date: calculate.localDate())
            case "60分後":
                vc.minuteSet(.Minute,number:60,date: calculate.localDate())
            default:
                break
            }
        }else{
            vc.alarmTableView.deselectRowAtIndexPath(indexPath, animated: true)
            vc.editIndexPath = indexPath.row
            vc.performSegueWithIdentifier("toEditTableViewController",sender: nil)
        }
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if tableView.tag == 1{
            let delete = UITableViewRowAction(style: .Default,
                title: "delete"){(action, indexPath) in
                    self.vc.alarmTimes.removeAtIndex(indexPath.row)
                    self.vc.labels.removeAtIndex(indexPath.row)
                    self.vc.repeats.removeAtIndex(indexPath.row)
                    self.vc.sounds.removeAtIndex(indexPath.row)
                    self.vc.snoozes.removeAtIndex(indexPath.row)
                    self.vc.enabled.removeAtIndex(indexPath.row)
                    self.vc.alarmTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    println("\(indexPath) deleted")}
            delete.backgroundColor = UIColor.redColor()
            return [delete]
        }else{
            return nil
        }
    }
}
*/