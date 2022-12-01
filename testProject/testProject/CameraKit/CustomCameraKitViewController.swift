//
//  CustomCameraKitViewController.swift
//  testProject
//
//  Created by miniMAC Sferea on 13/12/21.
//

import UIKit
import CameraKit_iOS

class CustomCameraKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func openCamara(_ sender: Any) {
        // Init a photo capture session
        let session = CKFPhotoSession()
            
        let previewView = CKFPreviewView(frame: self.view.bounds)
        previewView.session = session
        
        session.capture({ (image, settings) in
            // TODO: Add your code here
            print("Image: ",image)
        }) { (error) in
            // TODO: Handle error
            print("Error: ",error)
        }
    }
}
