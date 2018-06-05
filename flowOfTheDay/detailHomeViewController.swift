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

class detailHomeViewController: UIViewController {

    var ContentArray = [SearchContent]()
    var CurrentArray = [SearchContent]()
    var selectedTag = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(selectedTag)
        setDatabase()
    }
    
    private func setDatabaseExemple() {
        ProgressHUD.show("waiting..", interaction: false)
        Database.database().reference().child("posts").observe(.childAdded, with:{ (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let link = snapshot.key
                let image = dict["photoUrl"] as! String
                let numberOfLike = dict["rate"] as! Int
                let day = dict["toShow"] as! Bool
                if day == true {
                    self.ContentArray.append(SearchContent(image: image, link: link, numberOfLike: numberOfLike ))
                    self.CurrentArray = self.ContentArray
                }
            }
            ProgressHUD.showSuccess("success")
        })
    }
    private func setDatabase() {
        let ref = Database.database().reference()
        let postRef = ref.child("posts")
//        postRef.queryOrdered(byChild: "tags").queryStarting(atValue: 0).query.observe(.childAdded, with:{ (snapshot: DataSnapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                print("#sucess", dict)
//            }
//            
//        })
    }
    
    //     //    .startAt('kato@firebase.com')
//    .endAt('kato@firebase.com')
//    .once('value', show);

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
