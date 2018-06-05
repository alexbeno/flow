//
//  detailHomeViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase
import Kingfisher

class detailHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    var ContentArray = [SearchContent]()
    var CurrentArray = [SearchContent]()
    var selectedTag = [String: Any]()
    var alreadySort = [String]()
    var indexSorting = Int()
    var tagCount = Int()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tagCount = selectedTag.count
        for (key, value) in selectedTag {
            setDatabase(key: key)
        }
    }
    
    private func setDatabase(key: String) {
        let ref = Database.database().reference()
        let postRef = ref.child("posts")
        var alreadySortBool = false
        postRef.queryOrdered(byChild: "tags/" + key).queryStarting(atValue: 0).observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                if alreadySortBool == false {
                    alreadySortBool = true
                    self.indexSorting += 1
                    self.alreadySort.append(key)
                }
                var toShow = true
                let link = snapshot.key
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                let tagsArray = dict["tags"] as! [String: Any]
                

                for i in 0...self.tagCount {
                    if self.indexSorting == 1 {
                        print("#first Sorte")
                    } else {
                        for (key, value) in tagsArray {
                            if self.alreadySort[self.indexSorting - 2] == key {
                                toShow = false
                            } else {
                                //
                            }
                        }
                    }
                }
                
                if toShow == true {
                    self.ContentArray.append(SearchContent(image: image, link: link, numberOfLike: numberOfLike ))
                    self.CurrentArray = self.ContentArray
                    self.collectionView.reloadData()
                } else {
                     print("#error already sort")
                }
            }
            
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 260
        return CGSize(width: collectionView.bounds.size.width/2.1, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? searchResultCollectionViewCell {
            let id = cell.postIdentifier.text
            let myVC = storyboard?.instantiateViewController(withIdentifier: "DetailsFlowViewController") as! DetailsFlowViewController
            myVC.theId = id
            navigationController?.pushViewController(myVC, animated: true)
        }
    }

}

class SearchContent {
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
