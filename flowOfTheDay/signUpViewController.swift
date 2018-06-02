//
//  signUpViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 26/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

extension UITextField {
    func signSetBorder() {
        let line = UIView()
        line.frame.size = CGSize(width: self.frame.size.width, height: 0.5)
        line.frame.origin = CGPoint(x: 0, y: self.frame.height - line.frame.height + 2 )
        line.backgroundColor = UIColor.white
        line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.addSubview(line)
    }
}

class signUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    let colorGreyC = UIColor(red:0.718, green:0.718, blue:0.718, alpha:1.0)
    let colorBlueC = UIColor(red:0.188, green:0.169, blue:0.922, alpha:1.0)
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameField.signSetBorder()
        mailField.signSetBorder()
        passField.signSetBorder()
        profilePicture.layer.cornerRadius = 50

        let tapProfileGesture = UITapGestureRecognizer(target: self, action: #selector(signUpViewController.handleSelectProfileImageView))
        profilePicture.addGestureRecognizer(tapProfileGesture)
        profilePicture.isUserInteractionEnabled = true
        
        handleTextFieldMessage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFieldMessage() {
        nameField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        mailField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    
    }
    
    @objc func textFieldDidChange() {
        guard let username = nameField.text, !username.isEmpty, let email = mailField.text, !email.isEmpty, let pass = passField.text, !pass.isEmpty else {
            signUpButton.backgroundColor = colorGreyC
            signUpButton.isEnabled = false
            return
        }
    
        signUpButton.backgroundColor = colorBlueC
        signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        
        present(pickerControler , animated: true, completion: nil)
    }
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        view.endEditing(true)
        guard let username = nameField.text else{return}
        guard let mail = mailField.text else{return}
        guard let pass = passField.text else{return}
        
        ProgressHUD.show("waiting..", interaction: false)
        
        Auth.auth().createUser(withEmail: mail, password: pass) { user, error in
            if error == nil && user != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges{ error in
                    if error == nil {
                        print("#signeIn user display name change")
                    }
                }
                print("#signeIn user Created !")
                let uid = user?.user.uid
                
                // profile image
                let storageRef = Storage.storage().reference(forURL: "gs://flowoftheday-2edf3.appspot.com").child("profile_image").child(uid!)
                
                if let profileImg =  self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                    
                    storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            return
                        }
                        
                        //                        let profileImageUrl = storageRef.downloadURL()
                        ProgressHUD.showSuccess("success")
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                return
                            }
                            let profileImageUrl = downloadURL.absoluteString
                            // user data
                            let ref = Database.database().reference()
                            let userRef = ref.child("users")
                            let newUserRef = userRef.child(uid!)
                            newUserRef.setValue(["username": username, "email": mail, "profileImage": profileImageUrl])
                            
                            // return to mainScreen
                            self.dismiss(animated: false, completion: nil)
                        }
                        
                    })
                }
                
            } else {
                ProgressHUD.showError(error?.localizedDescription)
                print("#signeIn error creating user  : \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

extension signUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("#signUp end image")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profilePicture.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
