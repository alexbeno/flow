//
//  customSearchViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 30/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class customSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var containerCollectionTagHeight: NSLayoutConstraint!
    @IBOutlet weak var containerCollectionTag: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var catBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tagArray = [TheTag]()
    var currentTagArray = [TheTag]()
    var seletedTagArray = [String]()
    var currentTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catBar.layer.shadowOpacity = 0.2
        catBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        catBar.layer.shadowColor = UIColor.black.cgColor
        setUpTags()
        setUpSearchBar()
        
    }
    
    private func setUpTags() {
        tagArray.append(TheTag(name: "style1", category: .style))
        tagArray.append(TheTag(name: "style2", category: .style))
        
        tagArray.append(TheTag(name: "sexe1", category: .sexe))
        tagArray.append(TheTag(name: "sexe2", category: .sexe))
        
        tagArray.append(TheTag(name: "marque1", category: .marque))
        tagArray.append(TheTag(name: "marque2", category: .marque))
        
        tagArray.append(TheTag(name: "général1", category: .general))
        tagArray.append(TheTag(name: "général2", category: .general))
        
        currentTagArray = tagArray
        
    }
    
    private func setUpSearchBar() {
        
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentTagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TheCell") as? addSearchBTableViewCell else {
            return UITableViewCell();
        }
        
        
        cell.tagBtn.setTitle(currentTagArray[indexPath.row].name, for: .normal)
        cell.tagBtn.addTarget(self, action: #selector(self.addTagButton(_:)), for: .touchUpInside)
        if currentTagArray[indexPath.row].TheTagSelected == true {
            cell.tagBtn.isEnabled = false
        } else {
            cell.tagBtn.isEnabled = true
        }
        return cell
        
    }
    
    // collection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(seletedTagArray.count > 0) {
            containerCollectionTagHeight.constant = 60
            self.view.layoutIfNeeded()
        } else {
            containerCollectionTagHeight.constant = 0
            self.view.layoutIfNeeded()
        }
        return seletedTagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as? AddTagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tagBtnClose.setTitle(seletedTagArray[indexPath.row], for: .normal)
        cell.tagBtnClose.addTarget(self, action: #selector(self.removeTagButton(_:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func addTagButton(_ sender:UIButton!) {
        if let text = sender?.titleLabel?.text {
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                if singleTag.name.contains(text) {
                    singleTag.TheTagSelected = true
                    seletedTagArray.append(text)
                    collectionView.reloadData()
                    print("current tag", currentTag)
                    changeTag()
                }
                return true
            })
        }
    }
    
    @objc func removeTagButton(_ sender:UIButton!) {
        if let text = sender?.titleLabel?.text {
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                if singleTag.name.contains(text) {
                    singleTag.TheTagSelected = false
                    seletedTagArray = seletedTagArray.filter { $0 != text }
                    collectionView.reloadData()
                    changeTag()
                }
                return true
            })
        }
    }
    
    //questionFrame.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
    
    // SEARCH
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        currentTagArray = tagArray.filter({ singleTag -> Bool in
            
            switch currentTag {
            case 0:
                if searchText.isEmpty {return true}
                return singleTag.name.localizedCaseInsensitiveContains(searchText)
            case 1:
                if searchText.isEmpty {return singleTag.category == .sexe}
                return singleTag.name.localizedCaseInsensitiveContains(searchText)  && singleTag.category == .sexe
            case 2:
                if searchText.isEmpty {return singleTag.category == .style}
                return singleTag.name.localizedCaseInsensitiveContains(searchText) && singleTag.category == .style
            case 3:
                if searchText.isEmpty {return singleTag.category == .marque}
                return singleTag.name.localizedCaseInsensitiveContains(searchText) && singleTag.category == .marque
            default:
                return false
            }
        })
        
        tableView.reloadData()
    }
    
    func changeTag() {
        switch currentTag {
        case 0:
            currentTagArray = tagArray
        case 1:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.sexe
            })
        case 2:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.style
            })
        case 3:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.marque
            })
        default:
            break
        }
        tableView.reloadData()
    }
    
    
    // all button
    @IBAction func allButtonAction(_ sender: Any) {
        currentTag = 0
        changeTag()
    }
    
    // sexe button
    @IBAction func sexeButtonAction(_ sender: Any) {
        currentTag = 1
        changeTag()
    }
    
    // style button
    @IBAction func styleButtonAction(_ sender: Any) {
        currentTag = 2
        changeTag()
    }
    
    // saison button
    @IBAction func saisonButtonAction(_ sender: Any) {
        currentTag = 3
        changeTag()
    }
    
    private func updateView() {
        print("view updated")
    }
    
}

class TheTag {
    let name: String
    let category: TagType
    var TheTagSelected: Bool
    
    init(name: String, category: TagType) {
        self.name = name
        self.category = category
        self.TheTagSelected = false
    }
}

enum TagType: String {
    case style = "style"
    case sexe = "sexe"
    case marque = "marque"
    case general = "general"
}
