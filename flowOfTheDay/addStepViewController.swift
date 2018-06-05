//
//  addStepViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class addStepViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SendTagToParent {
    
    
    var theImage: UIImage?
    var selectedTag = [String: Any]()
    var TagToShow = [String]()
    
    @IBOutlet weak var addFlowBtnEl: UIButton!
    @IBOutlet weak var addFlowButtonEL: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerCollectionTagHeight: UIView!
    @IBOutlet weak var containerCollectionConstant: NSLayoutConstraint!
    
    func loadTags(tagsArray: Dictionary<String, Any>) {
        selectedTag = tagsArray
        TagToShow.removeAll()
        for (key,value) in selectedTag {
            TagToShow.append(key)
        }
        collectionView.reloadData()
    }
    
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewImage.image = theImage
        previewImage.layer.cornerRadius = 5.0
        previewImage.layer.borderWidth = 1.0
        previewImage.layer.borderColor = UIColor.clear.cgColor
        previewImage.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(selectedTag.count > 0) {
            containerCollectionConstant.constant = 60
            addFlowButtonEL.alpha = 1
            addFlowButtonEL.isEnabled = true
            self.view.layoutIfNeeded()
        } else {
            containerCollectionConstant.constant = 0
            addFlowButtonEL.alpha = 0.4
            addFlowButtonEL.isEnabled = false
            self.view.layoutIfNeeded()
        }
        return selectedTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCellTag", for: indexPath) as? addStepTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tagButtonSetp.setTitle(TagToShow[indexPath.row], for: .normal)
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTagNewFlow" {
            let destinationVC = segue.destination as! customSearchViewController
            
            destinationVC.delegate = self
        }
    }
    @IBAction func postFlowBtnAction(_ sender: Any) {
        ProgressHUD.show("waiting..", interaction: false)
        if let profileImg =  self.theImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            let photoId = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://flowoftheday-2edf3.appspot.com").child("post_image").child(photoId)

            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    let photoUrl = downloadURL.absoluteString
                    self.sendDataToDatabase(photoUrl: photoUrl)
                    
                    // return to mainScreen
//                    self.dismiss(animated: false, completion: nil)
                }
                
            })
        } else {
            ProgressHUD.showError("image can't be empty")
        }
    }
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postRef = ref.child("posts")
        let newPostId = postRef.childByAutoId().key
        let newPostRef = postRef.child(newPostId)
        let userID = Auth.auth().currentUser!.uid
        newPostRef.setValue(["user": userID, "photoUrl": photoUrl, "tags": selectedTag, "rate": 0, "day": false, "new": true, "toShow": false, "addDate": ServerValue.timestamp()], withCompletionBlock:  { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("success")
            self.dismiss(animated: false, completion: nil)
        })
    }
}
