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
        
//        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "Reserve",backgroundColor: UIColor.blue, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("TOUCHED")
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBook(_ sender: Any) {
        if addBookButton.isTouchInside {
            db.post(bookTitle: bookTitle.text!)
            bookTitle.text = ""
            
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
