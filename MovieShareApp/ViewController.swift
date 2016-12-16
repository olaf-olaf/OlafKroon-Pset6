//
//  ViewController.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 06/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//
// ViewControllor.swift is the log in / register screen of the app. If the user logs in his
// username and password are stored in userdefaults to automatically log the user in. The user
// can register via an alertview. 
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the user hasn't logged out previously, log in automatically.
        let userEmail = UserDefaultsClass.sharedInstance.defaults.string(forKey: "email")
        let userPassword = UserDefaultsClass.sharedInstance.defaults.string(forKey: "password")
        if  userEmail == nil {
            print("NO DATA IN DEFAULTS")
        } else {
            
            //Configure Firebase if it hasn't configured yet.
            if(FIRApp.defaultApp() == nil){
                FIRApp.configure()
            }
           
            // Log user in and segue to next view.
            FIRAuth.auth()?.signIn(withEmail: userEmail!, password: userPassword!) { (user, error) in
                if error == nil {
                    print("autolog in successful")
                    self.performSegue(withIdentifier: "nextView", sender: nil)

                    }else{
                        print("autolog in failed")
                    }
                }
            
            if FIRAuth.auth()?.currentUser != nil {
                    self.performSegue(withIdentifier: "nextView", sender: nil)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Log user in and Segue to next view.
    @IBAction func touchLogin(_ sender: Any) {
        
        let email = self.email.text!
        let password = self.password.text!
        
        // Update userdefaults.
        UserDefaultsClass.sharedInstance.defaults.set(email, forKey: "email")
        UserDefaultsClass.sharedInstance.defaults.set(password, forKey: "password")
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("log in successful")
            }else{
                
                // If the username and/or password is invalid, show a alert to user.
                print("log in failed")
                let alert = UIAlertController(title: "invalid email and/or password", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // When all data is retrieved  segue to next view
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "nextView", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: BookWallViewController = segue.destination as! BookWallViewController
        
    }

    
    // Allow the user to register.
    @IBAction func touchRegister(_ sender: Any) {
        
        if register.isTouchInside {
            
            // Create the alert controller.
            let alert = UIAlertController(title: "Register", message: "Enter your email and password", preferredStyle: .alert)
            
            // Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "Email"
            }
            alert.addTextField { (secondTextField) in secondTextField.placeholder = "Password"
            }
            
            //  Grab the value from the text field when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let secondTextField = alert?.textFields![1]
                let userEmail = textField!.text!
                let userPassword = secondTextField!.text!
                
                // Register user.
                FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
                    if error == nil {
                        print("registration successful")
                    }else{
                        print("FAILCHECK")
                    }
                   
                })
                
                // Directly log user out after registration.
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                    print("SIGNED OUT")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }))
            
            //  Present the alert to register.
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    // When the user quits the app encode state.
    override func encodeRestorableState(with coder: NSCoder) {
        
        if let userEmail = email.text {
            coder.encode(userEmail, forKey: "userEmail")
        }
        if let userPassword = password.text {
            coder.encode(userPassword, forKey: "userPassword")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    // When the user opens the app. Decode state.
    override func decodeRestorableState(with coder: NSCoder) {
        
        if let userEmail = coder.decodeObject(forKey: "userEmail") as? String {
            email.text = userEmail
        }
        
        if let userPassword = coder.decodeObject(forKey: "userPassword") as? String {
           password.text = userPassword
        }
        
        super.decodeRestorableState(with: coder)
    }
    
}
// Restore view.
extension ViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any],
                               coder: NSCoder) -> UIViewController? {
        let vc = ViewController()
        return vc
    }
}


