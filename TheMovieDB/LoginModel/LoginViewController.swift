//
//  LoginViewController.swift
//  TheMovieDB
//
//  Created by jianli on 4/5/22.
//

import UIKit

public class LoginViewController: UIViewController {
    let callBackViewController:UIViewController
    let userNameSaveKey:String
    
    public init(_ callBackViewController:UIViewController, _ userNameSaveKey:String){
        self.callBackViewController = callBackViewController
        self.userNameSaveKey = userNameSaveKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var inputField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Write your name here."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var loginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = UIButton.Configuration.filled()
        button.setTitle("Save", for: .normal)
        return button
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        loginButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(inputField)
        view.addSubview(loginButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            inputField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor,constant: -50),
            inputField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            inputField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 10),
            inputField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -10),
            loginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: inputField.bottomAnchor,constant: 10),
        ])
    }

    
    @objc private  func saveName(){
        
        //print("new: ",self.navigationController)
        let name = inputField.text
        if (name == nil) || (name!.count<3) {
            let alert = UIAlertController(title: "Alert", message: "Name should more than 3 Characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        UserDefaults.standard.set(name,forKey: userNameSaveKey)
        if let navigatioC = navigationController{
            navigatioC.pushViewController(callBackViewController, animated: true)
        }

        
        //let mainViewController = MainViewController()
        //mainViewController.modalPresentationStyle = .fullScreen
        //present(mainViewController,animated: true)
    }
}
