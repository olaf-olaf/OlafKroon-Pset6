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
    }
    
    // The posts array is passed by reference so that it can be altered by this function.
    func delete(parentId: String, index: Int, posts: inout [Post]) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("posts").child(parentId).removeValue()
        posts.remove(at: index)
    }
    
    // Idem.
    func updateReserved(index: Int,posts: inout [Post]) {
        
        let parentId = posts[index].parent
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        if posts[index].reserved == false {
            ref.child("posts").child(parentId).updateChildValues(["reserved": true])
            posts[index].reserved = true
            print("UPDATED",posts[index].reserved)

        } else {
            
            ref.child("posts").child(parentId).updateChildValues(["reserved": false])
            posts[index].reserved = false
            print("UPDATED",posts[index].reserved)
        }
    }
}
