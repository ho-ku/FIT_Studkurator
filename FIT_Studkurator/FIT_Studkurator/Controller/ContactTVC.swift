//
//  ContactTVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 11/29/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class ContactTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    private var continuing = true
    
    @IBOutlet weak var fullNameField: UITextField! {
        didSet {
            fullNameField.delegate = self
            fullNameField.tag = 1
            fullNameField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            emailField.delegate = self
            emailField.tag = 2
        }
    }
    
    @IBOutlet weak var messageField: UITextView! {
        didSet {
            messageField.tag = 3
            messageField.layer.cornerRadius = 5.0
            messageField.layer.borderWidth = 2.0
            messageField.layer.borderColor = UIColor.blue.cgColor
            messageField.delegate = self
        }
    }
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    
    
    @IBOutlet weak var sendBtn: UIButton! {
        didSet {
            sendBtn.layer.cornerRadius = 10.0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            line1.backgroundColor = #colorLiteral(red: 0, green: 0.6597257257, blue: 0, alpha: 1)
        case 2:
            line2.backgroundColor = #colorLiteral(red: 0, green: 0.6597257257, blue: 0, alpha: 1)
        default:
            fatalError("idk")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = #colorLiteral(red: 0, green: 0.6597257257, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        [line1, line2].forEach { line in
            line.backgroundColor = .blue
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.text = "I have a trouble...".localized
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        
        let regex = NSRegularExpression(".+(@)+[[:alnum:]]{2,}+\\.+[[:alnum:]]{2,}")
        
        if let fullName = fullNameField.text, let email = emailField.text, let message = messageField.text {
            if fullName == "" {
                line1.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                alert(message: "Name field is empty".localized)
            } else if email == "" {
                line2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                alert(message: "Email field is empty".localized)
            } else if !regex.matches(email) {
                line2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                alert(message: "Invalid email".localized)
            } else if message.count < 8 {
                continuing = false
                let alertController = UIAlertController(title: "Are you sure?".localized, message: "You should write complex explanation of your problem, but your message is too short. Are you sure that you want to continue?".localized, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: { (_) in
                    // MARK:- Here will be POST request
                    let alert = UIAlertController(title: "Alright".localized, message: "Thanks for your letter. It will be considered as soon as possible.".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.performSegue(withIdentifier: "backToLogin", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }))
                
                alertController.addAction(UIAlertAction(title: "No".localized, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // MARK:- Here will be POST request
                let alert = UIAlertController(title: "Alright".localized, message: "Thanks for your letter. It will be considered as soon as possible.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.performSegue(withIdentifier: "backToLogin", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            alert(message: "Something went wrong. Please check all fields".localized)
        }
        
    }
    
    func alert(message: String, title: String = "Oops..".localized) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
