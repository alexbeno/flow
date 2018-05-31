//
//  ViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 23/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var sectionTabView: UIView!
    @IBOutlet weak var bestButtonEl: UIButton!
    @IBOutlet weak var newButtonEl: UIButton!
    @IBOutlet weak var hovertopBarLeft: NSLayoutConstraint!
    @IBOutlet weak var hovertopBarWidth: NSLayoutConstraint!
    
    let colorWhite = UIColor(red:1, green:1, blue:1, alpha:1.0)
    let colorBlack = UIColor(red:0, green:0, blue:0, alpha:1.0)
    let colorGrey = UIColor(red:0.718, green:0.718, blue:0.718, alpha:1.0)
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // shadow on sectionTabView
        sectionTabView.layer.shadowOpacity = 0.2
        sectionTabView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        sectionTabView.layer.shadowColor = UIColor.black.cgColor
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bestButtonAction(_ sender: Any) {
        bestButtonEl.setTitleColor(colorBlack, for: .normal)
        newButtonEl.setTitleColor(colorGrey, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.hovertopBarLeft.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func newButtonAction(_ sender: Any) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        bestButtonEl.setTitleColor(colorGrey, for: .normal)
        newButtonEl.setTitleColor(colorBlack, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.hovertopBarLeft.constant = screenWidth / 2
            self.view.layoutIfNeeded()
        })
    }
}

