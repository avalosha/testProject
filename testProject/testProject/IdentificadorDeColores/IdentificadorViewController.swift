//
//  IdentificadorViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 19/12/22.
//

import UIKit

class IdentificadorViewController: UIViewController {

    @IBOutlet weak var mainImgView: UIImageView!
    
    var imagePickerController : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
    }
    
    @IBAction func onClickGaleryBtn(_ sender: Any) {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension IdentificadorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else {
            imagePickerController.dismiss(animated: true, completion: nil)
            return
        }
        
        mainImgView.image = image
        imagePickerController.dismiss(animated: false)
    }
}
