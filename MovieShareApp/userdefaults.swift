//
//  userdefaults.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 15/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//
// A singleton for userdefaults so they can be accesed in global scope. 

import Foundation

class UserDefaultsClass {
    
    
    static let sharedInstance = UserDefaultsClass()
    
    
    let defaults = UserDefaults.standard
    
    
    private init(){
        
    }
}
