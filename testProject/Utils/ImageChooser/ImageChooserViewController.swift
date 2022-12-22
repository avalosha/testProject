//
//  ImageChooserViewController.swift
//  Colonos
//
//  Created by Sferea-Lider on 02/05/22.
//

import UIKit
import AVFoundation
import PhotosUI

class ImageChooserViewController: UIViewController {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var deleteContainer: UIView!
    
    var miControladorImagen : UIImagePickerController!
    public weak var delegate: ImageChooserDelegate? = nil
    var enableDelete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miControladorImagen = UIImagePickerController()
        
        miControladorImagen.modalPresentationStyle = .fullScreen
        miControladorImagen.delegate = self
        
        deleteContainer.isHidden = !enableDelete
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeChooser)))
        
        setupView()
    }
    
    private func setupView() {
        mainContainer.layer.cornerTopRadius(radius: 20.0)
        mainContainer.layer.shadowColor = UIColor.gray.cgColor
        mainContainer.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        mainContainer.layer.shadowOpacity = 1.0
        mainContainer.layer.shadowRadius = 5.0
        mainContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc func closeChooser(){
        dismiss(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.onDelete()
        }
    }
     
    @IBAction func openCamara(_ sender: Any) {
        self.miControladorImagen.sourceType = .camera
        if AVCaptureDevice.authorizationStatus(for: .video)  ==  .authorized {
            
            DispatchQueue.main.async {
                self.present(self.miControladorImagen, animated: true, completion: nil)
            }
           
        } else {
            AVCaptureDevice.requestAccess(for: .video) { access in
                
                DispatchQueue.main.async {
                    if access{
                        self.present(self.miControladorImagen, animated: true, completion: nil)
                    } else {
                        self.closeChooser()
                    }
                }
               
            }
        }
    }
    
    @IBAction func openGalery(_ sender: Any) {
        self.miControladorImagen.sourceType = .photoLibrary
        self.present(self.miControladorImagen, animated: true, completion: nil)
    }

}

extension ImageChooserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            miControladorImagen.dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = CropViewController(image: image)
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        
        vc.modalPresentationStyle = .fullScreen
        miControladorImagen.dismiss(animated: false)
        self.present(vc, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.miControladorImagen.dismiss(animated: false) {
            self.closeChooser()
        }
    }
}

extension ImageChooserViewController: CropViewControllerDelegate{
    func onCancelCrop() {
        
    }
    
    func cropView(image: UIImage?) {
        self.miControladorImagen.dismiss(animated: false) {
            self.delegate?.onTaken(photo: image)
            self.closeChooser()
        }
    }
    
}

