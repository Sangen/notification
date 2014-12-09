//
//  AddViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/09.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testTable.dataSource = self
        self.testTable.delegate = self
        self.testTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.testTable.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }
    
    let texts = ["Repeat", "Label", "Snooze"]
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        switch texts[indexPath.row]{
        case "Repeat":
            break
        case "Label":
            break
        case "Snooze":
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
    }
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
