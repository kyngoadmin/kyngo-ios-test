//
//  Library.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class Library {
    var allAlbums = [Album]()
    var allPhotos = [Photo]()
    var albums = [Album]()
    var photos = [Photo]()
    
    var currentAlbumId: Int!
    
    func updateAlbums() {
        albums = allAlbums.filter({ $0.userId == AppState.sharedInstance.currentUserId })
    }
    
    func updatePhotos() {
        photos = allPhotos.filter({ $0.albumId == currentAlbumId })
    }
}