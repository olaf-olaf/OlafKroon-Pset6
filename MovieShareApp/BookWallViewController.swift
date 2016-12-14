//
//  BookWallViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 07/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell


class BookWallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var Tableview: UITableView!
    let db = DatabaseHelper()
    
    // An array of Post objects to store the retrieved data in.
    var posts = [Post]()
    
    // Initialise a global index variable so the prepareForSegue function can acces the cell index. 
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When the view is initialised or when something is added to the database reload all data
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
        }
    }
    
    // Segue to next view if the user touches a cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "nextView", sender: nil)
        
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextView" {
            let destination: BookDetailViewController = segue.destination as! BookDetailViewController
            destination.segueTitle = posts[index].title
        } else if segue.identifier == "previousView" {
            
            let destination: ViewController = segue.destination as! ViewController
            
        }
    }

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return self.posts.count
    }
    
    // Populate each cell with data from the Posts array.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookWallTableViewCell
        if cell == nil
        {
            cell = BookWallTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
            cell.title.text = posts[indexPath.row].title
        
            cell.emailOfOwner.text = "From : "+posts[indexPath.row].email
        
            if posts[indexPath.row].reserved == true {
        
                    cell.accessoryType = .checkmark
            } else {
        
                    cell.accessoryType = .none
        
            }
        
        //Configure buttons on the left side of the cell
        cell.leftButtons = [MGSwipeButton(title: "Reserve",backgroundColor: UIColor.blue, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            
            //Update database and present a checkmark.
            self.db.updateReserved(index: indexPath.row, posts: &self.posts)
            if self.posts[indexPath.row].reserved == true {
                cell.accessoryType = .checkmark
            } else {
            cell.accessoryType = .none
            }

            return true
        })]
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D  
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logUserOut(_ sender: Any) {
        
        if logOut.isTouchInside {
            
          
//            FIRAuth.signOut().then(function() {
//                print("Sign-out successful.")
//                self.performSegue(withIdentifier: "previousView", sender: nil)
//
//                }, function(error) {
//                print("couldn't sign out user")
//            });
            
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                print("SIGNED OUT")
                self.performSegue(withIdentifier: "previousView", sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
        }
    }
    // Add data to the database when user adds a book.
    @IBAction func addBook(_ sender: Any) {
        if addBookButton.isTouchInside {
            db.post(bookTitle: bookTitle.text!)
            bookTitle.text = ""
        }
    }
}


