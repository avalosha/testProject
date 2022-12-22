//
//  CircleCropView.swift
//  Colonos
//
//  Created by Sferea-Lider on 05/05/22.
//

import UIKit

public class CircleCropView: UIView {
    
    let thickness: CGFloat = 3
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var circleInset: CGRect {
        let rect = bounds
        let minSize = min(rect.width, rect.height)
        let hole = CGRect(x: (rect.width - minSize) / 2, y: (rect.height - minSize) / 2, width: minSize, height: minSize).insetBy(dx: 60, dy: 60)
        return hole
    }

    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
       
        
        context.saveGState()
        let holeInset = circleInset
      
        let length: CGFloat = circleInset.width / 16
        
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
        
        context.addEllipse(in: holeInset)
        context.clip()
        context.clear(holeInset)
       
        context.setFillColor(UIColor.clear.cgColor)
        context.fill( holeInset)
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokeEllipse(in: holeInset.insetBy(dx: 1, dy: 1))
        context.restoreGState()
    }
}


