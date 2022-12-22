//
//  IdentificadorViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 19/12/22.
//

import UIKit
import libraryColorPredominanteLITE

class IdentificadorViewController: UIViewController {

    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var colorsTableView: UITableView!
    
    private var imagePickerController : UIImagePickerController!
    private var identifierColors = [IdentifierData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPickerController()
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
        
        // Obtenemos las dimensiones del dispositivo
        let screenSize = UIScreen.main.bounds.size
        let device_width = screenSize.width
        let device_height = screenSize.height
        print("dimensiones dispositivo: ", device_height, device_width)
        print("ImgSize: ",image.size," ImgViewSize: ",mainImgView.frame.size)
        // Ejecutamos la libreria de deteccion de color predominante
        let crop = centerCrop(image, new_h: Int(mainImgView.frame.height), new_w:  Int(mainImgView.frame.width))
        print("resultado del centrado y redimensionado.... :")
        print(crop.size)
//        let colors = ColoresPredominantes(crop, k_clusters: 5) // 7 12
        let colors = coloresPredominantes2(crop)
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(image.size)
        // Draw the starting image in the current context as background
        image.draw(at: CGPoint.zero)
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        self.identifierColors.removeAll()
        for i in 0..<colors.count {
            print(i,". Color: ",colors[i])
            let color = colors[i]["colorUIColor"] as? UIColor ?? .clear
            let posX = colors[i]["coordenadaX"] as? CGFloat
            let posY = colors[i]["coordenadaY"] as? CGFloat
            let colorHx = colors[i]["colorHexadecimal"] as? String
            let data = IdentifierData(color: color, colorHx: colorHx, posX: posX, posY: posY)
            self.identifierColors.append(data)
            
            // Ploteamos la posicion del centroide de los colores predominantes sobre la Imagen
            if i < 5 {
                print("---------")
                let posx = colors[i]["coordenadaX"]!
                let posy = colors[i]["coordenadaY"]!
                print("posicion pixel: ",posx, posy)
                
                let diam = Int(45*image.size.height/1080.0)
                let LineWidth = 10.0*image.size.height/1080.0
                print("Diam: ", diam)
                print("LineWidth: ", LineWidth)
                
                // Draw a transparent green Circle
                context.setStrokeColor(UIColor.black.cgColor)
                if let color = colors[i]["colorUIColor"] as? UIColor {
                    context.setFillColor(color.cgColor)
                }
                context.setAlpha(0.9)
                context.setLineWidth(LineWidth) //8.0
                // x: posicion de los pixeles horizontales
                // y: posicion de los pixeles verticales
                context.addEllipse(in: CGRect(x: posx as! Int, y: posy as! Int, width: diam, height: diam))
                context.drawPath(using: .fillStroke)
            }
        }
             
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        mainImgView.image = myImage
        colorsTableView.reloadData()
        imagePickerController.dismiss(animated: false)
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
    
}

// MARK: - Identificador de colores
struct IdentifierData {
    var color: UIColor?
    var colorHx: String?
    var posX: CGFloat?
    var posY: CGFloat?
}
