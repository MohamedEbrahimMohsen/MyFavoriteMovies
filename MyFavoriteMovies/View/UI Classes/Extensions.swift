//
//  Extensions.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/11/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    override open var isEnabled : Bool {
        willSet{
            if newValue == false {
                self.setTitleColor(.gray, for: .disabled)
            }
        }
    }
}
