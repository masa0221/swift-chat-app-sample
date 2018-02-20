//
//  ViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/02/20.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var mesasgesTextView: UITextView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        databaseRef = Database.database().reference()
        
        databaseRef.child("messages").observe(DataEventType.childAdded) { (snapshot) -> Void in
            let messageDict = snapshot.value as? NSDictionary
            let name = messageDict?.value(forKey: "name") as! String
            let message = messageDict?.value(forKey: "message") as! String
            self.mesasgesTextView.text! += String(format: "%@: %@\n", name, message)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        var name = ""
        if nameTextField.text == "" {
            name = nameTextField.placeholder!
        } else {
            name = nameTextField.text!
        }
        let message = messageTextField.text!
        messageTextField.text! = ""
        
        let messages = [
            "name": name,
            "message": message,
        ]
        
        // メッセージ情報を保存
        self.databaseRef
            .child("messages")
            .childByAutoId()
            .setValue(messages)
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

