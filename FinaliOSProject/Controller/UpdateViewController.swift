//
//  UpdateViewController.swift
//  FinaliOSProject
//
//  Created by Dharam Singh on 2020-01-21.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    var singleUserObject = UserData()
    let formatter = DateFormatter()
    var dataImage:UIImage?
    var index = 0
    let datePicker = UIDatePicker()
    var selectedCountry = ""
    var getToUpdate = false

    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var latitudeTxtField: UITextField!
    @IBOutlet weak var longitudeTxtField: UITextField!
    @IBOutlet weak var birthdayTxtField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func clickHereBtnTapped(_ sender: Any) {
        pickPhoto()

    }
    @IBAction func updateBtnTapped(_ sender: Any) {
        
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
       
            self.updateRecord(userData: self.singleUserObject, name: self.nameTxtField.text!, country: self.countryTxtField.text!, latitude: Double(self.latitudeTxtField.text!)!, longitude: Double(self.longitudeTxtField.text!)!, gender: self.segment.titleForSegment(at: self.segment.selectedSegmentIndex)!, birthday: self.formatter.date(from: self.birthdayTxtField.text!) ?? Date(), userImage: 2)
            
            
       
    }
    @IBAction func doneBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            
            
            if selectedCountry != ""{
                countryTxtField.text = selectedCountry
            }
            countryTxtField.delegate = self
            birthdayTxtField.delegate = self
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            nameTxtField.text = singleUserObject.name
            if getToUpdate == true{
                countryTxtField.text = singleUserObject.country
                getToUpdate = false

            }
            
            countryTxtField.addTarget(self, action: #selector(countryBtnPressed), for: .touchDown)
            
            let text = singleUserObject.gender!
            
            showDatePicker()
            
            if text == "Male"{
                segment.selectedSegmentIndex = 0
            }else if text == "Female"{
                segment.selectedSegmentIndex = 1
                
            }else{
                segment.selectedSegmentIndex = 2
            }
            
            //genderTxtField.text = singleUserObject.gender
            latitudeTxtField.text = singleUserObject.latitude.description
            longitudeTxtField.text = singleUserObject.longitude.description
            birthdayTxtField.text =  formatter.string(from: singleUserObject.birthday!)
            imageView.image = singleUserObject.photoImage
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHappen))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        
    }
    
    
    
    
    
}

extension UpdateViewController{
    
    
    @objc func countryBtnPressed(){
         self.view.layoutIfNeeded()
         //   self.performSegue(withIdentifier: "CountryViewController", sender: self)
         
         if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController {
             
             viewController.countryComeToUpdate = selectedCountry
             
             if let navigator = navigationController {
                 navigator.pushViewController(viewController, animated: true)
             }
         }}
    
    //  Functions for picking image from gallery
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    }
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        dataImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = dataImage {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Date picker
    func showDatePicker(){
        
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        birthdayTxtField.inputAccessoryView = toolbar
        birthdayTxtField.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        birthdayTxtField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func touchHappen() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    // For Updating Data in Core Data
    func updateRecord(userData: UserData,name:String, country:String,latitude: Double,longitude: Double,gender:String,birthday: Date,userImage: NSNumber){
        
        userData.name = name
        userData.country = country
        userData.gender = gender
        userData.latitude = latitude
        userData.longitude = longitude
        userData.birthday = birthday
        
    //    userData.removePhotoFile()
        
        if let image = dataImage {
            userData.photoID = nil
            
            if !userData.hasPhoto {
                userData.photoID = UserData.nextPhotoID() as NSNumber
                //index = userData.photoID as! Int
            }
            
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: userData.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        do {
            try! HomeViewController.managedContext.save()
            afterDelay(0.6) {
            }
        } catch {
            fatalCoreDataError(error)
        }
        
        try! HomeViewController.managedContext.save()
    }
    
    
 
    
}

//extension UpdateViewController:CountryProtocol {
//func insertData(controller: CountryViewController, country: String) {
//    countryTxtField.text = country
//    navigationController?.popViewController(animated: true)
//    }}

