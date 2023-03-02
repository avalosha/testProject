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
    
    // UIView
    private let videoContainer = UIView()
    
    // Subviews
    var player: AVPlayer?
    
    // Model
    private var model: VideoReelModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContainer.frame = contentView.bounds
        
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height - 100
        
        titleLabel.frame = CGRect(x: 10, y: height-60, width: width-20, height: 20)
        subTitleLabel.frame = CGRect(x: 10, y: height-40, width: width-20, height: 100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
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
        player?.play()
    }
}
