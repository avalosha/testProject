//
//  CustomCameraViewController.swift
//  testProject
//
//  Created by miniMAC Sferea on 13/12/21.
//

import UIKit
import ALCameraViewController

class CustomCameraViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var minimumSize: CGSize = CGSize(width: 200, height: 200)
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: minimumSize)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func openCamera(_ sender: Any) {
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
            self?.imageView.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        cameraViewController.modalPresentationStyle = .fullScreen
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func openGalery(_ sender: Any) {

        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters, completion: { [weak self] image, asset in
            
            self?.imageView.image = image
            self?.dismiss(animated: true, completion: nil)

        self?.dismiss(animated: true, completion: nil)
            
        })
        imagePickerViewController.modalPresentationStyle = .fullScreen
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
}
