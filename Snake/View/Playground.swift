//
//  Playground.swift
//  Snake
//
//  Created by Robin chin on 2018/8/20.
//  Copyright © 2018年 Robin chin. All rights reserved.
//

import UIKit

class Playground: UIView {

    let playgroundWidth: Int
    var interval: CGFloat {
        return frame.width / CGFloat(playgroundWidth)
    }
    
    private var snakeLayers: [CALayer] = []
    
    private lazy var fruitLayer: CALayer = {
        var layer = CALayer()
        let origin = CGPoint.zero
        let size = CGSize(width: interval, height: interval)
        layer.frame = CGRect(origin: origin, size: size)
        layer.backgroundColor = UIColor.green.cgColor
        layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        self.layer.addSublayer(layer)
        return layer
    }()
    
    init(playgroundWidth: Int) {
        self.playgroundWidth = playgroundWidth
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: .zero)
        
        for index in 0...playgroundWidth {
            let intervalValue = CGFloat(index) * interval
            path.move(to: CGPoint(x: intervalValue, y: 0))
            path.addLine(to: CGPoint(x: intervalValue, y: rect.height))
            
            path.move(to: CGPoint(x: 0, y: intervalValue))
            path.addLine(to: CGPoint(x: rect.width, y: intervalValue))
        }
        
        UIColor.black.setFill()
        path.stroke()
    }
    
    func updateSnake(_ points: [Point]) {
        if snakeLayers.count == points.count && snakeLayers.count != 0 {
            let last = snakeLayers.popLast()!
            snakeLayers.insert(last, at: 0)
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            last.frame.origin = CGPoint(x: CGFloat(points.first!.x) * interval, y: CGFloat(points.first!.y) * interval)
            CATransaction.commit()
        } else {
            snakeLayers.forEach { $0.removeFromSuperlayer() }
            snakeLayers.removeAll()
            points.forEach { (point) in
                let origin = CGPoint(x: CGFloat(point.x) * interval, y: CGFloat(point.y) * interval)
                let size = CGSize(width: interval, height: interval)
                let snakeLayer = CALayer()
                snakeLayer.backgroundColor = UIColor.red.cgColor
                snakeLayer.frame = CGRect(origin: origin, size: size)
                layer.addSublayer(snakeLayer)
                snakeLayers.append(snakeLayer)
            }
        }
    }
    
    func updateFruit(_ point: Point) {
        let origin = CGPoint(x: CGFloat(point.x) * interval, y: CGFloat(point.y) * interval)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        fruitLayer.frame.origin = origin
        CATransaction.commit()
    }

}
