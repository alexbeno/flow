//
//  mainHeader.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 24/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class mainHeader: UIView {
    
    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       Bundle.main.loadNibNamed("mainHeader", owner: self, options: nil)
        self.addSubview(self.view)
    }

}
