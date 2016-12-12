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
    let db = DatabaseHelper()
    
    
    var posts = [Post]()
    
    // Initialise a global index variable so the prepareForSegue function can acces the cell index. 
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        // Do any additional setup after loading the view.
        let dataBaseref = FIRDatabase.database().reference()
        let dataId = dataBaseref.child("posts"); dataId.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            
           
            // Get the key of the parent node
            let ref = snapshot.ref
            let parentId = ref.key
         

            // Get all the values of child nodes.
            let value = snapshot.value as? NSDictionary
            let dataTitle = value!["title"] as! String
            let dataEmail = value!["email"] as! String
            let dataReserved = value!["reserved"] as! Bool
            
            // Initialise a 'Post' object and append it to the posts array.
            let postValue = Post(email: dataEmail, reserved: dataReserved, title: dataTitle)
            postValue.parent = parentId
            
            self.posts.insert(postValue, at: 0)
           
            self.Tableview.reloadData()
            
        })
        
        Tableview.allowsMultipleSelectionDuringEditing = true
    }
    
    // Enable editing of tablecells.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Enable deletion of cells by the user.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Update database.
        if editingStyle == .delete {
            db.delete(parentId: posts[indexPath.row].parent, index: indexPath.row, posts: &posts)
            tableView.reloadData()
            for item in posts {
                print(item.title)
            }
        }
    }
    
    // Segue to next view if the user touches a cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "nextView", sender: nil)
        
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: BookDetailViewController = segue.destination as! BookDetailViewController
        destination.segueTitle = posts[index].title
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         print ("ARRAY SIZE IS", posts.count )
         return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookWallTableViewCell
        
            cell.title.text = posts[indexPath.row].title
        
            cell.emailOfOwner.text = "From : "+posts[indexPath.row].email
        
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
                                   "reserved" : reserved,
                                   "title" : title]
        let dataBaseReference = FIRDatabase.database().reference()
        
        let postRef = dataBaseReference.child("posts").childByAutoId();postRef.setValue(post)
        
        let postId = postRef.key
        
        print("POSTID", postId)
        
        

    }
    
    func delete(parentId: String, index: Int) {
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("posts").child(parentId).removeValue()
        posts.remove(at: index)
        Tableview.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBook(_ sender: Any) {
        if addBookButton.isTouchInside {
            db.post(bookTitle: bookTitle.text!)
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
