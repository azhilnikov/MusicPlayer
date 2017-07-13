//
//  MusicPlayerTableViewCell.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import UIKit

enum MusicPlayerTableViewCellStatus {
    case stopped
    case paused
    case playing
}

class MusicPlayerTableViewCell: UITableViewCell {

    @IBOutlet private var artistIcon: UIImageView!
    @IBOutlet private var songLabel: UILabel!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var albumLabel: UILabel!
    @IBOutlet private var rotatingImage: RotatingImageView!
    
    var record: ArtistRecord? {
        willSet {
            // Set artist's data
            songLabel?.text = newValue?.song
            artistLabel?.text = newValue?.name
            albumLabel?.text = newValue?.album
        }
    }
    
    var imageData: Data? {
        willSet {
            if let data = newValue {
                // Set icon image
                artistIcon?.image = UIImage(data: data)
            }
        }
    }
    
    var status = MusicPlayerTableViewCellStatus.stopped {
        willSet {
            // Update rotating image
            switch newValue {
            case .stopped:
                rotatingImage?.isHidden = true
                rotatingImage?.stopRotation()
                
            case .paused:
                rotatingImage?.isHidden = false
                rotatingImage?.stopRotation()
                
            case .playing:
                rotatingImage?.isHidden = false
                rotatingImage?.startRotation()
            }
        }
    }
}
