//
//  BookWallViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 07/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit
import Firebase

class BookWallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var Tableview: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: GET AL DATA FROM FIREBASE
        
        var ref: FIRDatabaseReference?
        ref = FIRDatabase.database().reference()
       
        print("---------------CHECKING USER------------------------")
        let user = FIRAuth.auth()?.currentUser
        let email = user?.email
        print("RESULT:", email!)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookWallTableViewCell
        
        // IF RESERVED IS TRUE ELSE .none
        cell.accessoryType = .checkmark
        
        return cell
    }
   
    
    func post(bookTitle: String) {
        
        let user = FIRAuth.auth()?.currentUser
        let title = bookTitle
        let reserved = false
        let email = user?.email
        
        let post: [String: Any] = ["email" : email,
                                   "reserved" : false,
                                   "title" : title]
        let dataBaseReference = FIRDatabase.database().reference()
        
        dataBaseReference.child("posts").childByAutoId().setValue(post)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBook(_ sender: Any) {
        if addBookButton.isTouchInside {
            post(bookTitle: bookTitle.text!)
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
