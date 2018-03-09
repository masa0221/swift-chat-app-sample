//
//  LoginViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/02/27.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import SlideMenuControllerSwift

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet var googleSignInButton: GIDSignInButton!
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateInitialViewController()
            let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenu")
            let initialViewController = SlideMenuController(mainViewController: mainViewController!, leftMenuViewController: leftMenuViewController)

            present(initialViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
