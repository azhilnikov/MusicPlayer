//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by Alexey on 9/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class MusicPlayerView: UIView {
    
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var button: UIButton!
    
    weak var delegate: MusicPlayerViewDelegate?
    
    var isVisible: Bool {
        if let height = heightConstraint?.constant {
            return Int(height) > 0
        }
        return false
    }
    
    var isPlaying = true {
        willSet {
            // Change image on the button
            if newValue {
                button.setImage(UIImage(named: "Pause"), for: .normal)
                button.setImage(UIImage(named: "PauseFilled"), for: .highlighted)
            } else {
                button.setImage(UIImage(named: "Play"), for: .normal)
                button.setImage(UIImage(named: "PlayFilled"), for: .highlighted)
            }
        }
    }
    
    private let height: CGFloat = 50
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Make view visible
    func show() {
        heightConstraint?.constant = height
        UIView.animate(withDuration: 1, animations: {
            self.layoutIfNeeded()
        })
    }
    
    // MARK: - Action
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isPlaying = !isPlaying
        if isPlaying {
            delegate?.didPlayButtonTapped()
        } else {
            delegate?.didPauseButtonTapped()
        }
    }
}
