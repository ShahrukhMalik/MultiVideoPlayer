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
    
    @IBOutlet weak var firstPlayerRestartButton: UIButton!
    @IBOutlet weak var secondPlayerRestartButton: UIButton!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create player instances
        firstPlayerView.player = createPlayerForVideo(name: "1", format: "mp4")
        secondPlayerView.player = createPlayerForVideo(name: "2", format: "mp4")
        
        // Play videos
        firstPlayerView.player?.play()
        secondPlayerView.player?.play()
        
        // Registering playback end notifications
        NotificationCenter.default.addObserver(self, selector: #selector(playerOneDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: firstPlayerView.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerTwoDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: secondPlayerView.player?.currentItem)
    }
    
    
    // MARK: - Action methods
    
    @IBAction func filterActionButtonTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        let blurAction = UIAlertAction(title: "Gausian Blur", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            weakSelf!.applyFilterToVideos(filter: "CIGaussianBlur")
        })

        let holeAction = UIAlertAction(title: "Hole Distortion", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            weakSelf!.applyFilterToVideos(filter: "CIHoleDistortion")
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(blurAction)
        optionMenu.addAction(holeAction)
        
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func firstPlayerRestartButtonTapped(_ sender: Any) {
        firstPlayerRestartButton.isHidden = true
        firstPlayerView.player = createPlayerForVideo(name: "1", format: "mp4")
        firstPlayerView.player?.seek(to: CMTime.zero)
        firstPlayerView.player?.play()
        firstPlayerSoundButton.setImage(UIImage.init(named: "Sound"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(playerOneDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: firstPlayerView.player?.currentItem)
    }
    
    @IBAction func secondPlayerRestartButtonTapped(_ sender: Any) {
        secondPlayerRestartButton.isHidden = true
        secondPlayerView.player = createPlayerForVideo(name: "2", format: "mp4")
        secondPlayerView.player?.seek(to: CMTime.zero)
        secondPlayerView.player?.play()
        secondPlayerSoundButton.setImage(UIImage.init(named: "Sound"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(playerTwoDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: secondPlayerView.player?.currentItem)
    }
    
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
    
    private func applyFilterToAssetForPlayer(asset: AVAsset, filterName: String, player: AVPlayer) {
        let filter = CIFilter(name: filterName)!
        
        let item = player.currentItem
        item!.videoComposition = AVVideoComposition(asset: asset,  applyingCIFiltersWithHandler: { request in

            // Clamp to avoid blurring transparent pixels at the image edges
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)

            // Vary filter parameters based on video timing
            let seconds = CMTimeGetSeconds(request.compositionTime)
            filter.setValue(seconds * 10.0, forKey: kCIInputRadiusKey)

            // Crop the blurred output to the bounds of the original image
            let output = filter.outputImage!.cropped(to: request.sourceImage.extent)

            // Provide the filter output to the composition
            request.finish(with: output, context: nil)
        })
    }
    
    private func createPlayerForVideo(name: String, format: String) -> AVPlayer {
        let path = Bundle.main.path(forResource: name, ofType:format)!
        return AVPlayer(url: URL(fileURLWithPath: path))
    }
    
    private func applyFilterToVideos(filter: String) {
        // Apply filter to first video
        let path1 = Bundle.main.path(forResource: "1", ofType:"mp4")
        let asset1 = AVAsset(url: URL(fileURLWithPath: path1!))
        self.applyFilterToAssetForPlayer(asset: asset1, filterName: filter, player: self.firstPlayerView.player!)
        
        // Apply filter to second video
        let path2 = Bundle.main.path(forResource: "2", ofType:"mp4")
        let asset2 = AVAsset(url: URL(fileURLWithPath: path2!))
        self.applyFilterToAssetForPlayer(asset: asset2, filterName: filter, player: self.secondPlayerView.player!)
    }
    
    @objc func playerOneDidFinishPlaying() {
        firstPlayerRestartButton.isHidden = false
    }
    
    @objc func playerTwoDidFinishPlaying() {
        secondPlayerRestartButton.isHidden = false
    }
}
