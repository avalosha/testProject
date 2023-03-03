//
//  ReelsViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 01/03/23.
//

import UIKit

struct VideoReelModel {
    let title: String
    let subtitle: String
    let videoURL: String
}

//MARK: - New Instance
extension ReelsViewController {
    /// Retorna una nueva instancia de la clase  ReelsViewController
    /// - Returns: Instancia de  ReelsViewController
    static func newInstance(selectTerms: Bool = false) -> ReelsViewController? {
        let vc = ReelsViewController()
        return vc
    }
}

class ReelsViewController: UIViewController {

    private var collectionView: UICollectionView?
    private var backButton: UIButton?
    private var shareButton: UIButton?
    private var data = [VideoReelModel]()
    let urlVideo = ["https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
                    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"]
    let titles = ["Big Buck Bunny",
                  "Elephant Dream",
                  "For Bigger Blazes",
                  "For Bigger Escape",
                  "For Bigger Fun",
                  "For Bigger Joyrides",
                  "For Bigger Meltdowns",
                  "Sintel",
                  "Subaru Outback On Street And Dirt",
                  "Tears of Steel",
                  "Volkswagen GTI Review",
                  "We Are Going On Bullrun",
                  "What care can you get for a grand?"]
    let subtitles = ["Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
                     "The first Blender Open Movie from 2006",
                     "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.",
                     "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For $35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast.",
                     "Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For $35.  Find out more at google.com/chromecast.",
                     "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for the times that call for bigger joyrides. For $35. Learn how to use Chromecast with YouTube and more at google.com/chromecast.",
                     "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when you want to make Buster's big meltdowns even bigger. For $35. Learn how to use Chromecast with Netflix and more at google.com/chromecast.",
                     "Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. With initial funding provided by 1000s of donations via the internet community, it has again proven to be a viable development model for both open 3D technology as for independent animation film.\nThis 15 minute film has been realized in the studio of the Amsterdam Blender Institute, by an international team of artists and developers. In addition to that, several crucial technical and creative targets have been realized online, by developers and artists and teams all over the world.\nwww.sintel.org",
                     "Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers.",
                     "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands.  The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras.  (CC) Blender Foundation - http://www.tearsofsteel.org",
                     "The Smoking Tire heads out to Adams Motorsports Park in Riverside, CA to test the most requested car of 2010, the Volkswagen GTI. Will it beat the Mazdaspeed3's standard-setting lap time? Watch and see...",
                     "The Smoking Tire is going on the 2010 Bullrun Live Rally in a 2011 Shelby GT500, and posting a video from the road every single day! The only place to watch them is by subscribing to The Smoking Tire or watching at BlackMagicShine.com",
                     "The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car."]
    
    private var currentIndex = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<10 {
            let model = VideoReelModel(title: titles[index], subtitle: subtitles[index], videoURL: urlVideo[index])
            data.append(model)
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView?.isPagingEnabled = true
        collectionView?.clipsToBounds = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
        
        let back = UIButton()
        back.frame = CGRectMake(25, 45, 40, 40)
        back.setBackgroundImage(UIImage(named: "Icon_Back"), for: .normal)
        back.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        backButton = back
        view.addSubview(backButton!)
        view.bringSubviewToFront(backButton!)
        
        let share = UIButton()
        share.frame = CGRectMake(self.view.frame.width - 65, 45, 40, 40)
        share.setBackgroundImage(UIImage(named: "Icono_Compartir"), for: .normal)
        share.addTarget(self, action: #selector(shareTo), for: .touchUpInside)
        shareButton = share
        view.addSubview(shareButton!)
        view.bringSubviewToFront(shareButton!)
    }
    
    deinit {
        NSLog ("ReelsViewController deinit called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.setContentOffset(CGPoint.zero, animated: false)
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? VideoCollectionViewCell {
            cell.playStatus = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    @objc private func backTo() {
        self.dismiss(animated: true)
    }
    
    @objc private func shareTo() {
        print("Compartir ...")
    }

}

extension ReelsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        let model = data[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex == indexPath {
            if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell {
                cell.playStatus = !cell.playStatus
                cell.showPlayButton(with: cell.playStatus)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let colView = collectionView {
            let visibleRect = CGRect(origin: colView.contentOffset, size: colView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let indexPath = colView.indexPathForItem(at: visiblePoint) {
                print("Indice: ",indexPath.row)
                
                if currentIndex != indexPath {
                    if let cell = collectionView?.cellForItem(at: currentIndex) as? VideoCollectionViewCell {
                        cell.player?.seek(to: .zero)
                        cell.playStatus = false
                    }
                    if let cell = collectionView?.cellForItem(at: indexPath) as? VideoCollectionViewCell {
                        cell.playStatus = true
                    }
                    currentIndex = indexPath
                }
            }
            
        }
    }
    
}

extension UIView {
//    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
//        self.alpha = 0.0
//
//        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
//            self.isHidden = false
//            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
//            self.alpha = 1.0
//        }, completion: completion)
//    }
//
//    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
//        self.alpha = 1.0
//
//        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
//            self.isHidden = true
//            self.alpha = 0.0
//        }, completion: completion)
//    }
    
    func fadeIn() {
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.alpha = 1.0
        }) { finished in
            if finished {
                self.fadeOut()
            }
        }
    }
    
    func fadeOut() {
        self.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.alpha = 0.0
        }) { finished in
            if finished {
                self.isHidden = true
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
}
