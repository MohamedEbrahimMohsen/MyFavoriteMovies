//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/6/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableUI(isEnabled: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: Login
    @IBAction func loginPressed(_ sender: UIButton) {
        enableUI(isEnabled: false)
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            print("Success - Login")
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.display(error: errorString!)
                }
            }
            print("Success - Login")
            self.enableUI(isEnabled: true)
        }
        //enableUI(isEnabled: true)
    }
    
    // MARK: Complete Login
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}



