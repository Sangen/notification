//
//  RepeatTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol RepeatTableViewControllerDelegate : class{
    func changeRepeat(repeat:String)
}

class RepeatTableViewController: UITableViewController {
    weak var delegate: RepeatTableViewControllerDelegate? = nil
    @IBOutlet weak var repeatTable: UITableView!
    var repeat = String()
    var repeatStatuses = [String]()
    let texts = ["毎日曜日","毎月曜日","毎火曜日","毎水曜日","毎木曜日","毎金曜日","毎土曜日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for r in repeat { self.repeatStatuses.append(String(r)) }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers!
        if indexOfArray(viewControllers!, searchObject: self) == nil {
            self.repeat = ""
            for r in repeatStatuses { self.repeat = self.repeat + r }
            self.delegate?.changeRepeat(repeat)
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.texts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.textLabel?.text = self.texts[indexPath.row]
        
        if self.repeatStatuses[indexPath.row] == "1" {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        self.repeatTable.deselectRowAtIndexPath(indexPath, animated: true)

        switch indexPath.row {
            case 0:
                if self.repeatStatuses[0] == "0" {
                    self.repeatStatuses[0] = "1"
                }else{
                    self.repeatStatuses[0] = "0"
                }
            case 1:
                if self.repeatStatuses[1] == "0" {
                    self.repeatStatuses[1] = "1"
                }else{
                    self.repeatStatuses[1] = "0"
                }
            case 2:
                if self.repeatStatuses[2] == "0" {
                    self.repeatStatuses[2] = "1"
                }else{
                    self.repeatStatuses[2] = "0"
                }
            case 3:
                if self.repeatStatuses[3] == "0" {
                    self.repeatStatuses[3] = "1"
                }else{
                    self.repeatStatuses[3] = "0"
                }
            case 4:
                if self.repeatStatuses[4] == "0" {
                    self.repeatStatuses[4] = "1"
                }else{
                    self.repeatStatuses[4] = "0"
                }
            case 5:
                if self.repeatStatuses[5] == "0" {
                    self.repeatStatuses[5] = "1"
                }else{
                    self.repeatStatuses[5] = "0"
                }
            case 6:
                if self.repeatStatuses[6] == "0" {
                    self.repeatStatuses[6] = "1"
                }else{
                    self.repeatStatuses[6] = "0"
                }
            default:
                break
        }
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.repeatTable.reloadData()
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
