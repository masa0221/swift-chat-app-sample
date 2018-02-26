//
//  RoomsViewController.swift
//  ChatAppSample
//
//  Created by Masashi Tsuru on 2018/02/22.
//  Copyright © 2018年 Masashi Tsuru. All rights reserved.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var roomsTableView: UITableView!
    @IBAction func createRoomButton(_ sender: Any) {
        displayCreateRoomAlert()
    }
    
    var refreshControl: UIRefreshControl!
    var databaseRef: DatabaseReference!
    var rooms: [Dictionary<String, AnyObject>]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UITableView
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(self.refresh),
            for: UIControlEvents.valueChanged
        )
        roomsTableView.addSubview(refreshControl)

        databaseRef = Database.database().reference(withPath: "rooms")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refresh()
    }
    
    @objc func refresh() {
        // ルーム情報取得
        databaseRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            self.rooms.removeAll()
            if let rooms = snapshot.value as? [String: NSDictionary] {
                for (roomId, roomInfo) in rooms {
                    roomInfo.setValue(roomId, forKey: "roomId")
                    self.rooms.append(roomInfo as! Dictionary<String, AnyObject>)
                }
            }
            
            self.roomsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room["name"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toRoom", sender: rooms[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoom" {
            let roomViewController: ViewController = segue.destination as! ViewController
            roomViewController.roomInfo = sender as! Dictionary<String, AnyObject>
        }
    }
    
    func displayCreateRoomAlert() {
        let alert: UIAlertController = UIAlertController(
            title: "Create chat room",
            message: "What name for new chat room?",
            preferredStyle: UIAlertControllerStyle.alert
        )
        let okAction: UIAlertAction = UIAlertAction(
            title: "Create",
            style: UIAlertActionStyle.default,
            handler: { (action) in
                let textFields: Array<UITextField>? = alert.textFields
                if textFields != nil {
                    for textField: UITextField in textFields! {
                        let roomName = textField.text! as String
                        if !roomName.isEmpty {
                            self.createRoom(roomName: roomName)
                        }
                    }
                }
            }
        )
        
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: nil
        )
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Chat room name"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func createRoom(roomName: String) {
        var roomInfo = [
            "name": roomName,
        ];
        
        // データを作成
        let roomId = databaseRef.childByAutoId().key
        databaseRef
            .child(roomId)
            .setValue(roomInfo)
        
        // 画面遷移
        roomInfo.updateValue(roomId, forKey: "roomId")
        self.performSegue(withIdentifier: "toRoom", sender: roomInfo)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
