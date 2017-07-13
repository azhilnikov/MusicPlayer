//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Alexey on 11/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import AVFoundation

class MusicPlayer: NSObject {
    
    weak var delegate: MusicPlayerDelegate?
    
    fileprivate var audioPlayer: AVAudioPlayer?
    
    func play(_ data: Data?) {
        if let player = audioPlayer {
            // Resume previously paused song
            player.play()
        } else if let song = data, let player = try? AVAudioPlayer(data: song) {
            // Play new song
            player.prepareToPlay()
            player.play()
            player.delegate = self
            audioPlayer = player
        }
    }
    
    func stop(shouldPause: Bool) {
        if shouldPause {
            audioPlayer?.pause()
        } else {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
}

extension MusicPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.playerDidFinishPlaying()
    }
}
