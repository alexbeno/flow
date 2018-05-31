//
//  addViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class addViewController: UIViewController {
    
    let colorGrey = UIColor(red:0.718, green:0.718, blue:0.718, alpha:1.0)
    let colorBlue = UIColor(red:0.188, green:0.169, blue:0.922, alpha:1.0)
    var selectedImage: UIImage?

    @IBOutlet weak var borderBoxView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setBorderBox()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBorderBox() {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = colorGrey.cgColor
        yourViewBorder.lineDashPattern = [20, 20]
        yourViewBorder.frame = borderBoxView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: borderBoxView.bounds).cgPath
        borderBoxView.layer.addSublayer(yourViewBorder)
    }
    
    @IBAction func openPhotoAction(_ sender: Any) {

        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    @IBAction func uploadPhotoAction(_ sender: Any) {
        let pickerControler = UIImagePickerController()
        pickerControler.delegate = self
        
        present(pickerControler , animated: true, completion: nil)
    }
    
}

extension addViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "addStepViewController") as! addStepViewController
            myVC.theImage = image
            navigationController?.pushViewController(myVC, animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
