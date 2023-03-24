//
//  IdentificadorViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 19/12/22.
//

import UIKit
//import libraryColorPredominanteLITE

class IdentificadorViewController: UIViewController {

    @IBOutlet weak var identificadorBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var brochaBtn: UIButton!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var colorsTableView: UITableView!
    
    private var imagePickerController : UIImagePickerController!
    private var identifierColors = [IdentifierData]()
    
    private var type = 0
    private var colors = [IdentifierData]()
    private var point: CGPoint?
    private var currentImg: UIImage?
    private var currentColor: String?
    private var originalImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPickerController()
        setupButtons()
        
        let color1 = IdentifierData(color: .red, colorHx: "#FF0000", posX: nil, posY: nil)
        let color2 = IdentifierData(color: .blue, colorHx: "#0000FF", posX: nil, posY: nil)
        let color3 = IdentifierData(color: .green, colorHx: "#00FF00", posX: nil, posY: nil)
        let color4 = IdentifierData(color: .cyan, colorHx: "#00FFFF", posX: nil, posY: nil)
        let color5 = IdentifierData(color: .yellow, colorHx: "#FFFF00", posX: nil, posY: nil)
        let color6 = IdentifierData(color: .black, colorHx: "#000000", posX: nil, posY: nil)
        let color7 = IdentifierData(color: .orange, colorHx: "#FFA500", posX: nil, posY: nil)
        let color8 = IdentifierData(color: .brown, colorHx: "#A52A2A", posX: nil, posY: nil)
        let color9 = IdentifierData(color: .magenta, colorHx: "#FF00FF", posX: nil, posY: nil)
        let color10 = IdentifierData(color: .purple, colorHx: "#A020F0", posX: nil, posY: nil)
        
        colors.append(color1)
        colors.append(color2)
        colors.append(color3)
        colors.append(color4)
        colors.append(color5)
        colors.append(color6)
        colors.append(color7)
        colors.append(color8)
        colors.append(color9)
        colors.append(color10)
    }
    
    private func setupPickerController() {
        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
    }
    
    private func setupTableView() {
        colorsTableView.delegate = self
        colorsTableView.dataSource = self
    }
    
    private func setupButtons() {
        identificadorBtn.layer.borderColor = UIColor.white.cgColor
        identificadorBtn.layer.borderWidth = 1.5
        brochaBtn.layer.borderColor = UIColor.white.cgColor
        brochaBtn.layer.borderWidth = 1.5
        identificadorBtn.isSelected = true
    }
    
    @IBAction func onClickGaleryBtn(_ sender: Any) {
        mainImgView.subviews.forEach { $0.removeFromSuperview() }
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onClickBrochaBtn(_ sender: Any) {
        type = 1
        brochaBtn.isSelected = !brochaBtn.isSelected
        mainImgView.image = nil
        identifierColors = colors
        colorsTableView.reloadData()
    }
    
    @IBAction func onClickIdentificadorBtn(_ sender: Any) {
        type = 0
        identificadorBtn.isSelected = !identificadorBtn.isSelected
        point = nil
        currentImg = nil
        currentColor = nil
        mainImgView.image = nil
        identifierColors.removeAll()
        colorsTableView.reloadData()
        mainImgView.subviews.forEach { $0.removeFromSuperview() }
        mainImgView.image = originalImg
    }
    
    @IBAction func onClickReloadBtn(_ sender: Any) {
        mainImgView.image = originalImg
        currentImg = originalImg
        mainImgView.subviews.forEach { $0.removeFromSuperview() }
    }
}

