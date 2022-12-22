//
//  RectangleCropViewController.swift
//  Berel
//
//  Created by Sferea-Lider on 14/11/22.
//

import UIKit

public class RectangleCropViewController: UIViewController {

    var image: UIImage
    let imageView: UIImageView
    let scrollView: UIScrollView
    var delegate: CropViewControllerDelegate?
    private var rectangleView: RectangleCropView?
    
    var backButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "icon_close_v2")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .red
        return button
    }()

    var okButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
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
        
        rectangleView = RectangleCropView(frame: self.view.bounds)
        modalPresentationStyle = .fullScreen
        view.addSubview(scrollView)
        view.addSubview(rectangleView!)
        view.addSubview(okButton)
        view.addSubview(backButton)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        scrollView.delegate = self
        view.backgroundColor = UIColor.white
        scrollView.frame = self.view.frame.inset(by: view.safeAreaInsets)
        rectangleView?.frame = self.scrollView.frame.inset(by: view.safeAreaInsets)
        
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okClick), for: .touchUpInside)
        addConstraint()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scrollFrame = scrollView.frame
        let imSize = image.size
        guard let hole = rectangleView?.rectangleInset, hole.width > 0 else { return }
        
        let verticalRatio = hole.height / imSize.height
        let horizontalRatio = hole.width / imSize.width
        
        scrollView.minimumZoomScale = max(horizontalRatio, verticalRatio)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale * 1.25
        
        let insetHeight = (scrollFrame.height - hole.height) / 2
        let insetWidth = (scrollFrame.width - hole.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: insetHeight, left: insetWidth, bottom: insetHeight, right: insetWidth)
        
        let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
        let centerOffsetY = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        scrollView.setContentOffset(centerPoint, animated: false)
        
        okButton.clipsToBounds = true
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
        guard let rect = self.rectangleView?.rectangleInset else {
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

extension RectangleCropViewController: UIScrollViewDelegate {
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
