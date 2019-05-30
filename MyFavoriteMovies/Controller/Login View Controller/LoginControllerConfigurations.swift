//
//  Text Field Delegates Extensions.swift
//  Meme
//
//  Created by Mohamed Mohsen on 4/26/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation
import UIKit

//Text Field Delegates
extension LoginViewController{
    
    func enableUI(isEnabled: Bool){
        performUIUpdatesOnMain {
            self.loginBtn.isEnabled = isEnabled
        }
    }
    
    func configureUI() {
        configure(textLabel: debugTextLabel)
        debugTextLabel.isHidden = true
    }
    
    func configure(textLabel: UILabel) {
        textLabel.backgroundColor = UIConstants.BackgroundColors.textfieldBlackBG
        textLabel.textColor = UIConstants.BackgroundColors.textfieldBlackFG
    }
}
