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
    
    var databaseRef: DatabaseReference!
    var rooms: [Dictionary<String, AnyObject>]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UITableView
        roomsTableView.delegate = self
        roomsTableView.dataSource = self

        // ルーム情報取得
        databaseRef = Database.database().reference(withPath: "rooms")
        databaseRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let rooms = snapshot.value as? [String: NSDictionary] {
                for (roomId, roomInfo) in rooms {
                    roomInfo.setValue(roomId, forKey: "roomId")
                    self.rooms.append(roomInfo as! Dictionary<String, AnyObject>)
                }
            }
            
            self.roomsTableView.reloadData()
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
