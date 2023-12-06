//
//  StripLightsNode.swift
//  smartunify
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit

enum StripNodeDirection {
    case TOP_TO_RIGHT, HORIZONTAL, LEFT_TO_BOTTOM, TOP_TO_LEFT, RIGHT_TO_BOTTOM
}

enum StripNodeSpan {
    case FIRST, NORMAL, LAST
}

enum StripStyle {
    case ONLY_LINE, WITH_BEAD
}

class StripLightsNode: UIView {
    
    var color: UIColor
    var bgColor: UIColor
    var direction: StripNodeDirection
    var span: StripNodeSpan
    var style: StripStyle
    
    let lineWidth: CGFloat = 5.0
    
    var nodeWidth: CGFloat {
        return frame.size.width
    }
    
    var nodeHeight: CGFloat {
        return frame.size.height
    }

    init(frame: CGRect, 
         color: UIColor = .white,
         bgColor: UIColor = .red, 
         direction: StripNodeDirection = .TOP_TO_RIGHT,
         span: StripNodeSpan = .FIRST,
         style: StripStyle = .ONLY_LINE)
    {
        self.color = color
        self.bgColor = bgColor
        self.direction = direction
        self.span = span
        self.style = style
        
        super.init(frame: frame)
        self.backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = CGMutablePath()
    
        switch direction {
        case .TOP_TO_RIGHT: 
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            let startPoint = CGPointMake(startX, startY)
            
            path.move(to: startPoint)
            
            let topRect = CGRectMake(startX, startY, lineWidth, getFirstLineVerticalGauge())
            let cornerRadii = lineWidth/2.0
            let topPath = UIBezierPath.init(roundedRect: topRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
            path.addPath(topPath.cgPath)
            
            break
            
        case .HORIZONTAL:
            
            let path1 = UIBezierPath()
            let yPosition = self.nodeHeight * 0.6
            path1.move(to: CGPoint(x: 0, y: yPosition))
            path1.addLine(to: CGPoint(x: self.nodeWidth, y: yPosition))
            
            path.addPath(path1.cgPath)
            break
            
        case .LEFT_TO_BOTTOM:
            
            break
            
        case .TOP_TO_LEFT:
            // 1.画竖线
            let path1 = UIBezierPath()
            let xPosition = self.nodeWidth * 0.6
            path1.move(to: CGPoint(x: xPosition, y: 0))
            path1.addLine(to: CGPoint(x: xPosition, y: getFirstLineVerticalGauge() * 2))
            
            path.addPath(path1.cgPath)
            
            // 2.画四分之一圆弧
            let path2 = UIBezierPath(arcCenter: CGPoint(x: getFirstLineHorizontalGauge(),
                                                        y: getFirstLineVerticalGauge() * 2),
                                     radius: self.nodeWidth * 0.6 - getFirstLineHorizontalGauge(),
                                     startAngle: 360 / 180 * .pi,
                                     endAngle: 90 / 180 * .pi,
                                     clockwise: true)
            path.addPath(path2.cgPath)
            
            // 3.画横线
            let path3 = UIBezierPath()
            let yPosition = self.nodeHeight * 0.6
            path3.move(to: CGPoint(x: getFirstLineHorizontalGauge(), y: yPosition))
            path3.addLine(to: CGPoint(x: 0, y: yPosition))
            
            path.addPath(path3.cgPath)
            
            break
            
        case .RIGHT_TO_BOTTOM:
            
            // 1.画横线
            let path1 = UIBezierPath()
            let yPosition1 = self.nodeHeight * 0.5 + lineWidth/2
            path1.move(to: CGPoint(x: self.nodeWidth, y: yPosition1))
            path1.addLine(to: CGPoint(x: self.nodeWidth - getFirstLineHorizontalGauge(), y: yPosition1))
            path.addPath(path1.cgPath)
            
            // 2.画四分之一圆
            let yPosition = self.nodeHeight - getFirstLineVerticalGauge()
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.nodeWidth - getFirstLineHorizontalGauge(),
                                                        y: yPosition),
                                     radius: self.nodeWidth * 0.6 - getFirstLineHorizontalGauge(),
                                     startAngle: 180 / 180 * .pi,
                                     endAngle: 270 / 180 * .pi,
                                     clockwise: true)
            path.addPath(path2.cgPath)
            
            // 3.画竖线
            let path3 = UIBezierPath()
            let xPosition = self.nodeWidth * 0.4
            path3.move(to: CGPoint(x: xPosition, y: yPosition))
            switch span {
            case .LAST:
                path3.addLine(to: CGPoint(x: xPosition, y: self.nodeHeight - lineWidth * 0.5))
                path3.close()
                path3.lineWidth = lineWidth
                path3.lineJoinStyle = .round
                color.set()
                path3.stroke()
            case .NORMAL, .FIRST:
                path3.addLine(to: CGPoint(x: xPosition, y: self.nodeHeight))
            }
            
            path.addPath(path3.cgPath)
            
            break
        }
        
        context.addPath(path)

        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.setFillColor(color.cgColor)
        
        context.strokePath()
    }
    
}

extension StripLightsNode {
    func firstNodeLeftWidthPadding() -> CGFloat {
        return self.nodeHeight / 3.0
    }
    func firstNodeTopHeightPadding() -> CGFloat {
        return self.nodeHeight / 10.0
    }

    //for TOP_TO_LEFT & TOP_TO_RIGHT
    func getFirstLineVerticalGauge() -> CGFloat {
        return self.nodeHeight / 8.0
    }
    //for LEFT_TO_BOTTOM & RIGHT_TO_BOTTOM
    func getFirstLineHorizontalGauge() -> CGFloat {
        return self.nodeHeight / 4.0
    }
    func getRadiusOfSweep() -> CGFloat {
        return self.nodeHeight / 3.0
    }
    func getBreakGauge() -> CGFloat {
        return self.nodeHeight / 30.0
    }
}


