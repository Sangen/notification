//
//  LabelViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/16.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var myTextField: UITextField!
    var label : String = ""
    var getLabel : AnyObject = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label = self.getLabel as String

        myTextField.text = self.label
        myTextField.delegate = self
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldDidBeginEditing(textField: UITextField){
      //  println("textFieldDidBeginEditing:" + textField.text)
    }
 
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        if textField.text == ""{
            myUserDafault.setObject("アラーム", forKey: "NewLabel")
        }else{
            myUserDafault.setObject(textField.text, forKey: "NewLabel")
        }
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

