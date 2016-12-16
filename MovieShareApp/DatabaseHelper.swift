//
//  DatabaseHelper.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 12/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//
// DatabaseHelper.swift consists of a class of methods to alter the firebase database.

import Foundation
import Firebase


class DatabaseHelper {
    
    init () {
        
    }
    
    // Post data to the database
    func post(bookTitle: String) {
        
        // Get all data.
        let user = FIRAuth.auth()?.currentUser
        let title = bookTitle
        let reserved = false
        let email = user?.email
        let post: [String: Any] = ["email" : email,
                                   "reserved" : reserved,
                                   "title" : title]
        
        // Update database.
        let dataBaseReference = FIRDatabase.database().reference()
        let postRef = dataBaseReference.child("posts").childByAutoId();postRef.setValue(post)
    }
    
    // Delete data from database.
    func delete(parentId: String, index: Int, posts: inout [Post]) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        // Delete the parentnode of a data child nodes.
        ref.child("posts").child(parentId).removeValue()
        
        // Remove data from the posts array.
        posts.remove(at: index)
    }
    
    // Update data when a user reserves a book.
    func updateReserved(index: Int,posts: inout [Post]) {
        
        // Find the location of the data in database.
        let parentId = posts[index].parent
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        // Check current state of reserved
        if posts[index].reserved == false {
            
            //Update database and posts array to true
            ref.child("posts").child(parentId).updateChildValues(["reserved": true])
            posts[index].reserved = true
            print("UPDATED",posts[index].reserved)

        } else {
            
            //Update database and posts array to false
            ref.child("posts").child(parentId).updateChildValues(["reserved": false])
            posts[index].reserved = false
            print("UPDATED",posts[index].reserved)
        }
    }
}
