//
//  SoundTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol SoundTableViewControllerDelegate : class {
    func changeSound(sound:String)
}

class SoundTableViewController: UITableViewController {
    @IBOutlet private weak var soundTable: UITableView!
    weak var delegate: SoundTableViewControllerDelegate?
    var sound = ""
    var soundStatuses = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.soundStatuses = PNDAlarmTableViewManager.soundStatus(sound)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers!
        if indexOfArray(viewControllers!, searchObject: self) == nil {
            self.delegate?.changeSound(sound)
        }
        super.viewWillDisappear(animated)
    }
    
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in enumerate(array) {
            if value as UIViewController == searchObject as UIViewController {
                return index
            }
        }
        return nil
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        switch indexPath.row {
        case 0:
            if self.soundStatuses == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        case 1:
            if self.soundStatuses == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        default:
            break
        }
        return cell
        // Configure the cell...
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.soundTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            if self.soundStatuses != 0 {
                self.sound = UILocalNotificationDefaultSoundName
                self.soundStatuses = 0
            }
        case 1:
            if self.soundStatuses != 1 {
                self.sound = "nil"
                self.soundStatuses = 1
            }
            default:
            break
        }
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.soundTable.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
