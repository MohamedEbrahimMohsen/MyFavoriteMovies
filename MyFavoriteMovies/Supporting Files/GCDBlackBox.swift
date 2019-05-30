//
//  GCDBlackBox.swift
//  MyFavoriteMovies
//
//  Created by Mohamed Mohsen on 5/26/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
