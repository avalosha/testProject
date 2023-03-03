//
//  VideoCollectionViewCell.swift
//  testProject
//
//  Created by Sferea-Lider on 01/03/23.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    // Identifier
    static let identifier = "VideoCollectionViewCell"
    
    // Labels
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    private var playImageView: UIImageView?
    private let playImg = UIImage(named: "Icono_Play")
    private let pauseImg = UIImage(named: "Icono_Pausa")
    
    // UIView
    private let videoContainer = UIView()
    
    // Subviews
    public var player: AVPlayer?
    
    // Play
    public var playStatus: Bool = false {
        didSet {
            if playStatus {
                player?.play()
            } else {
                player?.pause()
            }
        }
    }
    
    // Model
    private var model: VideoReelModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.clipsToBounds = true
        addSubiews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        contentView.addSubview(videoContainer)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        videoContainer.clipsToBounds = true
        contentView.sendSubviewToBack(videoContainer)
        
        let imgView = UIImageView()
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        imgView.frame.size.width = 60
        imgView.frame.size.height = 60
        imgView.center = self.contentView.center
        imgView.image = playImg
        playImageView = imgView
        contentView.addSubview(playImageView!)
        contentView.bringSubviewToFront(playImageView!)
        playImageView?.isHidden = true
        
        contentView.addSubview(playImageView!)
        contentView.bringSubviewToFront(playImageView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContainer.frame = contentView.bounds
        
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height// - 100
        
        titleLabel.frame = CGRect(x: 30, y: height - 120, width: width - 60, height: 20)
        subTitleLabel.frame = CGRect(x: 30, y: height - 100, width: width - 60, height: 100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
        playStatus = false
    }
    
    public func configure(with model: VideoReelModel) {
        self.model = model
        configureVideo()
        
        titleLabel.text = model.title
        subTitleLabel.text = model.subtitle
    }
    
    private func configureVideo() {
        guard let model = self.model else { return }
        player = AVPlayer(url: URL(fileURLWithPath: model.videoURL))
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerView)
        player?.volume = 100
        playStatus = false
    }
    
    public func showPlayButton(with status: Bool) {
        playImageView?.image = status ? playImg : pauseImg
        playImageView?.fadeIn()
    }
}
