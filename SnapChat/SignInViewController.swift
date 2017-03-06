//
//  SignInViewController.swift
//  SnapChat
//
//  Created by Luis Medinelli on 3/4/17.
//  Copyright © 2017 iBeacon Solutions. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func turnUpTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("We tried to sign in")
            if error != nil{
                print("We have an error:\(error)")
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("Creating user\(user)")
                    FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                        if error != nil{
                            print("We have an email error:\(error)")
                        }else{
                            print("Verification Sent")
                        }
                    })
                    if error != nil{
                        print("We have an error:\(error)")
                    }else{
                        print("User Created")
                        //self.performSegue(withIdentifier: "signInSegue", sender: nil)
                        // LM: add another alert for infor that needs to confirm the email before
                        
                        let alert = UIAlertController(title: "Important", message: "Before Login, your need to confirm your email, please review your email account and press the confirm link", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                            print("Aun no verificado")
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
            }else{
                print("Signed in successfully")
                let emailVerified = FIRAuth.auth()?.currentUser?.isEmailVerified
                
                // if email is not verified alert and not login
                print("With email Verified : \(emailVerified!)")
                if emailVerified! {
                    self.performSegue(withIdentifier: "signInSegue", sender: nil)
                }else{
                    let alert = UIAlertController(title: "Imposible Login", message: "Before Login, please, take a cup of coffee and review your email for confirmation snap.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                        print("Aun no verificado")
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
                
                
            }
        })
        
    }


}

