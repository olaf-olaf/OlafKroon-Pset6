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

    
    
    
}
