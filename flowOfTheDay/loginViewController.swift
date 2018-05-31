//
//  loginViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 26/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

extension UITextField {
    func setBorder() {
        let line = UIView()
        line.frame.size = CGSize(width: self.frame.size.width, height: 0.5)
        line.frame.origin = CGPoint(x: 0, y: self.frame.height - line.frame.height + 2 )
        line.backgroundColor = UIColor.white
        line.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.addSubview(line)
    }
}


class loginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let colorGreyB = UIColor(red:0.718, green:0.718, blue:0.718, alpha:1.0)
    let colorBlueB = UIColor(red:0.188, green:0.169, blue:0.922, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailField.setBorder()
        passwordField.setBorder()
        handleTextFieldMessage()
    }
    
    func handleTextFieldMessage() {
        passwordField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailField.text, !email.isEmpty, let pass = passwordField.text, !pass.isEmpty else {
            loginButton.backgroundColor = colorGreyB
            loginButton.isEnabled = false
            return
        }
        
        loginButton.backgroundColor = colorBlueB
        loginButton.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func connexionButonAction(_ sender: Any) {
        view.endEditing(true)
        guard let email = emailField.text else{return}
        guard let pass = passwordField.text else{return}
        ProgressHUD.show("waiting..", interaction: false)
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                ProgressHUD.showSuccess("success")
                self.dismiss(animated: false, completion: nil)
            } else {
                ProgressHUD.showError(error!.localizedDescription)
                print("#signeIn error creating user  : \(error!.localizedDescription)")
            }
        }
    }
    


}
