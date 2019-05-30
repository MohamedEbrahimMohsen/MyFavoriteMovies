//
//  ErrorHandling.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/12/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController{    
    func display(error: String){
        DispatchQueue.main.async {
            self.enableUI(isEnabled: true)
            self.debugTextLabel.text = error
        }
    }
    
    func display(message: String){
        DispatchQueue.main.async {
            self.debugTextLabel.text = message
        }
    }
}
