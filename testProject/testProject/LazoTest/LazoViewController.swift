//
//  LazoViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 05/10/22.
//

import UIKit

struct Historial {
    var type: Int
    var path: UIBezierPath?
    var img: UIImage?
}

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
    
    private var idHistorial = 0
    private var fullHistorial = [Historial]()
    
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
    
    private func setupLayer() {
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
    }
    
    private func removeLayer() {
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = nil
        
        strokeLayer?.removeFromSuperlayer()
        strokeLayer = nil
    }
    
    private func resetScreen() {
        firstPoint = nil
        idHistorial = 0
        fullHistorial.removeAll()
        originalImg.image = nil
        componentImg.image = nil
        lassoImg.image = UIImage()
        redoBtn.isEnabled = false
        undoBtn.isEnabled = false
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
                setupLayer()
                
            case .changed:
//                print("Changed")
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
                    
                    print("______________________LAZO_______________________________")
                    print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
                    // Eliminar elementos guardados adelante del indice actual
                    if idHistorial < fullHistorial.count {
                        for index in (0..<fullHistorial.count).reversed() {
                            if idHistorial < index {
                                fullHistorial.remove(at: index)
                            } else {
                                break
                            }
                        }
                        redoBtn.isEnabled = false
                    }
                    // Guarda el lazo e imagen actual
                    fullHistorial.append(Historial(type: 1, path: self.path, img: self.lassoImg.image))
                    // Indice actual
                    idHistorial = fullHistorial.count
                    print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
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
        var previousImage = UIImage()
        if fullHistorial.isEmpty == false {
            let tempIndex = (idHistorial - 1) >= 0 ? idHistorial - 1 : 0
            let item = fullHistorial[tempIndex]
            if let img = item.img {
                previousImage = img
            }
        }
        // Muestra imagen actual
        componentImg.image = screenShoot
        // Muestra imagen previa
        originalImg.image = previousImage
        // Merge imagen anterior + imagen actual
        let mergeImg = mergedImageWith(frontImage: screenShoot, backgroundImage: previousImage)
        // Muestra imagen completa actual
        lassoImg.image = mergeImg
        // Eliminar elementos guardados adelante del indice actual
        print("________________________COLOR___________________________")
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
        
        if idHistorial < fullHistorial.count {
            for index in (0..<fullHistorial.count).reversed() {
                if idHistorial < index {
                    fullHistorial.remove(at: index)
                } else {
                    break
                }
            }
            redoBtn.isEnabled = false
        }
        // Guarda imagen actual
        fullHistorial.append(Historial(type: 2, path: nil, img: mergeImg))
        // Elimina el elemento más viejo
        if fullHistorial.count > 3 {
            fullHistorial.remove(at: 0)
        }
        // Indice actual
        idHistorial = fullHistorial.count
        undoBtn.isEnabled = fullHistorial.count > 0
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
    }
    
    @IBAction func onClickColorBtn(_ sender: UIButton) {
        guard blocked == true else { return }
        fillColorInsideLasso(with: sender.tag)
    }
    
    @IBAction func onClickTrashBtn(_ sender: Any) {
        resetScreen()
    }
    
    @IBAction func onClickChangeBtn(_ sender: Any) {
        resetScreen()

        index = index < (images.count - 1) ? index + 1 : 0
        imageView.image = images[index]
    }
    
    @IBAction func onClickUndoBtn(_ sender: Any) {
        guard idHistorial > 0 else { return }
        print("_______________________UNDO_____________________________")
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
        idHistorial = idHistorial == fullHistorial.count ? idHistorial - 2 : idHistorial - 1
        
        let item = fullHistorial[idHistorial]
        if item.type == 1, let tempPath = item.path, let img = item.img {
            path = tempPath
            lassoImg.image = img
            setupLayer()
            blocked = true
        } else if item.type == 2, let img = item.img {
            path = nil
            lassoImg.image = img
            removeLayer()
            blocked = false
        }
        
        undoBtn.isEnabled = idHistorial > 0
        redoBtn.isEnabled = idHistorial < fullHistorial.count
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
    }
    
    @IBAction func onClickRedoBtn(_ sender: Any) {
        guard idHistorial < fullHistorial.count - 1 else { return }
        print("________________________REDO____________________________")
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
        idHistorial += 1
        
        let item = fullHistorial[idHistorial]
        if item.type == 1, let tempPath = item.path, let img = item.img {
            path = tempPath
            lassoImg.image = img
            setupLayer()
            blocked = true
        } else if item.type == 2, let img = item.img {
            path = nil
            lassoImg.image = img
            removeLayer()
            blocked = false
        }
        
        undoBtn.isEnabled = idHistorial > 0
        redoBtn.isEnabled = idHistorial < fullHistorial.count - 1
        print("idHistorial: ",idHistorial," total: ",fullHistorial.count)
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
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero,size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints  = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}

extension CALayer {
    
    /// Máscara para redondear solo las esquinas inferiores del layer.
    /// - Parameter radius: CGFloat con el radio de las esquinas a redondear.
    func cornerBottomRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    /// Máscara para redondear solo las esquinas superiores del layer.
    /// - Parameter radius: CGFloat con el radio de las esquinas a redondear.
    func cornerTopRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /// Máscara para redondear solo las esquinas del lateral derecho del layer.
    /// - Parameter radius: CGFloat con el radio de las esquinas a redondear.
    func cornerLeadingRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        self.masksToBounds = true
    }
    
    /// Máscara para redondear solo las esquinas del lateral izquierdo del layer.
    /// - Parameter radius: CGFloat con el radio de las esquinas a redondear.
    func cornerTrailingRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.masksToBounds = true
    }
    
    func cornerTrailingTopRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMinXMinYCorner]
        self.masksToBounds = true
    }
    
    func cornerLeadingTopRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMaxXMinYCorner]
        self.masksToBounds = true
    }
    
    func cornerLeadingTopTrailingBottomRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        self.masksToBounds = true
    }
    
    func cornerFullRadius(radius : CGFloat){
        self.cornerRadius = radius
        self.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

