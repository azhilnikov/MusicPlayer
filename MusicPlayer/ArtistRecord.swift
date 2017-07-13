//
//  ArtistRecord.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import Foundation

struct ArtistRecord {
    
    let name: String
    let album: String
    let song: String
    let imageURL: String
    let songURL: String
    
    init?(json: [String: Any]) {
        
        guard let name = json["artistName"] as? String else {
            return nil
        }
        
        guard let album = json["collectionName"] as? String else {
            return nil
        }
        
        guard let song = json["trackName"] as? String else {
            return nil
        }
        
        guard let imageURL = json["artworkUrl60"] as? String else {
            return nil
        }
        
        guard let songURL = json["previewUrl"] as? String else {
            return nil
        }
        
        self.name = name
        self.album = album
        self.song = song
        self.imageURL = imageURL
        self.songURL = songURL
    }
}
