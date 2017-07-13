//
//  MusicPlayerProtocol.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import Foundation

enum MusicPlayerResult: Error {
    case success
    case failure(String)
}

enum ArtistRecordError: Error {
    case missing(String)
}

protocol MusicPlayerDataProviderDelegate: class {
    func didSelectCell(oldCellRow: Int?)
    func didFinishPlaying()
}

protocol MusicPlayerViewDelegate: class {
    func didPlayButtonTapped()
    func didPauseButtonTapped()
}

protocol MusicPlayerDelegate: class {
    func playerDidFinishPlaying()
}
