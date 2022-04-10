//
//  EntryNavigationController.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import UIKit
import LoginModel

class EntryNavigationController:UINavigationController{
    override func viewDidLoad() {
        isNavigationBarHidden = true
        let mainViewController = MainViewController()
        pushViewController(LoginViewController(mainViewController,userNameSaveKey), animated: false)
        let name = UserDefaults.standard.string(forKey: userNameSaveKey)
        if name != nil{
            pushViewController(mainViewController, animated: false)
        }
        print(viewControllers)
    }
    
}
