//
//  EditTVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/2/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import Firebase

class EditTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var dataBase: [Student]!
    private var textFieldArray = [UITextField]()
    private var lineArray = [UIView]()
    private var pickerArray = 1...50
    private var parser = Parser()
    private var id: String {
        return UserDefaults.standard.value(forKey: "id") as! String
    }
    
    
    // MARK:- logic with student
    var student: Student!
        
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var text1: UITextField! {
        didSet {
            text1.delegate = self
            text1.text = student.fullName
        }
    } // Full Name
    @IBOutlet weak var text2: UITextField! {
        didSet {
            text2.delegate = self
            text2.text = student.phoneNumber
        }
    } // Phone Number
    @IBOutlet weak var text3: UITextField! {
        didSet {
            text3.delegate = self
            text3.text = student.address
        }
    } // Address
    @IBOutlet weak var text4: UITextField! {
        didSet {
            text4.delegate = self
            text4.text = student.homeAddress
        }
    } // Home Address
    @IBOutlet weak var text5: UITextField! {
        didSet {
            text5.delegate = self
            text5.text = student.mother.fullName
        }
    } // Mother Full Name
    @IBOutlet weak var text6: UITextField! {
        didSet {
            text6.delegate = self
            text6.text = student.mother.phoneNumber
        }
    } // Mother Phone Number
    @IBOutlet weak var text7: UITextField! {
        didSet {
            text7.delegate = self
            text7.text = student.father.fullName
        }
    } // Father Full Name
    @IBOutlet weak var text8: UITextField! {
        didSet {
            text8.delegate = self
            text8.text = student.father.phoneNumber
        }
    } // Father Phone Number
        
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var line6: UIView!
    @IBOutlet weak var line7: UIView!
    @IBOutlet weak var line8: UIView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        dataBase = parser.parse(dict: (UserDefaults.standard.value(forKey: "dataBase") as? [String: [String: String]])!)
        
        pickerView.selectRow(Int(student.number-1), inComponent: 0, animated: false)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        textFieldArray = [text1, text2, text3, text4, text5, text6, text7, text8]
        lineArray = [line1, line2, line3, line4, line5, line6, line7, line8]
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            lineArray[textFieldArray.firstIndex(of: textField)!].backgroundColor = #colorLiteral(red: 0, green: 0.6597257257, blue: 0, alpha: 1)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            lineArray[textFieldArray.firstIndex(of: textField)!].backgroundColor = UIColor.systemBlue
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            lineArray[textFieldArray.firstIndex(of: textField)!].backgroundColor = UIColor.systemBlue
        }
        
        // MARK: - Picker view data source
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerArray.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(Array(pickerArray)[row])"
        }

        // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 9
        }

        @IBAction func saveBtnPressed(_ sender: Any) {
            if check() {
                let newStudent = Student(fullName: text1.text!, number: pickerView.selectedRow(inComponent: 0)+1, address: text3.text!, mother: Parent(type: .mother, fullName: text5.text!, phoneNumber: text6.text!), father: Parent(type: .father, fullName: text7.text!, phoneNumber: text8.text!), homeAddress: text4.text!, phoneNumber: text2.text!)
                var saveEnabled = true
                        
                fetchDataBase { (result) in
                    self.dataBase.forEach { student in
                        if student.number == Int(self.pickerView.selectedRow(inComponent: 0)+1) && student.number != self.student.number {
                            
                            let alertController = UIAlertController(title: "Oops..".localized, message: "This number is already taken".localized, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                                    
                            saveEnabled = false
                        }
                    }
                            
                    if saveEnabled {
                
                        self.save(student: newStudent) { (_) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
                            self.present(controller, animated: true, completion: nil)
                        }
                                               
                                               
                        
                    }
                }
                        
                        
                        
            }
        }
    
        func save(student currentStudent: Student, completionHandler: @escaping (Result<Any, Error>) -> ()) {
            let ref = Database.database().reference()
            var unparsedDataBase = self.parser.unparse(data: dataBase)
            unparsedDataBase["\(currentStudent.number-1)k"] = self.parser.unparse(data: [currentStudent])["\(currentStudent.number-1)k"]!
            UserDefaults.standard.set(unparsedDataBase, forKey: "dataBase")
            ref.child("\(id)/groupDataBase/\(currentStudent.number-1)k").removeValue()
            ref.child("\(id)/groupDataBase").setValue(unparsedDataBase)
            completionHandler(.success(dataBase!))
        }
                
        func fetchDataBase(completionHandler: @escaping (Result<[Student], Error>) -> ()) {
                    
            completionHandler(.success(self.dataBase))
            
        }
               
        
        @IBAction func backBtnPressed(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
            self.present(controller, animated: true, completion: nil)
        }
        
        func check() -> Bool {
            var alright = true
            textFieldArray.forEach{ textField in
                if let text = textField.text, text != "" {} else {
                    alright = false
                    lineArray[textFieldArray.firstIndex(of: textField)!].backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                    let alertController = UIAlertController(title: "Oops..".localized, message: "Some of the fields are blank".localized, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            let regex = NSRegularExpression("[+]380+\\d{9,9}")
            
            [text2, text6, text8].forEach { text in
                if !regex.matches(text!.text!) {
                    alright = false
                    lineArray[textFieldArray.firstIndex(of: text!)!].backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
                    let alertController = UIAlertController(title: "Oops..".localized, message: "Invalid phone number".localized, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            return alright
        }
        
        
    }
