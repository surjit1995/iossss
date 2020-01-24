//
//  AddDetailViewController.swift
//  FinaliOSProject
//
//  Created by Dharam Singh on 2020-01-20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit

class AddDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    // Variables
    
    var image: UIImage?
    var userData = UserData()
    var index = 0
    let datePicker = UIDatePicker()
    var formatter = DateFormatter()
    var selectedCountry = ""
    //Outlets
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var latitudeTxtField: UITextField!
    @IBOutlet weak var longitudeTxtField: UITextField!
    @IBOutlet weak var birthdayTxtField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        
            
            
            let vc = self.navigationController?.viewControllers[0] as! HomeViewController
           
            
            
            self.navigationController?.popViewController(animated: true)
       
        
    }
    @IBAction func saveImage(_ sender: Any) {
        // saveImage()
    }
    @IBAction func clickHereBtnTapped(_ sender: Any) {
        pickPhoto()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    func alertBox(msg: String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
    }
    
    
}








extension AddDetailViewController{
    
    // Button Actions
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        

            formatter.dateStyle = .long
            formatter.timeStyle = .none
                
                
                self.insertRecord(name: self.nameTxtField.text ?? "", country: self.countryTxtField.text ?? "", latitude: Double(self.latitudeTxtField.text ?? "") ?? 0.0, longitude: Double(self.longitudeTxtField.text ?? "") ?? 0.0, gender: self.segment.titleForSegment(at: self.segment.selectedSegmentIndex) ?? "", birthday: self.formatter.date(from: self.birthdayTxtField.text ?? "") ?? Date() , userImage: (2))
                
                
              
    
    }
    
    func initView(){
        
        
        if selectedCountry != ""{
            countryTxtField.text = selectedCountry
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHappen))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        showDatePicker()
        
        countryTxtField.delegate = self                  //set delegate to textfile
        countryTxtField.addTarget(self, action: #selector(countryBtnPressed), for: .touchDown)
        
    }
    
    
    

    @objc func countryBtnPressed(){
        self.view.layoutIfNeeded()
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController {
            viewController.checkVC = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }}
    
    //Date picker
    func showDatePicker(){
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
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveImage() {
        // Save image
        userData = UserData(context: HomeViewController.managedContext)
        if let image = image {
            userData.photoID = nil
            
            if !userData.hasPhoto {
                userData.photoID = UserData.nextPhotoID() as NSNumber
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
                
                //   self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    @objc func touchHappen() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    func insertRecord(name:String, country:String,latitude: Double,longitude: Double,gender:String,birthday: Date,userImage: Int){
        
        let userData = UserData(context: HomeViewController.managedContext)
        
        userData.name = name
        userData.country = country
        userData.gender = gender
        userData.latitude = latitude
        userData.longitude = longitude
        userData.birthday = birthday
        
        if let image = image {
            userData.photoID = nil
            
            if !userData.hasPhoto {
                userData.photoID = UserData.nextPhotoID() as NSNumber
                index = userData.photoID as! Int
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

extension AddDetailViewController: UITextFieldDelegate{
    
}

