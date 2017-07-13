//
//  RotatingImageView.swift
//  MusicPlayer
//
//  Created by Alexey on 13/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class RotatingImageView: UIImageView {

    private let kAnimationKey = "rotation"
    
    func startRotation(duration: Double = 1) {
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float.pi * 2
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotation() {
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
