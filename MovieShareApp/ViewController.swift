//
//  ViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 06/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    //var ref: FIRDatabaseReference!
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Log user in and Segue to next view
    @IBAction func touchLogin(_ sender: Any) {
        
        let email = self.email.text!
        let password = self.password.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("log in successful")
            }else{
                print("log in failed")
            }
        }
        
        // When all data is retrieved segue to next view
        if FIRAuth.auth()?.currentUser != nil {
            
            // No need to send user data, Firebase keeps the user logged in.
            
            print("!---------LEGGO---------!")
            self.performSegue(withIdentifier: "nextView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: BookWallViewController = segue.destination as! BookWallViewController
        
    }

    
    @IBAction func touchRegister(_ sender: Any) {
        if register.isTouchInside {
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Register", message: "Enter your email and password", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "Email"
            }
            alert.addTextField { (secondTextField) in secondTextField.placeholder = "Password"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let secondTextField = alert?.textFields![1]
                let email = textField!.text!
                let password = secondTextField!.text!
                
                print("Email:", email)
                print("Password:", password)
                
                // Register user.
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                    if error == nil {
                        print("registration successful")
                    }else{
                        print("FAILCHECK")
                    }
                   
                })
                
                // Directly log user out after registration
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    print("SIGNED OUT")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
              
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

