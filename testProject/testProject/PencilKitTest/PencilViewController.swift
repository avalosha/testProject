//
//  PencilViewController.swift
//  testProject
//
//  Created by Sferea-Lider on 05/10/22.
//

import UIKit
import PencilKit

@available(iOS 13.0, *)
class PencilViewController: UIViewController {

    private let canvasView: PKCanvasView = {
        let canvas = PKCanvasView()
        if #available(iOS 14.0, *) {
            canvas.drawingPolicy = .anyInput
        } else {
            // Fallback on earlier versions
        }
        return canvas
    }()
    
    let drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.drawing = drawing
        canvasView.delegate = self
        
        canvasView.alwaysBounceVertical = true

        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            // Fallback on earlier versions
            canvasView.allowsFingerDrawing = true
        }
        
        view.addSubview(canvasView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvasView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 14.0, *) {
            let toolPicker = PKToolPicker()
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
}

@available(iOS 13.0, *)
extension PencilViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        
    }
}
