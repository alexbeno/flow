//
//  tabBarView.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 24/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class tabBarView: UIView {
    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("tabBarView", owner: self, options: nil)
        self.addSubview(self.view)
    }

}
