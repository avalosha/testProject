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
    
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var redoBtn: UIButton!
    
    private var firstPoint: CGPoint?
    
    private var images = [UIImage]()
    private var index = 0
    private var blocked = false
    private var historial = [UIImage]()
    private var idHistorial = 0
    
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
        
        undoBtn.isEnabled = false
        redoBtn.isEnabled = false
    }
    
    @objc func draggedView(_ gesture: UIPanGestureRecognizer) {
        guard blocked == false else { return }
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
                shadowLayer?.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor //UIColor.black.cgColor
                shadowLayer?.lineWidth = 3.0
                shadowLayer?.lineJoin = CAShapeLayerLineJoin.round
                
                strokeLayer?.name = "DashedTopLine"
                strokeLayer?.fillColor = UIColor.clear.cgColor
                strokeLayer?.strokeColor = UIColor.white.cgColor
                strokeLayer?.lineWidth = 2.5
                strokeLayer?.lineJoin = CAShapeLayerLineJoin.round
                strokeLayer?.lineDashPattern = [6, 6] // #1 es la longitud del guión, #2 es la longitud del espacio.
                
                shadowLayer?.path = path?.cgPath
                strokeLayer?.path = path?.cgPath
                
            case .changed:
                print("Changed")
                path?.addLine(to: location)
                shadowLayer?.path = path?.cgPath
                strokeLayer?.path = path?.cgPath
                
            case .cancelled, .ended:
                print("Ended")
                blocked = true
                
                if let p0 = firstPoint {
                    path?.addLine(to: p0)
                    shadowLayer?.path = path?.cgPath
                    strokeLayer?.path = path?.cgPath
                }

            default: break
        }
    }
    
    private func fillColorInsideLasso(with tag: Int) {
        // Remueve el lazo
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = nil
        firstPoint = nil
        
        strokeLayer?.removeFromSuperlayer()
        strokeLayer = nil

        // Mascara de la imagen
        let mask = CAShapeLayer()
        mask.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        mask.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        mask.lineWidth = 0
        mask.path = path?.cgPath
        
        lassoImg.image = imageView.image
        lassoImg.layer.mask = mask

        // Recorta la parte seleccionada
        let image = lassoImg?.snapshot
        lassoImg.layer.mask = nil
        
        // Colorea la parte seleccionada
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        lassoImg.image = templateImage
        let tag = tag
        let color = tag == 0 ? UIColor.systemPink : tag == 1 ? UIColor.green : UIColor.cyan
        lassoImg.tintColor = color
        
        // Carga la imagen completa
        screenShoot()
       
        blocked = false
    }
    
    /// Screenshoot del lazo y/o color agregado actual
    private func screenShoot() {
        // Obtiene imagen actual
        let screenShoot = lassoImg.makeImageFrom()
        // Obtiene imagen previa
        let previousImage = historial.isEmpty ? nil : historial[idHistorial - 1]
        // Muestra componente imagen actual
        componentImg.image = screenShoot
        // Muestra componente imagen previa
        originalImg.image = previousImage
        // Merge imagen anterior + imagen actual
        let mergeImg = mergedImageWith(frontImage: screenShoot, backgroundImage: previousImage)
        // Muestra imagen completa actual
        lassoImg.image = mergeImg
        // Guarda imagen actual
        historial.append(mergeImg)
        
        if historial.count > 4 {
            historial.remove(at: 0)
        }
        
        idHistorial = historial.count
        undoBtn.isEnabled = historial.count > 0
    }
    
    @IBAction func onClickColorBtn(_ sender: UIButton) {
        fillColorInsideLasso(with: sender.tag)
    }
    
    @IBAction func onClickTrashBtn(_ sender: Any) {
        firstPoint = nil
        idHistorial = 0
        historial.removeAll()
        originalImg.image = nil
        componentImg.image = nil
        lassoImg.image = UIImage()
    }
    
    @IBAction func onClickChangeBtn(_ sender: Any) {
        firstPoint = nil
        lassoImg.image = UIImage()

        index = index < (images.count - 1) ? index + 1 : 0
        imageView.image = images[index]
    }
    
    @IBAction func onClickUndoBtn(_ sender: Any) {
        guard idHistorial > 0 else { return }
        idHistorial = idHistorial == 4 ? idHistorial - 2 : idHistorial - 1
        let tempImg = historial[idHistorial]
        lassoImg.image = tempImg
        undoBtn.isEnabled = idHistorial > 0
        redoBtn.isEnabled = idHistorial < historial.count
    }
    
    @IBAction func onClickRedoBtn(_ sender: Any) {
        guard idHistorial < historial.count - 1 else { return }
        idHistorial += 1
        let tempImg = historial[idHistorial]
        lassoImg.image = tempImg
        undoBtn.isEnabled = idHistorial > 0
        redoBtn.isEnabled = idHistorial < historial.count - 1
    }
}

extension UIView {
    var snapshot: UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
    
    /// Función para tomar screenshot de todo lo que contenga el view correspondiente.
    /// - Returns: UIImage del screenshot.
    func makeImageFrom() -> UIImage {
        let size = CGSize(width: self.bounds.width, height: self.bounds.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (ctx) in
            self.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }
        return image
    }
}

extension LazoViewController {
    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage {

        if backgroundImage == nil {
            return frontImage!
        }

        let size = self.imageView.frame.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        frontImage?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: size.width * 0.0, dy: size.height * 0.0))

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
