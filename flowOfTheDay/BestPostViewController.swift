//
//  BestPostViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 02/06/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import Kingfisher


extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

class BestPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var ContentArray = [Content]()
    var CurrentArray = [Content]()
    var test = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var todayDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDatabase()
        todayDate.text = self.currentTimeDate()
        
    }
    
    func currentTimeDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "FR-fr")
        return formatter.string(from: now)
    }
    
    private func setDatabase() {
        ProgressHUD.show("waiting..", interaction: false)
        Database.database().reference().child("posts").observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let link = snapshot.key
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                let day = dict["toShow"] as! Bool
                if day == true {
                    self.ContentArray.append(Content(image: image, link: link, numberOfLike: numberOfLike ))
                    self.CurrentArray = self.ContentArray
                    self.collectionView.reloadData()
                }
            }
            ProgressHUD.showSuccess("success")
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
        let ressource = ImageResource(downloadURL: url!, cacheKey: CurrentArray[indexPath.row].link)
        cell.postImage.kf.setImage(with: ressource)
        
        cell.postNumber.text = String( CurrentArray[indexPath.row].numberOfLike)
        cell.postIdentifier.text = CurrentArray[indexPath.row].link
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 260
        return CGSize(width: collectionView.bounds.size.width/2.1, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? flowOfDayCollectionViewCell {
            let id = cell.postIdentifier.text
            let myVC = storyboard?.instantiateViewController(withIdentifier: "DetailsFlowViewController") as! DetailsFlowViewController
            myVC.theId = id
            navigationController?.pushViewController(myVC, animated: true)
        }
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


