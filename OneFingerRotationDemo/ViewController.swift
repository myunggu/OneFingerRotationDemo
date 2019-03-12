//
//  ViewController.swift
//  OneFingerRotationDemo
//
//  Created by Myunggu Kim on 12/03/2019.
//  Copyright © 2019 Shinvee Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var imageAngle: CGFloat = 0
    var cumulatedAngle: CGFloat = 0
    lazy var midPoint = imageView.center
    lazy var outerRadius = imageView.frame.size.width/2.0
    lazy var innerRadius = outerRadius - 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func angleBetweenLinesInDegrees(beginLineA: CGPoint, endLineA: CGPoint, beginLineB: CGPoint, endLineB: CGPoint) -> CGFloat {
        let a = endLineA.x - beginLineA.x
        let b = endLineA.y - beginLineA.y
        let c = endLineB.x - beginLineB.x
        let d = endLineB.y - beginLineB.y
        
        let atanA = atan2(a, b)
        let atanB = atan2(c, d)
        
        return (atanA - atanB) * 180/CGFloat(Double.pi)
    }
    
    func rotation(angle: CGFloat) {
        imageAngle += angle
        //        if imageAngle > 360 {
        //            imageAngle -= 360
        //        } else if imageAngle < -360 {
        //            imageAngle += 360
        //        }
        imageView.transform = CGAffineTransform(rotationAngle: imageAngle * CGFloat(Double.pi / 180))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let nowPoint = touches.first?.location(in: view)
        let prevPoint = touches.first?.previousLocation(in: view)
        
        let distance = distanceBetweenPoints(point1: midPoint, point2: nowPoint!)
        
        if innerRadius <= distance && distance <= outerRadius {
            let angle = angleBetweenLinesInDegrees(beginLineA: midPoint, endLineA: prevPoint!, beginLineB: midPoint, endLineB: nowPoint!)
            cumulatedAngle += angle
            rotation(angle: angle)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        cumulatedAngle = 0;
        
        // log degrees
        let radians = atan2f(Float(imageView.transform.b), Float(imageView.transform.a))
        let degrees = radians * (180 / Float.pi)
        print("각도 : \(degrees)")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        cumulatedAngle = 0
    }
}

