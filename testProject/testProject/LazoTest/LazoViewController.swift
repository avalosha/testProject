//
//  LazoViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 05/10/22.
//

import UIKit

class LazoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var path: UIBezierPath?
    private var strokeLayer: CAShapeLayer?
    
    private var panGesture = UIPanGestureRecognizer()
    
    @IBOutlet weak var lassoImg: UIImageView!
    @IBOutlet weak var componentImg: UIImageView!
    @IBOutlet weak var originalImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
           imageView.isUserInteractionEnabled = true
           imageView.addGestureRecognizer(panGesture)
    }
    
    @objc func draggedView(_ gesture: UIPanGestureRecognizer) {
            let location = gesture.location(in: imageView)
            
            switch gesture.state {
            case .began:
                print("Began")
                path = UIBezierPath()
                path?.move(to: location)
                strokeLayer = CAShapeLayer()
                imageView.layer.addSublayer(strokeLayer!)
                
                strokeLayer?.name = "DashedTopLine"
                strokeLayer?.fillColor = UIColor.clear.cgColor
                strokeLayer?.strokeColor = UIColor.white.cgColor
                strokeLayer?.lineWidth = 2.0
                strokeLayer?.lineJoin = CAShapeLayerLineJoin.bevel
                strokeLayer?.lineDashPattern = [5, 5] // #1 es la longitud del guión, #2 es la longitud del espacio.
                
                strokeLayer?.shadowColor = UIColor.black.cgColor
                strokeLayer?.shadowOffset = CGSize(width: 0.5, height: 0.5)
                strokeLayer?.shadowOpacity = 1.0
                strokeLayer?.shadowRadius = 1.0
                
                strokeLayer?.path = path?.cgPath
                
            case .changed:
                print("Changed")
                path?.addLine(to: location)
                strokeLayer?.path = path?.cgPath
                
            case .cancelled, .ended:
                print("Ended")
                print("Path: ",path)
                // remove stroke from image view
                
//                strokeLayer?.removeFromSuperlayer()
//                strokeLayer = nil
//
//                // mask the image view
//
//                let mask = CAShapeLayer()
//                mask.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//                mask.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//                mask.lineWidth = 0
//                mask.path = path?.cgPath
//
//                imageView.layer.mask = mask
//
//                // get cropped image
//
//                let image = imageView?.snapshot
//                imageView.layer.mask = nil
//
//                // perhaps use that image?
//
//                imageView.image = image

            default: break
            }
        }

    
    @IBAction func onClickColorBtn(_ sender: UIButton) {
        strokeLayer?.removeFromSuperlayer()
        strokeLayer = nil

        // mask the image view
        let mask = CAShapeLayer()
        mask.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        mask.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        mask.lineWidth = 0
        mask.path = path?.cgPath

        lassoImg.image = imageView.image
        lassoImg.layer.mask = mask

        // get cropped image
        let image = lassoImg?.snapshot
        lassoImg.layer.mask = nil
        
        // cropped image
        componentImg.image = image
        
        // perhaps use that image?
//        lassoImg.image = image
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        lassoImg.image = templateImage
        let tag = sender.tag
        let color = tag == 0 ? UIColor.systemPink : tag == 1 ? UIColor.green : UIColor.cyan
        lassoImg.tintColor = color
        
        // original image
        originalImg.image = imageView.image
    }
    
    @IBAction func onClickTrashBtn(_ sender: Any) {
        lassoImg.image = UIImage()
    }
}

extension UIView {
    var snapshot: UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
