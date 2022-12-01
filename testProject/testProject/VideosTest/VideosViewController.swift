//
//  VideosViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 12/08/22.
//

import UIKit

class VideosViewController: UIViewController {

    private var url: String?
    
    private var videos: [VideoModel] = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let video1 = VideoModel(image: UIImage(named: "video1")!, id: "https://www.youtube.com/watch?v=me19SUmWu2s")
        let video2 = VideoModel(image: UIImage(named: "video2")!, id: "https://www.youtube.com/watch?v=2BabCBQysrU")
        let video3 = VideoModel(image: UIImage(named: "video3")!, id: "https://www.youtube.com/watch?v=hVDgAhIOelA")
        let video4 = VideoModel(image: UIImage(named: "video4")!, id: "https://www.youtube.com/watch?v=0cETy4A4nEY")
        let video5 = VideoModel(image: UIImage(named: "video5")!, id: "https://www.youtube.com/watch?v=G56XvqUWOd0")
        
        videos.append(video1)
        videos.append(video2)
        videos.append(video3)
        videos.append(video4)
        videos.append(video5)
            }
    
    private func openPlayer(with id: String) {
        let story = UIStoryboard(name: "YouTubePlayer", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "YoutubePlayerID") as?  YouTubeViewController {
            vc.urlVideo = id
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickVideo1(_ sender: Any) {
        openPlayer(with: videos[0].id)
    }
    
    @IBAction func onClickVideo2(_ sender: Any) {
        openPlayer(with: videos[1].id)
    }
    
    @IBAction func onClickVideo3(_ sender: Any) {
        openPlayer(with: videos[2].id)
    }
}

