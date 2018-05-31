//
//  addStepViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 27/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class addStepViewController: UIViewController {

    var theImage: UIImage?
    
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewImage.image = theImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
