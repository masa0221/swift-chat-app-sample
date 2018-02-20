//
//  ViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/02/20.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var mesasgesTextView: UITextView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        var name = ""
        if nameTextField.text == "" {
            name = nameTextField.placeholder!
        } else {
            name = nameTextField.text!
        }
        mesasgesTextView.text! += String(format: "%@: %@\n", name, messageTextField.text!)
        messageTextField.text! = ""
            
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

