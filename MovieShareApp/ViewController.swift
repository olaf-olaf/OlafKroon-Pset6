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
        
        // Use userdefaults to automatically log users in.
        let userEmail = UserDefaultsClass.sharedInstance.defaults.string(forKey: "email")
        let userPassword = UserDefaultsClass.sharedInstance.defaults.string(forKey: "password")
        if  userEmail == nil {
            print("NO DATA IN DEFAULTS")
        } else {
            
            //Configure Firebase if it hasn't configured yet.
            if(FIRApp.defaultApp() == nil){
                FIRApp.configure()
            }
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

  
    @IBAction func touchLogin(_ sender: Any) {
        
        let email = self.email.text!
        let password = self.password.text!
    
        UserDefaultsClass.sharedInstance.defaults.set(email, forKey: "email")
        UserDefaultsClass.sharedInstance.defaults.set(password, forKey: "password")
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("log in successful")
            }else{
                print("log in failed")
                let alert = UIAlertController(title: "invalid email and/or password", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "nextView", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: BookWallViewController = segue.destination as! BookWallViewController
        
    }

    
    @IBAction func touchRegister(_ sender: Any) {
        
        if register.isTouchInside {
            
            // Use an alertview to register to minimise the amount of views needed in the app.
            let alert = UIAlertController(title: "Register", message: "Enter your email and password", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Email"
            }
            alert.addTextField { (secondTextField) in secondTextField.placeholder = "Password"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let secondTextField = alert?.textFields![1]
                let userEmail = textField!.text!
                let userPassword = secondTextField!.text!
                
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


