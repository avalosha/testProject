//
//  CustomImageChooserViewController.swift
//  Berel
//
//  Created by Sferea-Lider on 14/10/22.
//

import UIKit
import AVFoundation
import PhotosUI

protocol ImageChooserDelegate: NSObjectProtocol {
    func onTaken(photo: UIImage?)
    func onDelete()
}

class CustomImageChooserViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var deleteContainer: UIView!
    
    var miControladorImagen : UIImagePickerController!
    public weak var delegate: ImageChooserDelegate? = nil
    var enableDelete = false
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private var defaultHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 150
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 300
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private var deletePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        miControladorImagen = UIImagePickerController()
        
        miControladorImagen.modalPresentationStyle = .fullScreen
        miControladorImagen.delegate = self
        
        deleteContainer.isHidden = !enableDelete
        
        setupView()
        setupPanGesture()
        setupConstraints()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }

    private func setupView() {
        mainContainer.layer.cornerTopRadius(radius: 20.0)
        mainContainer.layer.shadowColor = UIColor.gray.cgColor
        mainContainer.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        mainContainer.layer.shadowOpacity = 1.0
        mainContainer.layer.shadowRadius = 5.0
        mainContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let height = deleteContainer.isHidden ? mainContainer.frame.height - 45.0 : mainContainer.frame.height
        defaultHeight = height
        currentContainerHeight = height
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        backView.addGestureRecognizer(tapGesture)
        helpView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        containerViewHeightConstraint = mainContainer.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = mainContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        print("Current container height: \(currentContainerHeight)")
        print("New height: \(newHeight)")
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                if newHeight > defaultHeight {
                    
                    view.layoutIfNeeded()
                    return
                } else {
                    containerViewHeightConstraint?.constant = newHeight
                    // refresh layout
                    view.layoutIfNeeded()
                }
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.mainContainer.isHidden = true
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
//            else if newHeight > defaultHeight && !isDraggingDown {
//                // Condition 4: If new height is below max and going up, set to max height at top
//                animateContainerHeight(maximumContainerHeight)
//            }
        default:
            break
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        backView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animateDismissView() {
        // hide blur view
        backView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.backView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false) {
                if self.deletePhoto == true {
                    self.delegate?.onDelete()
                }
            }
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }

    @IBAction func deleteAction(_ sender: Any) {
        deletePhoto = true
        self.animateDismissView()
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
                        self.animateDismissView()
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

extension CustomImageChooserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
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
            self.animateDismissView()
        }
    }
}

extension CustomImageChooserViewController: CropViewControllerDelegate{
    func onCancelCrop() {
        
    }
    
    func cropView(image: UIImage?) {
        self.miControladorImagen.dismiss(animated: false) {
            self.delegate?.onTaken(photo: image)
            self.animateDismissView()
        }
    }
    
}


