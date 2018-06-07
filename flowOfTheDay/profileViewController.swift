//
//  profileViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher

class profileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mailLabel: UILabel!
    var ContentArray = [ProfilContent]()
    var CurrentArray = [ProfilContent]()
    var userId: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userId = Auth.auth().currentUser?.uid
        setDatabase()
        setDatabasepost()
        print("user", userId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setDatabase() {
        Database.database().reference().child("users").queryOrderedByKey().queryEqual(toValue: userId).observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let username = dict["username"] as! String
                let mail = dict["email"] as! String
                self.usernameLabel.text = String(username)
                self.mailLabel.text = String(mail)
            }
        })
    }
    
    private func setDatabasepost() {
        Database.database().reference().child("posts").queryOrdered(byChild: "user").queryEqual(toValue: userId).observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let link = snapshot.key
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                self.ContentArray.append(ProfilContent(image: image, link: link, numberOfLike: numberOfLike ))
                self.CurrentArray = self.ContentArray
                self.collectionView.reloadData()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ContentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCellCollection", for: indexPath) as? searchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        
        let url = URL(string: CurrentArray[indexPath.row].image)
        let ressource = ImageResource(downloadURL: url!, cacheKey: CurrentArray[indexPath.row].link)
        cell.postImage.kf.setImage(with: ressource)

        cell.postNumber.text = String( CurrentArray[indexPath.row].numberOfLike)
        cell.postIdentifier.text = CurrentArray[indexPath.row].link
        
        return cell
    }
    

    @IBAction func logOutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "goToLogOut", sender: self)
    }
    
    //        try! Auth.auth().signOut()
    //        self.performSegue(withIdentifier: "goToLogOut", sender: self)
    
}

class ProfilContent {
    let image: String
    var like: Bool
    let link: String
    let numberOfLike: Int
    
    
    init(image: String, link: String, numberOfLike: Int) {
        self.image = image
        self.link = link
        self.like = false
        self.numberOfLike = numberOfLike
    }
}