extension IdentificadorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else {
            imagePickerController.dismiss(animated: true, completion: nil)
            return
        }
        
        imagePickerController.dismiss(animated: false)
        
        let vc = RectangleCropViewController(image: image)
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func getPredominantColors(with image: UIImage) {
        // Obtenemos las dimensiones del dispositivo
        let screenSize = UIScreen.main.bounds.size
        let device_width = screenSize.width
        let device_height = screenSize.height
        print("dimensiones dispositivo: ", device_height, device_width)
        print("ImgSize: ",image.size," ImgViewSize: ",mainImgView.frame.size)
        // Ejecutamos la libreria de deteccion de color predominante
//        let crop = centerCrop(image, new_h: Int(mainImgView.frame.height), new_w:  Int(mainImgView.frame.width))
//        print("resultado del centrado y redimensionado.... :")
//        print(crop.size)
////        let colors = ColoresPredominantes(crop, k_clusters: 5) // 7 12
//        let colors = coloresPredominantes2(crop)
//
//        // Create a context of the starting image size and set it as the current one
//        UIGraphicsBeginImageContext(image.size)
//        // Draw the starting image in the current context as background
//        image.draw(at: CGPoint.zero)
//        // Get the current context
//        let context = UIGraphicsGetCurrentContext()!
//
//        self.identifierColors.removeAll()
//        for i in 0..<colors.count {
//            print(i,". Color: ",colors[i])
//            let color = colors[i]["colorUIColor"] as? UIColor ?? .clear
//            let posX = colors[i]["coordenadaX"] as? CGFloat
//            let posY = colors[i]["coordenadaY"] as? CGFloat
//            let colorHx = colors[i]["colorHexadecimal"] as? String
//            let data = IdentifierData(color: color, colorHx: colorHx, posX: posX, posY: posY)
//            self.identifierColors.append(data)
//
//            // Ploteamos la posicion del centroide de los colores predominantes sobre la Imagen
//            if i < 5 {
//                print("---------")
//                let posx = colors[i]["coordenadaX"]!
//                let posy = colors[i]["coordenadaY"]!
//                print("posicion pixel: ",posx, posy)
//
//                let diam = Int(45*image.size.height/1080.0)
//                let LineWidth = 10.0*image.size.height/1080.0
//                print("Diam: ", diam)
//                print("LineWidth: ", LineWidth)
//
//                // Draw a transparent green Circle
//                context.setStrokeColor(UIColor.black.cgColor)
//                if let color = colors[i]["colorUIColor"] as? UIColor {
//                    context.setFillColor(color.cgColor)
//                }
//                context.setAlpha(0.9)
//                context.setLineWidth(LineWidth) //8.0
//                // x: posicion de los pixeles horizontales
//                // y: posicion de los pixeles verticales
//                context.addEllipse(in: CGRect(x: posx as! Int, y: posy as! Int, width: diam, height: diam))
//                context.drawPath(using: .fillStroke)
//            }
//        }
//
//        // Save the context as a new UIImage
//        let myImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        mainImgView.image = myImage
//        colorsTableView.reloadData()
    }
    
    private func paintColor() {
        guard let cgPoint = point, let image = currentImg, let color = currentColor else { return }
        
        let posX = (cgPoint.x*image.size.width)/mainImgView.frame.width
//        let newPointY = image.size.height - cgPoint.y
        let posY = (cgPoint.y*mainImgView.frame.height)/image.size.height
        print(" - posición: ", posX, posY)
        
        // Obtenemos las dimensiones del dispositivo
        let screenSize = UIScreen.main.bounds.size
        let device_width = screenSize.width
        let device_height = screenSize.height
        print(" - dimensiones dispositivo: ", device_height, device_width)
        print(" - dimensiones del UIImage: ", mainImgView.frame.height, mainImgView.frame.width)
        print(" - dimensiones de la imagen: ", image.size)
        
//        return
        // Verificamos si el UIImage se corta por el size del dispositivo
        var new_w = Int(mainImgView.frame.width)
        if( Int(device_width) < Int(mainImgView.frame.width) ){
            print("---++ usamos el size del dispositivo... ")
            new_w = Int(device_width)
        }
        // Recortamos y centramos la imagen
//        let crop = centerCrop(image, new_h: Int(mainImgView.frame.height), new_w:  new_w)
//        print("resultado del centrado y redimensionado.... :")
//        print(crop.size.height, crop.size.width)
        
//        let image2 = change_color(crop, row: Int(posY), col: Int(posX), HEX: color)
//        
//        // Create a context of the starting image size and set it as the current one
//        UIGraphicsBeginImageContext(image2.size)
//        // Draw the starting image in the current context as background
//        image2.draw(at: CGPoint.zero)
//        // Save the context as a new UIImage
//        let myImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        currentImg = myImage
//        mainImgView.image = myImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, type == 1 {
            let position = touch.location(in: mainImgView)
            print("Point x: \(position.x) Point y: \(position.y)")
            let dot = UIView(frame: CGRect(x: position.x, y: position.y, width: 20, height: 20))
            dot.backgroundColor = .clear
            dot.layer.borderWidth = 5.0
            dot.layer.borderColor = UIColor.black.cgColor
            dot.layer.cornerRadius = dot.frame.width/2
            self.mainImgView.addSubview(dot)
            point = position
            paintColor()
        }
    }
}

extension IdentificadorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        identifierColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorCell.identifier) as! ColorCell
        let index = indexPath.row
        cell.colorLbl.text = identifierColors[index].colorHx
        cell.mainView.backgroundColor = identifierColors[index].color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentColor = identifierColors[indexPath.row].colorHx
    }
    
}

//--------------------------------------------------------------------------
//MARK: - CropViewControllerDelegate
//--------------------------------------------------------------------------
extension IdentificadorViewController: CropViewControllerDelegate{
    func onCancelCrop() {
        
    }
    
    func cropView(image: UIImage?) {
        guard let img = image else { return }
        originalImg = img
        currentImg = img
        
        if type == 0 {
            getPredominantColors(with: img)
        } else {
            mainImgView.image = img
        }
    }
    
}

// MARK: - Identificador de colores
struct IdentifierData {
    var color: UIColor?
    var colorHx: String?
    var posX: CGFloat?
    var posY: CGFloat?
}
