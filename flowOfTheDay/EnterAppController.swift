//
//  EnterAppController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 26/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit
import Firebase


class EnterAppController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // sign Out
//         try! Auth.auth().signOut()
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
    

}
