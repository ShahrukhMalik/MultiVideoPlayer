//
//  PlayerView.swift
//  MultiVideoPlayer
//
//  Created by Shah Rukh Malik on 11/9/19.
//  Copyright © 2019 Shah Rukh Malik. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
