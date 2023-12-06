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
    
    let lineWidth: CGFloat = 10.0
    
    var nodeSize: CGFloat = 0.0

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
        let path = UIBezierPath()
        
        var horiziontalY = 0.0
        
        switch direction {
        case .TOP_TO_RIGHT: 
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength)
            let cornerRadii = lineWidth/2.0
            let topPath = UIBezierPath.init(roundedRect: topRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadii, height: 1))
            path.append(topPath)
            
            let radius = (nodeSize - startX) * 0.5
            let arcCenter = CGPoint(x: startX + radius, y: topRect.maxY)
            let circlePath = UIBezierPath.init(arcCenter: arcCenter, radius: radius, startAngle: Double.pi/2, endAngle: Double.pi, clockwise: true)
            path.append(circlePath)
            
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: startX + radius, y: topRect.maxY + radius))
            rightPath.addLine(to: CGPoint(x: nodeSize, y: topRect.maxY + radius))
            
            path.append(rightPath)
            
            break
            
        case .HORIZONTAL:
            
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength)
            let radius = (nodeSize - startX) * 0.5
            let yPosition = topRect.maxY + radius
            
            let path1 = UIBezierPath()
            path1.move(to: CGPoint(x: 0, y: yPosition))
            path1.addLine(to: CGPoint(x: nodeSize, y: yPosition))
            
            path.append(path1)
            break
            
        case .LEFT_TO_BOTTOM:
            let shortLineWH = getFirstLineVerticalGauge()
            let startX = 0.0
            let radius = (nodeSize - shortLineWH - lineWidth) * 0.5
            
            let hPath = UIBezierPath()
            hPath.move(to: CGPoint(x: startX, y: nodeSize-radius-shortLineWH))
            hPath.addLine(to: CGPoint(x: startX + shortLineWH, y: nodeSize-radius-shortLineWH))
            path.append(hPath)
                        
            let arcCenter = CGPoint(x: startX + shortLineWH, y: nodeSize - shortLineWH)
            let cPath = UIBezierPath.init(arcCenter: arcCenter, radius: radius, startAngle: Double.pi*1.5, endAngle: 0, clockwise: true)
            path.append(cPath)
            
            switch span {
            case .NORMAL:
                let vPath = UIBezierPath()
                vPath.move(to: CGPoint(x: startX + radius + shortLineWH, y: nodeSize-shortLineWH))
                vPath.addLine(to: CGPoint(x: startX + radius + shortLineWH, y: nodeSize))
                path.append(vPath)
            default:
                let topRect = CGRectMake(startX + radius + shortLineWH, nodeSize-shortLineWH, 0.01, shortLineWH-6)
                let cornerRadii = lineWidth/2.0
                let vPath = UIBezierPath.init(roundedRect: topRect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
                path.append(vPath)
            }
            
            break
            
        case .TOP_TO_LEFT:
            // 1.画竖线
            let path1 = UIBezierPath()
            let xPosition = nodeSize * 0.6
            path1.move(to: CGPoint(x: xPosition, y: 0))
            path1.addLine(to: CGPoint(x: xPosition, y: getFirstLineVerticalGauge() * 2))
            
            path.append(path1)
            
            // 2.画四分之一圆弧
            let path2 = UIBezierPath(arcCenter: CGPoint(x: getFirstLineHorizontalGauge(),
                                                        y: getFirstLineVerticalGauge() * 2),
                                     radius: nodeSize * 0.6 - getFirstLineHorizontalGauge(),
                                     startAngle: 360 / 180 * .pi,
                                     endAngle: 90 / 180 * .pi,
                                     clockwise: true)
            path.append(path2)
            
            // 3.画横线
            let path3 = UIBezierPath()
            let yPosition = nodeSize * 0.6
            path3.move(to: CGPoint(x: getFirstLineHorizontalGauge(), y: yPosition))
            path3.addLine(to: CGPoint(x: 0, y: yPosition))
            
            path.append(path3)
            
            break
            
        case .RIGHT_TO_BOTTOM:
            
            // 1.画横线
            let path1 = UIBezierPath()
            let yPosition1 = nodeSize * 0.5
            path1.move(to: CGPoint(x: nodeSize, y: yPosition1))
            path1.addLine(to: CGPoint(x: nodeSize - getFirstLineHorizontalGauge(), y: yPosition1))
            path.append(path1)
            
            // 2.画四分之一圆
            let yPosition = nodeSize - getFirstLineVerticalGauge()
            let path2 = UIBezierPath(arcCenter: CGPoint(x: nodeSize - getFirstLineHorizontalGauge(),
                                                        y: yPosition),
                                     radius: nodeSize * 0.5 - getFirstLineVerticalGauge(),
                                     startAngle: 180 / 180 * .pi,
                                     endAngle: 270 / 180 * .pi,
                                     clockwise: true)
            path.append(path2)
            
            // 3.画竖线
            let path3 = UIBezierPath()
            let xPosition = nodeSize - (nodeSize * 0.5 - getFirstLineVerticalGauge()) - getFirstLineHorizontalGauge()
            path3.move(to: CGPoint(x: xPosition, y: yPosition))
            switch span {
            case .LAST:
                path3.addLine(to: CGPoint(x: xPosition, y: nodeSize - lineWidth * 0.5))
                path3.close()
                path3.lineWidth = lineWidth
                path3.lineJoinStyle = .round
                color.set()
                path3.stroke()
            case .NORMAL, .FIRST:
                path3.addLine(to: CGPoint(x: xPosition, y: nodeSize))
            }
            
            path.append(path3)
            
            break
        }
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.setFillColor(color.cgColor)

        context.addPath(path.cgPath)
        context.drawPath(using: .stroke)
    }
    
}

extension StripLightsNode {
    func firstNodeLeftWidthPadding() -> CGFloat {
        return self.nodeSize / 3.0
    }
    func firstNodeTopHeightPadding() -> CGFloat {
        return self.nodeSize / 10.0
    }

    //for TOP_TO_LEFT & TOP_TO_RIGHT
    func getFirstLineVerticalGauge() -> CGFloat {
        return self.nodeSize / 8.0
    }
    //for LEFT_TO_BOTTOM & RIGHT_TO_BOTTOM
    func getFirstLineHorizontalGauge() -> CGFloat {
        return self.nodeSize / 4.0
    }
    func getRadiusOfSweep() -> CGFloat {
        return self.nodeSize / 3.0
    }
    func getBreakGauge() -> CGFloat {
        return self.nodeSize / 30.0
    }
}

