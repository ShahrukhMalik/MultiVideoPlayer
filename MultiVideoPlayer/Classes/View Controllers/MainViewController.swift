//
//  MainViewController.swift
//  MultiVideoPlayer
//
//  Created by Shah Rukh Malik on 11/9/19.
//  Copyright © 2019 Shah Rukh Malik. All rights reserved.
//

import UIKit
import AVKit

class MainViewController: UIViewController {

    @IBOutlet weak var firstPlayerView: PlayerView!
    @IBOutlet weak var secondPlayerView: PlayerView!
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create player instances
        firstPlayerView.player = createPlayerForVideo(name: "1", format: "mp4")
        secondPlayerView.player = createPlayerForVideo(name: "2", format: "mp4")
        
        // Play videos
        firstPlayerView.player?.play()
        secondPlayerView.player?.play()
    }
    
    
    // MARK: - Private methods
    
    private func createPlayerForVideo(name: String, format: String) -> AVPlayer {
        let path = Bundle.main.path(forResource: name, ofType:format)!
        return AVPlayer(url: URL(fileURLWithPath: path))
    }
}
