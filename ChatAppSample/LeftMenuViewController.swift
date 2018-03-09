//
//  LeftMenuViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/03/08.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit
import Firebase

class LeftMenuViewController: UIViewController {
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            present(initialViewController!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel?.text = UserDefaults.standard.object(forKey: "name") as? String
        emailLabel?.text = UserDefaults.standard.object(forKey: "email") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
