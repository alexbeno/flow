//
//  BestPostViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 02/06/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase

class BestPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var ContentArray = [Content]()
    var CurrentArray = [Content]()
    var test = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUptContent()
        setDatabase()
    }
    
    func setUptContent() {
    
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date)
    }
    
    private func setDatabase() {
        Database.database().reference().child("posts").observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let date = dict["addDate"] as! Double
                let link = snapshot.key
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                self.ContentArray.append(Content(image: image, link: link, numberOfLike: numberOfLike ))
                self.CurrentArray = self.ContentArray
                self.collectionView.reloadData()
                
                print(Date())
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return ContentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollection", for: indexPath) as? flowOfDayCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        
        let url = URL(string: CurrentArray[indexPath.row].image)
        let data = try? Data(contentsOf: url!)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.postImage.image = UIImage(data: imageData)
        }
        
        cell.postNumber.text = String( CurrentArray[indexPath.row].numberOfLike)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 260
        return CGSize(width: collectionView.bounds.size.width/2.1, height: CGFloat(kWhateverHeightYouWant))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: TagClass

class Content {
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


