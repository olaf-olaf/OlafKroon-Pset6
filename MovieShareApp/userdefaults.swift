//
//  userdefaults.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 15/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import Foundation

class UserDefaultsClass {
    
    
    static let sharedInstance = UserDefaultsClass()
    
    
    let defaults = UserDefaults.standard
    
    
    private init(){
        
    }
    
    //let userEmail = UserDefaultsClass.sharedInstance.defaults.object(forKey: "email") as! String
    //        let userPassword = UserDefaultsClass.sharedInstance.defaults.object(forKey: "email") as! String
    
    
}
