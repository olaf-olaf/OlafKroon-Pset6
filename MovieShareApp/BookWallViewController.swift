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
    var postsSize = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: GET AL DATA FROM FIREBASE
        
//        var ref: FIRDatabaseReference?
//        ref = FIRDatabase.database().reference()
//       
//        print("---------------CHECKING USER------------------------")
//        let user = FIRAuth.auth()?.currentUser
//        let email = user?.email
//        print("RESULT:", email!)

        // Do any additional setup after loading the view.
        let dataBaseref = FIRDatabase.database().reference()
        let dataId = dataBaseref.child("posts"); dataId.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            
           
            var ref = snapshot.ref
            //KEY OF PARENT
            var id = ref.key
            print("SNAPSHOT")
            print("KYSqmhvfmqVeRus4V8m")
            print("KEY", id)

            
            let value = snapshot.value as? NSDictionary
            
            for (key, value) in value! {
                print("\(key) -> \(value)")
                print("THIS IS THE KEY", key)
            }
            
            
            
            //let array = Array(value?.allValues)
            //let id = value![""] as! String
            //print("ID",id)
            let dataTitle = value!["title"] as! String
            let dataEmail = value!["email"] as! String
            let dataReserved = value!["reserved"] as! Bool
            
            let postValue = Post(email: dataEmail, reserved: dataReserved, title: dataTitle)
            
            self.posts.insert(postValue, at: 0)
            
            print("ARRAY SIZE", self.posts.count)
            self.postsSize = self.posts.count
            
            for element in self.posts {
                print("EMAIL", element.email)
            }
            self.Tableview.reloadData()
            
        })
        
        Tableview.allowsMultipleSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        print("DELETE")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         print ("ARRAY SIZE IS", posts.count )
         return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookWallTableViewCell
        
            cell.title.text = posts[indexPath.row].title
        
            cell.emailOfOwner.text = posts[indexPath.row].email
        
            if posts[indexPath.row].reserved == true {
        
                    cell.accessoryType = .checkmark
            } else {
        
                    cell.accessoryType = .none
        
            }
        
        
        
        return cell
    }
   
    
    // DATABASE FUNCTIONS
    
    
    func post(bookTitle: String) {
        
        let user = FIRAuth.auth()?.currentUser
        let title = bookTitle
        let reserved = false
        let email = user?.email
        
        let post: [String: Any] = ["email" : email,
                                   "reserved" : false,
                                   "title" : title]
        let dataBaseReference = FIRDatabase.database().reference()
        
        let postRef = dataBaseReference.child("posts").childByAutoId();postRef.setValue(post)
        
        let postId = postRef.key
        
        print("POSTID", postId)
        
        

    }
    
    
//    func delete(user: String, title: String, rowid: Int) {
//        
//        let dataBaseref = FIRDatabase.database().reference()
//        var ref: FIRDatabaseReference?
//        ref = FIRDatabase.database().reference()
//        let userCheck = FIRAuth.auth()?.currentUser
//        let emailCheck = userCheck?.email
//        
//        if user == emailCheck {
//            
//        }
//        dataBaseref.child("posts").child(<#T##pathString: String##String#>)
//        
//        
//        
//    }
    
    

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
