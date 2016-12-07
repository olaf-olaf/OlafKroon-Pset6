//
//  PostClass.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 07/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation

class Post {
    
    var email = String()
    var reserved = Bool()
    var title = String()
    
    
    init(email: String, reserved: Bool, title: String) {
    }
    
    
    
    //
    //        let dataBaseref  = FIRDatabase.database().reference()
    //        dataBaseref.child("posts").queryOrderedByKey().observe(.childAdded, with: { snapshot in
    //            print ("SNAPSHOT")
    //
    //
    //            let value = snapshot.value as? NSDictionary
    //
    //            let title = value!["title"] as! String
    //            let email = value!["title"] as! String
    //            let reserved = value!["reserved"] as! Bool
    //
    //            // Append data to posts array
    //            self.posts.insert(Post(email: email, reserved: reserved, title: title), at: 0)
    //
    //            for post in self.posts {
    //
    //                print("TITLECHECKER", post.title)
    //            }
    //self.TableView.reloadData()
    
    //        })
    
    //        cell.title.text = posts[indexPath.row].title
    //
    //        cell.emailOfOwner.text = posts[indexPath.row].email
    //
    //        if posts[indexPath.row].reserved == true {
    //
    //            cell.accessoryType = .checkmark
    //        } else {
    //
    //              cell.accessoryType = .none
    //            
    //        }
    
}
