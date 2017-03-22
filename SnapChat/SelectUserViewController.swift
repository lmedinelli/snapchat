//
//  SelectUserViewController.swift
//  SnapChat
//
//  Created by Luis Medinelli on 3/8/17.
//  Copyright © 2017 iBeacon Solutions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            //print(snapshot)
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]

            let user = User()
            user.email = postDict["email"] as! String
            //print("email : \(user.email)")
            //print("snap value : \(snapshot.key)")
            user.uid = snapshot.key
            
            self.users.append(user)
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let snap : [String: String] = ["from":user.email, "description" : "hello", "imageURL"
            : "url.com"]
        FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)    }

    

}
