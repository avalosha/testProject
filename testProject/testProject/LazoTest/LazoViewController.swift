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
    private var shadowLayer: CAShapeLayer?
    
    private var panGesture = UIPanGestureRecognizer()
    
    @IBOutlet weak var lassoImg: UIImageView!
    @IBOutlet weak var componentImg: UIImageView!
    @IBOutlet weak var originalImg: UIImageView!
    
    private var firstPoint: CGPoint?
    
    private var images = [UIImage]()
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
           imageView.isUserInteractionEnabled = true
           imageView.addGestureRecognizer(panGesture)
        
        images.append(UIImage(named: "Imagen1")!)
        images.append(UIImage(named: "Imagen2")!)
        images.append(UIImage(named: "Imagen3")!)
        images.append(UIImage(named: "Imagen4")!)
        images.append(UIImage(named: "Imagen5")!)
        images.append(UIImage(named: "Imagen6")!)
        
        imageView.image = images.first!
    }
    
    @objc func draggedView(_ gesture: UIPanGestureRecognizer) {
            let location = gesture.location(in: imageView)
            
            switch gesture.state {
            case .began:
                print("Began")
                path = UIBezierPath()
                path?.move(to: location)
                
                firstPoint = location
                
                strokeLayer = CAShapeLayer()
                shadowLayer = CAShapeLayer()
                
                imageView.layer.addSublayer(shadowLayer!)
                imageView.layer.addSublayer(strokeLayer!)
                
                shadowLayer?.name = "DashedBottonLine"
                shadowLayer?.fillColor = UIColor.clear.cgColor
                shadowLayer?.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor //UIColor.black.cgColor
                shadowLayer?.lineWidth = 2.5
                shadowLayer?.lineJoin = CAShapeLayerLineJoin.round
                
                strokeLayer?.name = "DashedTopLine"
                strokeLayer?.fillColor = UIColor.clear.cgColor
                strokeLayer?.strokeColor = UIColor.white.cgColor
                strokeLayer?.lineWidth = 2.0
                strokeLayer?.lineJoin = CAShapeLayerLineJoin.round
                strokeLayer?.lineDashPattern = [5, 5] // #1 es la longitud del guión, #2 es la longitud del espacio.
                
                shadowLayer?.path = path?.cgPath
                strokeLayer?.path = path?.cgPath
                
            case .changed:
                print("Changed")
                path?.addLine(to: location)
                shadowLayer?.path = path?.cgPath
                strokeLayer?.path = path?.cgPath
                
            case .cancelled, .ended:
                print("Ended")
                
                if let p0 = firstPoint {
                    path?.addLine(to: p0)
                    shadowLayer?.path = path?.cgPath
                    strokeLayer?.path = path?.cgPath
                }

            default: break
            }
        }
    
    @IBAction func onClickColorBtn(_ sender: UIButton) {
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = nil
        firstPoint = nil
        
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
        firstPoint = nil
        lassoImg.image = UIImage()
    }
    
    @IBAction func onClickChangeBtn(_ sender: Any) {
        firstPoint = nil
        lassoImg.image = UIImage()
        
        index = index < (images.count - 1) ? index + 1 : 0
        imageView.image = images[index]
    }
}

extension UIView {
    var snapshot: UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
