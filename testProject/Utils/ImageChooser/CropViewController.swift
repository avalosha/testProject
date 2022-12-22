//
//  CropViewController.swift
//  Colonos
//
//  Created by Sferea-Lider on 05/05/22.
//

import UIKit

public class CropViewController: UIViewController {

    var image: UIImage
    let imageView: UIImageView
    let scrollView: UIScrollView
    var delegate: CropViewControllerDelegate?
    private var circleView: CircleCropView?


    var backButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "icon_close_v2")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .red
        return button
    }()

    var okButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "icono_correct")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .red
        return button
    }()


   public init(image: UIImage) {
        self.image = image
        imageView = UIImageView(image: image)
        scrollView = UIScrollView()
       
        super.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        circleView = CircleCropView(frame: self.view.bounds)
        modalPresentationStyle = .fullScreen
        view.addSubview(scrollView)
        view.addSubview(circleView!)
        view.addSubview(okButton)
        view.addSubview(backButton)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        scrollView.delegate = self
        view.backgroundColor = UIColor.white
        scrollView.frame = self.view.frame.inset(by: view.safeAreaInsets)
        circleView?.frame = self.scrollView.frame.inset(by: view.safeAreaInsets)
        
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        addConstraint()
    }

    func addConstraint() {

        okButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 24),size: CGSize(width: 40, height: 40))
        
        backButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 0),size: CGSize(width: 40, height: 40))
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scrollFrame = scrollView.frame
        let imSize = image.size
        guard let hole = circleView?.circleInset, hole.width > 0 else { return }
        let verticalRatio = hole.height / imSize.height
        let horizontalRatio = hole.width / imSize.width
        scrollView.minimumZoomScale = max(horizontalRatio, verticalRatio)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
        let insetHeight = (scrollFrame.height - hole.height) / 2
        let insetWidth = (scrollFrame.width - hole.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: insetHeight, left: insetWidth, bottom: insetHeight, right: insetWidth)
        okButton.clipsToBounds = true
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func backClick(sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.onCancelCrop()
        }
    }

    @objc func okClick(sender: UIButton) {
        self.cropImage()
    }

    private func cropImage() {
        guard let rect = self.circleView?.circleInset else {
            self.delegate?.cropView(image: nil)
            return
        }
               let shift = rect.applying(CGAffineTransform(translationX: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y))
               let scaled = shift.applying(CGAffineTransform(scaleX: 1.0 / self.scrollView.zoomScale, y: 1.0 / self.scrollView.zoomScale))
               let newImage = self.image.imageCropped(toRect: scaled)
    
            
        self.dismiss(animated: false) {
            self.delegate?.cropView(image: newImage)
        }
        
    }
}

extension CropViewController: UIScrollViewDelegate {
    func zoomOut() {
        let newScale = scrollView.zoomScale == scrollView.minimumZoomScale ? 0.5 : scrollView.minimumZoomScale
        scrollView.setZoomScale(newScale, animated: true)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //need empty implementation for zooming
    }
}

protocol CropViewControllerDelegate{
    func cropView(image: UIImage?)
    func onCancelCrop()
}

extension UIImage {
    func imageCropped(toRect rect: CGRect) -> UIImage {
        let rad: (Double) -> CGFloat = { deg in
            return CGFloat(deg / 180.0 * .pi)
        }
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            let rotation = CGAffineTransform(rotationAngle: rad(90))
            rectTransform = rotation.translatedBy(x: 0, y: -size.height)
        case .right:
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            rectTransform = rotation.translatedBy(x: -size.width, y: 0)
        case .down:
            let rotation = CGAffineTransform(rotationAngle: rad(-180))
            rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        let transformedRect = rect.applying(rectTransform)
        let imageRef = cgImage!.cropping(to: transformedRect)!
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        //print("croped Image width and height = \(result.size)")
        return result
    }
    
//    func save() -> URL? {
//        let fileName = "BerelImg_\(Date().convertToString(format: "yyyyMMddhhmmss")).jpg"
//
//        guard let data = self.jpegData(compressionQuality: 0.5) else{
//            return nil
//        }
//        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//        do {
//            try data.write(to: path)
//            return path.absoluteURL
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
}
