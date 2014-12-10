//
//  RepeatViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/09.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var repeatTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repeatTable.delegate = self
        repeatTable.dataSource = self
        
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
        
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        switch texts[indexPath.row]{
            case "Sunday":
                break
            case "Monday":
                break
            case "Tuesday":
                break
            case "Wednesday":
                break
            case "Thursday":
                break
            case "Friday":
                break
            case "Saturday":
                break
            default:
                break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
