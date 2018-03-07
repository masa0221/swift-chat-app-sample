//
//  ViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/02/20.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet var mesasgesTextView: UITextView!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var postButton: UIButton!
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageViewLayoutConstant: NSLayoutConstraint!
    @IBAction func postButton(_ sender: Any) {
        postMessage()
    }
    
    var databaseRef: DatabaseReference!
    var roomInfo: Dictionary<String, AnyObject>!
    var messageViewDefaultHeight: CGFloat!
    var messageTextViewDefaultHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageViewDefaultHeight = messageView.frame.size.height
        messageTextViewDefaultHeight = messageTextView.frame.size.height
        
        messageTextView.delegate = self
        
        self.navigationItem.title = roomInfo["name"] as? String
        
        let roomId = roomInfo["roomId"] as! String
        databaseRef = Database.database().reference(withPath: "messages/\(roomId)")
        
        databaseRef.observe(DataEventType.childAdded) { (snapshot) -> Void in
            let messageDict = snapshot.value as? NSDictionary
            let name = messageDict?.value(forKey: "name") as! String
            let message = messageDict?.value(forKey: "message") as! String
            self.mesasgesTextView.text! += String(format: "%@: %@\n", name, message)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillBeShown),
                           name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardDidHidden),
                           name: .UIKeyboardDidHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        // キーボードの座標取得
        let rect: CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        // キーボードを表示するときのアニメーション時間を取得
        let duration: TimeInterval = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: duration) {
            let transform: CGAffineTransform = CGAffineTransform.init(translationX: 0, y: -rect.size.height)
            self.view.transform = transform
        }
    }
    
    @objc func keyboardDidHidden(notification: NSNotification) {
        // キーボードを表示するときのアニメーション時間を取得
        let duration: TimeInterval = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight = CGFloat(200.0)
        let size: CGSize = textView.sizeThatFits(textView.frame.size)
        
        // 最大値以上に拡大しない
        if size.height >= maxHeight {
            return
        }
        
        // 幅を広げる
        if size.height > textView.frame.size.height {
            messageViewLayoutConstant.constant += size.height - textView.frame.size.height
            textView.frame.size.height = size.height
        }
    }
    
    func postMessage() {
        let name: String = UserDefaults.standard.object(forKey: "name") as! String
        let message: String = messageTextView.text!
        let messages: NSDictionary = [
            "name": name,
            "message": message,
            ]
        // メッセージ情報を保存
        self.databaseRef
            .childByAutoId()
            .setValue(messages)
        
        messageTextView.text! = ""
        messageViewLayoutConstant.constant = messageViewDefaultHeight
        messageTextView.frame.size.height = messageTextViewDefaultHeight
        messageTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

