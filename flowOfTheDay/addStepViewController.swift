//
//  addStepViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class addStepViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SendTagToParent {
    
    
    var theImage: UIImage?
    var selectedTag = [String]()
    
    @IBOutlet weak var addFlowButtonEL: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerCollectionTagHeight: UIView!
    @IBOutlet weak var containerCollectionConstant: NSLayoutConstraint!
    
    func loadTags(tagsArray: Array <String>) {
        selectedTag = tagsArray
        collectionView.reloadData()
    }
    
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewImage.image = theImage
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
        
        cell.tagButtonSetp.setTitle(selectedTag[indexPath.row], for: .normal)
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTagNewFlow" {
            let destinationVC = segue.destination as! customSearchViewController
            
            destinationVC.delegate = self
        }
    }
}
