//
//  ArtistRecordCellData.swift
//  MusicPlayer
//
//  Created by Alexey on 10/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import Foundation

class ArtistRecordCellData {
    
    let artistRecord: ArtistRecord
    var imageData: Data?
    var imageTask: URLSessionDataTask?
    var songData: Data?
    var songTask: URLSessionDataTask?
    var status: MusicPlayerTableViewCellStatus
    
    init(record: ArtistRecord) {
        self.artistRecord = record
        self.imageData = nil
        self.imageTask = nil
        self.songData = nil
        self.songTask = nil
        self.status = .stopped
    }
}
