//
//  PlayerView.swift
//  testProject
//
//  Created by miniMAC Sferea on 02/09/21.
//

import UIKit
import AVKit

class KekPlayerLayer: AVPlayerLayer {
    
    @objc func setPlaceholderContentLayerDuringPIPMode(_ contentLayer: CALayer) {
        print()
    }
    
}

class PlayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}
