//
//  ViewController.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 11/29/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    // MARK:- IBOutlets
    @IBOutlet weak var usernameField: RoundedCornerTextField! {
        didSet {
            usernameField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordField: RoundedCornerTextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.layer.cornerRadius = 10.0
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextField = view.viewWithTag(textField.tag + 1) {
            nextField.becomeFirstResponder()
        }
        if textField.tag == 2, usernameField.text != "" {
            if let username = usernameField.text, let password = passwordField.text {
                if username == "" {
                    usernameField.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                    alert(message: "Username is empty".localized)
                } else if password == "" {
                    passwordField.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                    alert(message: "Password is empty".localized)
                } else {
                    // MARK:- Alright
                    print("Alright")
                }
            } else {
                alert(message: "Something went wrong. Please check all fields".localized)
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.clear
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if let username = usernameField.text, let password = passwordField.text {
            if username == "" {
                usernameField.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                alert(message: "Username is empty".localized)
            } else if password == "" {
                passwordField.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                alert(message: "Password is empty".localized)
            } else {
                print("Alright")
            }
        } else {
            alert(message: "Something went wrong. Please check all fields".localized)
        }
        
    }
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "contactSegue", sender: self)
        
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "Oops..".localized, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

