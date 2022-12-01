//
//  ViewController.swift
//  testProject
//
//  Created by miniMAC Sferea on 02/09/21.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var pipButton: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    
    let urls = ["https://www.youtube.com/embed/Qa1zijvVpvc?playsinline=1","https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
                "https://video.twimg.com/ext_tw_video/1110679043915935745/pu/vid/720x1280/6OeRxCMr3tYaDNLB.mp4?tag=8"]
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    private var pictureInPictureController: AVPictureInPictureController!
    
    var pipPossibleObservation: NSKeyValueObservation?
    private var pictureInPictureObservations = [NSKeyValueObservation]()
    
    private var strongSelf: Any?
    
    deinit {
        // without this line vanilla AVPictureInPictureController will crash due to KVO issue
        pictureInPictureObservations = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage(compatibleWith: nil)
//        let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage(compatibleWith: nil)
//
//        pipButton.setImage(startImage, for: .normal)
//        pipButton.setImage(stopImage, for: .selected)
        
        
        
//        let videoURL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")
//        self.player = AVPlayer(url: videoURL!)
//        self.playerViewController = AVPlayerViewController()
//        playerViewController.player = self.player
//        playerViewController.view.frame = self.playerView.frame
//        playerViewController.player?.play()
//        self.playerView.addSubview(playerViewController.view)
        
        let videoURL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")
//        let videoURL = URL(string: "https://www.youtube.com/watch?v=me19SUmWu2s")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = self.playerView.frame
//        self.playerView.addSubview(playerViewController.view)
//        self.view.addSubview(playerViewController.view)
        self.addChild(playerViewController)
        playerViewController.player!.play()
        
//        if let url = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4") {
//            let player = AVPlayer(url: url)
//            let avController = AVPlayerViewController()
//            avController.player = player
//            // your desired frame
//            avController.view.frame = self.playerView.frame
//            self.view.addSubview(avController.view)
//            self.addChild(avController)
//            player.play()
//        }
        
//        let videoURL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.pause()
        
//        player = constructPlayer()
        
        playerView.playerLayer.player = player
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPictureInPicture()
        player?.play()
    }
    
    func constructPlayer() -> AVPlayer {
        let playerItems = urls.compactMap(URL.init(string:)).map(AVPlayerItem.init)
        
        return AVQueuePlayer(items: playerItems)
    }

    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
//        if AVPictureInPictureController.isPictureInPictureSupported() {
//            // Create a new controller, passing the reference to the AVPlayerLayer.
//            let playerLayer = AVPlayerLayer(player: player)
//            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)!
//            pictureInPictureController.delegate = self
//
//            pipPossibleObservation = pictureInPictureController.observe(\AVPictureInPictureController.isPictureInPicturePossible,
//                                                                        options: [.initial, .new]) { [weak self] _, change in
//                // Update the PiP button's enabled state.
//                self?.pipButton.isEnabled = change.newValue ?? false
//            }
//        } else {
//            // PiP isn't supported by the current device. Disable the PiP button.
//            pipButton.isEnabled = false
//        }
        
        pipButton.setImage(AVPictureInPictureController.pictureInPictureButtonStartImage(compatibleWith: nil), for: .normal)
        pipButton.setImage(AVPictureInPictureController.pictureInPictureButtonStopImage(compatibleWith: nil), for: .selected)
        pipButton.setImage(AVPictureInPictureController.pictureInPictureButtonStopImage(compatibleWith: nil), for: [.selected, .highlighted])
        
//        let playerLayer = AVPlayerLayer(player: player)
        
        guard AVPictureInPictureController.isPictureInPictureSupported(),
            let pictureInPictureController = AVPictureInPictureController(playerLayer: playerView.playerLayer) else {
                
            pipButton.isEnabled = false
                return
        }
        
        self.pictureInPictureController = pictureInPictureController
        pictureInPictureController.delegate = self
        pipButton.isEnabled = pictureInPictureController.isPictureInPicturePossible
        
        pictureInPictureObservations.append(pictureInPictureController.observe(\.isPictureInPictureActive) { [weak self] pictureInPictureController, change in
            guard let `self` = self else { return }
            
            self.pipButton.isSelected = pictureInPictureController.isPictureInPictureActive
        })
        
        pictureInPictureObservations.append(pictureInPictureController.observe(\.isPictureInPicturePossible) { [weak self] pictureInPictureController, change in
            guard let `self` = self else { return }
            
            self.pipButton.isEnabled = pictureInPictureController.isPictureInPicturePossible
        })

    }
    
    @IBAction func enablePip(_ sender: Any) {
        print("CLICK")
        if pipButton.isSelected {
            pictureInPictureController.stopPictureInPicture()
        } else {
            pictureInPictureController.startPictureInPicture()
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
//        player.play()
    }
    
}

extension ViewController: AVPictureInPictureControllerDelegate {
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        // Restore user interface
        completionHandler(true)
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide playback controls
        // show placeholder artwork
        print("START")
        strongSelf = self
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide placeholder artwork
        // show playback controls
        print("STOP")
        strongSelf = nil
    }
}
