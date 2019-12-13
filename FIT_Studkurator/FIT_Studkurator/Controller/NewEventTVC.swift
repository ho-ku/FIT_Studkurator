//
//  NewEventTVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/7/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import Firebase


class NewEventTVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    private var dataBase = [Event]()
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField! {
        didSet {
            nameField.delegate = self
        }
    }
    @IBOutlet weak var dateField: UITextField! {
        didSet {
            dateField.delegate = self
        }
    }
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line: UIView!
    private var notifying = false
    private var notificationText: String? = nil
    private var notificationDate: Date? = nil
    
    private var textFieldArray = [UITextField]()
    private var lineArray = [UIView]()
    private var id: String {
        return UserDefaults.standard.value(forKey: "id") as! String
    }
    private var parser = EventParser()
    private var imgsArray = [Data]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = UserDefaults.standard.value(forKey: "eventDataBase") as? [String: [String: String]] {
            dataBase = parser.parse(dict: value)
        }
        
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
               tap.cancelsTouchesInView = false
               self.view.addGestureRecognizer(tap)

            textFieldArray = [nameField, dateField]
            lineArray = [line, line2]
            
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source".localized, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo library".localized, style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImageView.image = selectedImage.fixOrientation()
            chosenImageView.contentMode = .scaleAspectFill
            chosenImageView.clipsToBounds = true
            
        }
        
        let leadingContraint = NSLayoutConstraint(item: chosenImageView!, attribute: .leading, relatedBy: .equal, toItem: chosenImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingContraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: chosenImageView!, attribute: .trailing, relatedBy: .equal, toItem: chosenImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: chosenImageView!, attribute: .top, relatedBy: .equal, toItem: chosenImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: chosenImageView!, attribute: .bottom, relatedBy: .equal, toItem: chosenImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notify(_ sender: Any) {
        notifying = notifying ? false : true
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        var newEvent: Event = Event(name: "", date: nil, isDone: false, notify: false, image: String(), number: 0)
        
        guard let name = nameField.text, name != "" else {
            line.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
            let alertController = UIAlertController(title: "Oops..".localized, message: "Some of the fields are blank".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        var date: Date? = nil
     
        if let bufferDate = dateFormatter.date(from: dateField.text!) {
            date = bufferDate
        } else {
            line2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.3)
            let alertController = UIAlertController(title: "Oops..".localized, message: "Invalid date format. Please, follow the example".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        var maxNumber = 0
        dataBase.forEach { event in
            maxNumber = event.number > maxNumber ? event.number : maxNumber
        }
        
        
        newEvent = Event(name: name, date: date, isDone: false, notify: notifying, image: "event\(maxNumber+1)", number: maxNumber+1)
        
        save(event: newEvent) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
            self.present(controller, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func save(event: Event, completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let ref = Database.database().reference()
        dataBase.append(event)
        ref.child("\(id)/eventDataBase").setValue(self.parser.unparse(data: dataBase))
        
        let group = DispatchGroup()
        group.enter()
        
        let uploadRef = Storage.storage().reference(withPath: "imgs/event\(event.number).jpg")
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        var image = Data()
        if let img = chosenImageView.image?.jpegData(compressionQuality: 0.75) {
            image = img
        }
        uploadRef.putData(image, metadata: uploadMetadata) { (downloadMetadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            
            }
        group.leave()
        group.notify(queue: DispatchQueue.main) {
            completionHandler(.success(self.dataBase))
        }
        
        
    }
    
    
}
