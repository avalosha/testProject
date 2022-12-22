//
//  RectangleCropView.swift
//  Berel
//
//  Created by Sferea-Lider on 14/11/22.
//

import UIKit

public class RectangleCropView: UIView {

    let thickness: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        isUserInteractionEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var rectangleInset: CGRect {
        let rect = bounds
        let heightAspect = rect.height * 0.5
        let widthAspect = (rect.height * 2/3) * 0.5
        let rectCropper = CGRect(x: rect.midX - widthAspect/2, y: rect.midY - heightAspect/2, width: widthAspect, height: heightAspect)
        
        return rectCropper
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()
        let holeInset = rectangleInset
      
        let length: CGFloat = rectangleInset.width / 16
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(thickness)
        
        //Top left
        context.move(to: CGPoint(x: holeInset.minX + length, y: holeInset.minY))
        context.addLine(to:  holeInset.origin)
        context.addLine(to: CGPoint(x: holeInset.minX, y: holeInset.minY + length))
        //Bottom left
        context.move(to: CGPoint(x: holeInset.minX, y: holeInset.maxY - length))
        context.addLine(to:  CGPoint(x: holeInset.minX, y: holeInset.maxY))
        context.addLine(to:  CGPoint(x: holeInset.minX+length, y: holeInset.maxY))
        //Top right
        context.move(to: CGPoint(x: holeInset.maxX-length, y: holeInset.minY))
        context.addLine(to:  CGPoint(x: holeInset.maxX, y: holeInset.minY))
        context.addLine(to:  CGPoint(x: holeInset.maxX, y: holeInset.minY+length))
        //Bottom left
        context.move(to: CGPoint(x: holeInset.maxX, y: holeInset.maxY - length))
        context.addLine(to:  CGPoint(x: holeInset.maxX, y: holeInset.maxY))
        context.addLine(to:  CGPoint(x: holeInset.maxX-length, y: holeInset.maxY))
      
        context.strokePath()
        context.restoreGState()
    }

}
