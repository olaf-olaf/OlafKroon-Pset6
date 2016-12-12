//
//  DatabaseHelper.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 12/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

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
        
        let postId = postRef.key
        print("POSTID", postId)
    }
    
    func delete(parentId: String, index: Int, posts: inout [Post]) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("posts").child(parentId).removeValue()
        posts.remove(at: index)
        
    }
    
    
    func updateReserved(index: Int,posts: inout [Post]) {
        
        let parentId = posts[index].parent
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        print(posts[index].reserved)
        
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
