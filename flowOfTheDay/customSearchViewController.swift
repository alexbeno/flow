//
//  customSearchViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 30/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import Firebase
import UIKit
import ProgressHUD

protocol SendTagToParent {
    func loadTags(tagsArray: Array <String>)
}


class customSearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDataSource{
    
    var delegate: SendTagToParent?
    
     // MARK: outlet
    
    @IBOutlet weak var sexeButtonTag: UIButton!
    @IBOutlet weak var allButtonTag: UIButton!
    @IBOutlet weak var styleButtonTag: UIButton!
    @IBOutlet weak var marqueButtonTag: UIButton!
    
    @IBOutlet weak var containerCollectionTagHeight: NSLayoutConstraint!
    @IBOutlet weak var containerCollectionTag: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var catBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: colors
    let colorBlack = UIColor(red:0, green:0, blue:0, alpha:1.0)
    let colorGrey = UIColor(red:0.718, green:0.718, blue:0.718, alpha:1.0)
    
    // MARK: variable
    var tagArray = [TheTag]()
    var currentTagArray = [TheTag]()
    var seletedTagArray = [String]()
    var tagSender = [String]()
    var currentTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        catBar.layer.shadowOpacity = 0.2
        catBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        catBar.layer.shadowColor = UIColor.black.cgColor
        setDatabase()
//        setUpTags()
        setUpSearchBar()
        
    }
    
    // MARK: setUp
    
    private func setDatabase() {

        ProgressHUD.show("waiting..", interaction: false)
        Database.database().reference().child("tag").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                for (_, tagsName) in dict["marque"] as! [String: Any] {
                    self.tagArray.append(TheTag(name: tagsName as! String, category: .marque))
                }
                for (_, tagsName) in dict["style"] as! [String: Any] {
                    self.tagArray.append(TheTag(name: tagsName as! String, category: .style))
                }
                for (_, tagsName) in dict["sexe"] as! [String: Any] {
                    self.tagArray.append(TheTag(name: tagsName as! String, category: .sexe))
                }
                for (_, tagsName) in dict["other"] as! [String: Any] {
                    self.tagArray.append(TheTag(name: tagsName as! String, category: .general))
                }
                
                ProgressHUD.showSuccess("success")
                self.currentTagArray = self.tagArray
                self.tableView.reloadData()
            }
        })
    }
    
    // to delete
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
    
    // MARK: searchBar
    
    private func setUpSearchBar() {
        
        searchBar.delegate = self
        let scb = searchBar
        
        if let textfield = scb?.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                backgroundview.alpha = 0.15
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;

            }
        }
        
        if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.barTintColor = UIColor.black
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: table&collection
    
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
        
        if currentTagArray[indexPath.row].TheTagSelected == true {
            cell.tagBtn.alpha = 0.30
        } else {
            cell.tagBtn.alpha = 1
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
//        cell.tagBtnClose.addTarget(self, action: #selector(self.removeTagButton(_:)), for: .touchUpInside)
        return cell
        
    }
    
    
    // MARK: search-&-tag
    
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
            break
        case 1:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.sexe
            })
            break
        case 2:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.style
            })
            break
        case 3:
            currentTagArray = tagArray.filter({ singleTag -> Bool in
                singleTag.category == TagType.marque
            })
            break
        default:
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - Action methods
    
    
    // all button
    @IBAction func allButtonAction(_ sender: Any) {
        currentTag = 0
        changeTag()
        allButtonTag.setTitleColor(colorBlack, for: .normal)
        sexeButtonTag.setTitleColor(colorGrey, for: .normal)
        styleButtonTag.setTitleColor(colorGrey, for: .normal)
        marqueButtonTag.setTitleColor(colorGrey, for: .normal)

    }
    
    // sexe button
    @IBAction func sexeButtonAction(_ sender: Any) {
        currentTag = 1
        changeTag()
        allButtonTag.setTitleColor(colorGrey, for: .normal)
        sexeButtonTag.setTitleColor(colorBlack, for: .normal)
        styleButtonTag.setTitleColor(colorGrey, for: .normal)
        marqueButtonTag.setTitleColor(colorGrey, for: .normal)
    }
    
    // style button
    @IBAction func styleButtonAction(_ sender: Any) {
        currentTag = 2
        changeTag()
        allButtonTag.setTitleColor(colorGrey, for: .normal)
        sexeButtonTag.setTitleColor(colorGrey, for: .normal)
        styleButtonTag.setTitleColor(colorBlack, for: .normal)
        marqueButtonTag.setTitleColor(colorGrey, for: .normal)
    }
    
    // saison button
    @IBAction func saisonButtonAction(_ sender: Any) {
        currentTag = 3
        changeTag()
        allButtonTag.setTitleColor(colorGrey, for: .normal)
        sexeButtonTag.setTitleColor(colorGrey, for: .normal)
        styleButtonTag.setTitleColor(colorGrey, for: .normal)
        marqueButtonTag.setTitleColor(colorBlack, for: .normal)
    }
    
    private func updateView() {
        print("view updated")
    }
    
    @IBAction func valideTagButton(_ sender: Any) {
        tagSender = seletedTagArray
        
        // checks to see if the delegate exists
        delegate?.loadTags(tagsArray: tagSender)
        
        // removed view from stack
        navigationController?.popViewController(animated: true)
    }
}

extension customSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? addSearchBTableViewCell {
            if let text = cell.tagBtn?.title(for: .normal   ) {
                
                let allSelectedTags = tagArray.filter { singleTag in
                    return singleTag.name == text
                }
                
                if let selectedTag = allSelectedTags.first {
                    if !selectedTag.TheTagSelected {
                        selectedTag.TheTagSelected = true
                        seletedTagArray.append(text)
                        collectionView.reloadData()
                        tableView.reloadData()
                    }
                    
                    tableView.deselectRow(at: indexPath, animated: true)
                    
                }
            
            }
        }
    }
}

extension customSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AddTagCollectionViewCell {
            if let text = cell.tagBtnClose?.title(for: .normal) {
                
                let allSelectedTags = tagArray.filter { singleTag in
                    return singleTag.name == text
                }
                
                if let selectedTag = allSelectedTags.first {
                    if selectedTag.TheTagSelected {
                        selectedTag.TheTagSelected = false
                        seletedTagArray = seletedTagArray.filter { $0 != text }
                        collectionView.reloadData()
                        tableView.reloadData()
                    }
                    
                    tableView.deselectRow(at: indexPath, animated: true)
                    
                }
                
            }
        }
    }
}

// MARK: TagClass

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
