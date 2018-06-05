//
//  DetailsFlowViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 04/06/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class DetailsFlowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var theId: String?
    var tagArray = [String]()
    var isAlreadySelected = false
    var numberOfLikes = Int()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageFlow: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let tapProfileGesture = UITapGestureRecognizer(target: self, action: #selector(signUpViewController.handleSelectProfileImageView))
        tapProfileGesture.numberOfTapsRequired = 2
        imageFlow.addGestureRecognizer(tapProfileGesture)
        imageFlow.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        if isAlreadySelected == false {
            isAlreadySelected = true
            let newLikeNumber = numberOfLikes + 1
            numberOfLikes = newLikeNumber
            self.rateLabel.text = String(self.numberOfLikes)
            Database.database().reference().child("posts").child(theId!).updateChildValues(["rate": newLikeNumber])
            likeImage.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
                self.likeImage.isHidden = true
            }
        }
    }
    
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "FR-fr")
        
        return formatter.string(from: date as Date)
    }
    
    func setUpData() {
        let ref = Database.database().reference()
        let postRef = ref.child("posts")
        let userRef = ref.child("users")
        postRef.queryOrderedByKey().queryEqual(toValue: theId!).observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                let user = dict["user"] as! String
                let dictTag = dict["tags"] as! [String: Any]
                let dateFlow = dict["addDate"] as! Double
                self.numberOfLikes = numberOfLike
                
                self.dateLabel.text = self.convertTimestamp(serverTimestamp: dateFlow)
                self.rateLabel.text = String(self.numberOfLikes)
                
                let url = URL(string: image)
                let ressource = ImageResource(downloadURL: url!, cacheKey: self.theId)
                self.imageFlow.kf.setImage(with: ressource)
//                let data = try? Data(contentsOf: url!)
//
//                if let imageData = data {
//                    _ = UIImage(data: imageData)
//                    self.imageFlow.image = UIImage(data: imageData)
//                }
                
                
                self.imageFlow.layer.cornerRadius = 5.0
                self.imageFlow.layer.borderWidth = 1.0
                self.imageFlow.layer.borderColor = UIColor.clear.cgColor
                self.imageFlow.layer.masksToBounds = true
                
                for (key,value) in dictTag {
                    self.tagArray.append(key)
                    self.collectionView.reloadData()
                }
                
                userRef.queryOrderedByKey().queryEqual(toValue: user).observe(.childAdded, with:{ (snapshot: DataSnapshot) in
                    if let dicts = snapshot.value as? [String: Any] {
                        let name = dicts["username"] as! String
                        print(name)
                        self.nameLabel.text = name
                    }
                })
            }

        })
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return tagArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailsCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.tagDetails.setTitle(tagArray[indexPath.row], for: .normal)
        return cell

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
