//
//  MainReelsViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 02/03/23.
//

import UIKit

class MainReelsViewController: UIViewController {

    @IBOutlet weak var videosBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videosBtn.layer.cornerRadius = 6.0
    }
    
    @IBAction func onClickVideosBtn(_ sender: Any) {
        if let vc = ReelsViewController.newInstance() {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
}
