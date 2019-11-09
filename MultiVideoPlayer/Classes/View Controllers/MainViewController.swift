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
    
    @IBOutlet weak var firstPlayerSoundButton: UIButton!
    @IBOutlet weak var secondPlayerSoundButton: UIButton!
    
    
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
    
    // MARK: - Action methods
    
    @IBAction func firstPlayerSoundToggleAction(_ sender: Any) {
        
        if firstPlayerView.player!.isMuted {
            firstPlayerSoundButton.setImage(UIImage.init(named: "Sound"), for: .normal)
            
        } else {
            firstPlayerSoundButton.setImage(UIImage.init(named: "Mute"), for: .normal)
        }
        
        firstPlayerView.player?.isMuted = !firstPlayerView.player!.isMuted
    }
    
    @IBAction func secondPlayerSoundToggleAction(_ sender: Any) {
        
        if secondPlayerView.player!.isMuted {
            secondPlayerSoundButton.setImage(UIImage.init(named: "Sound"), for: .normal)
            
        } else {
            secondPlayerSoundButton.setImage(UIImage.init(named: "Mute"), for: .normal)
        }
        
        secondPlayerView.player?.isMuted = !secondPlayerView.player!.isMuted
    }
    
    
    // MARK: - Private methods
    
    private func createPlayerForVideo(name: String, format: String) -> AVPlayer {
        let path = Bundle.main.path(forResource: name, ofType:format)!
        return AVPlayer(url: URL(fileURLWithPath: path))
    }
}
