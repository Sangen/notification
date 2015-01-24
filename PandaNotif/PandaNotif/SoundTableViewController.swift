//
//  SoundTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol SoundTableViewControllerDelegate : class{
    func changeSound(sound:String)
}

class SoundTableViewController: UITableViewController {
    @IBOutlet weak var soundTable: UITableView!
    weak var delegate: SoundTableViewControllerDelegate? = nil
    var soundStatuses = Int()
    var sound = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch sound {
        case UILocalNotificationDefaultSoundName:
            self.soundStatuses = Int(0)
        case "Alarm.m4r":
            self.soundStatuses = 1
        case "Ascending.m4r":
            self.soundStatuses = 2
        case "Bark.m4r":
            self.soundStatuses = 3
        case "Bell Tower.m4r":
            self.soundStatuses = 4
        case "Blues.m4r":
            self.soundStatuses = 5
        case "Boing.m4r":
            self.soundStatuses = 6
        case "Crickets.m4r":
            self.soundStatuses = 7
        case "Digital.m4r":
            self.soundStatuses = 8
        case "Doorbell.m4r":
            self.soundStatuses = 9
        case "Duck.m4r":
            self.soundStatuses = 10
        case "Harp.m4r":
            self.soundStatuses = 11
        case "Motorcycle.m4r":
            self.soundStatuses = 12
        case "Old Car Horn.m4r":
            self.soundStatuses = 13
        case "Old Phone.m4r":
            self.soundStatuses = 14
        case "Piano Riff.m4r":
            self.soundStatuses = 15
        case "Pinball.m4r":
            self.soundStatuses = 16
        case "Robot.m4r":
            self.soundStatuses = 17
        case "Sci-Fi.m4r":
            self.soundStatuses = 18
        case "Sonar.m4r":
            self.soundStatuses = 19
        case "Strum.m4r":
            self.soundStatuses = 20
        case "Timba.m4r":
            self.soundStatuses = 21
        case "Time Passing.m4r":
            self.soundStatuses = 22
        case "Trill.m4r":
            self.soundStatuses = 23
        case "Xylophone.m4r":
            self.soundStatuses = 24
        case "nil":
            self.soundStatuses = 25
        default:
            break
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 25
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if self.soundStatuses == 0 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 1:
                if self.soundStatuses == 1 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 2:
                if self.soundStatuses == 2 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 3:
                if self.soundStatuses == 3 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 4:
                if self.soundStatuses == 4 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 5:
                if self.soundStatuses == 5 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 6:
                if self.soundStatuses == 6 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 7:
                if self.soundStatuses == 7 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 8:
                if self.soundStatuses == 8 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 9:
                if self.soundStatuses == 9 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 10:
                if self.soundStatuses == 10 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 11:
                if self.soundStatuses == 11 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 12:
                if self.soundStatuses == 12 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 13:
                if self.soundStatuses == 13 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 14:
                if self.soundStatuses == 14 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 15:
                if self.soundStatuses == 15 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 16:
                if self.soundStatuses == 16 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 17:
                if self.soundStatuses == 17 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 18:
                if self.soundStatuses == 18 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 19:
                if self.soundStatuses == 19 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 20:
                if self.soundStatuses == 20 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 21:
                if self.soundStatuses == 21 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 22:
                if self.soundStatuses == 22 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 23:
                if self.soundStatuses == 23 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 24:
                if self.soundStatuses == 24 {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            default:
                break
            }
        }else{
            if self.soundStatuses == 25 {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
        // Configure the cell...
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.soundTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if self.soundStatuses != 0 {
                    self.sound = UILocalNotificationDefaultSoundName
                    self.soundStatuses = Int(0)
                }
            case 1:
                if self.soundStatuses != 1 {
                    self.sound = "Alarm.m4r"
                    self.soundStatuses = 1
                }
            case 2:
                if self.soundStatuses != 2 {
                    self.sound = "Ascending.m4r"
                    self.soundStatuses = 2
            }
            case 3:
                if self.soundStatuses != 3 {
                    self.sound = "Bark.m4r"
                    self.soundStatuses = 3
            }
            case 4:
                if self.soundStatuses != 4 {
                    self.sound = "Bell Tower.m4r"
                    self.soundStatuses = 4
                }
            case 5:
                if self.soundStatuses != 5 {
                    self.sound = "Blues.m4r"
                    self.soundStatuses = 5
                }
            case 6:
                if self.soundStatuses != 6 {
                    self.sound = "Boing.m4r"
                    self.soundStatuses = 6
                }
            case 7:
                if self.soundStatuses != 7 {
                    self.sound = "Crickets.m4r"
                    self.soundStatuses = 7
                }
            case 8:
                if self.soundStatuses != 8 {
                    self.sound = "Digital.m4r"
                    self.soundStatuses = 8
                }
            case 9:
                if self.soundStatuses != 9 {
                    self.sound = "Doorbell.m4r"
                    self.soundStatuses = 9
                }
            case 10:
                if self.soundStatuses != 10 {
                    self.sound = "Duck.m4r"
                    self.soundStatuses = 10
                }
            case 11:
                if self.soundStatuses != 11 {
                    self.sound = "Harp.m4r"
                    self.soundStatuses = 11
                }
            case 12:
                if self.soundStatuses != 12 {
                    self.sound = "Motorcycle.m4r"
                    self.soundStatuses = 12
                }
            case 13:
                if self.soundStatuses != 13 {
                    self.sound = "Old Car Horn.m4r"
                    self.soundStatuses = 13
                }
            case 14:
                if self.soundStatuses != 14 {
                    self.sound = "Old Phone.m4r"
                    self.soundStatuses = 14
                }
            case 15:
                if self.soundStatuses != 15 {
                    self.sound = "Piano Riff.m4r"
                    self.soundStatuses = 15
                }
            case 16:
                if self.soundStatuses != 16 {
                    self.sound = "Pinball.m4r"
                    self.soundStatuses = 16
                }
            case 17:
                if self.soundStatuses != 17 {
                    self.sound = "Robot.m4r"
                    self.soundStatuses = 17
                }
            case 18:
                if self.soundStatuses != 18 {
                    self.sound = "Sci-Fi.m4r"
                    self.soundStatuses = 18
                }
            case 19:
                if self.soundStatuses != 19 {
                    self.sound = "Sonar.m4r"
                    self.soundStatuses = 19
                }
            case 20:
                if self.soundStatuses != 20 {
                    self.sound = "Strum.m4r"
                    self.soundStatuses = 20
                }
            case 21:
                if self.soundStatuses != 21 {
                    self.sound = "Timba.m4r"
                    self.soundStatuses = 21
                }
            case 22:
                if self.soundStatuses != 22 {
                    self.sound = "Time Passing.m4r"
                    self.soundStatuses = 22
                }
            case 23:
                if self.soundStatuses != 23 {
                    self.sound = "Trill.m4r"
                    self.soundStatuses = 23
                }
            case 24:
                if self.soundStatuses != 24 {
                    self.sound = "Xylophone.m4r"
                    self.soundStatuses = 24
                }
            default:
                break
            }
        }else{
            if self.soundStatuses != 25 {
                self.sound = "nil"
                self.soundStatuses = 25
            }
        }
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.soundTable.reloadData()
        })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
