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
    var repeatStatuses = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repeatStatuses = Array(self.repeat)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers!
        if indexOfArray(viewControllers!, searchObject: self) == nil {
            self.repeat = self.repeatStatuses.reduce("", combine: { $0 + String($1) })
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if self.repeatStatuses[indexPath.row] == "1" {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.repeatTable.deselectRowAtIndexPath(indexPath, animated: true)

        self.repeatStatuses[indexPath.row] = (self.repeatStatuses[indexPath.row] == "0" ? "1" : "0")
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.repeatTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}