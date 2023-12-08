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
    
    var lineWidth: CGFloat = 10.0
    var lineColor: UIColor
    var dotColor: UIColor = UIColor.green
    var bgColor: UIColor
    var direction: StripNodeDirection
    var span: StripNodeSpan
    var nodeSize: CGFloat = 0.0
    var style: StripStyle {
        didSet {
            switch style {
            case .ONLY_LINE:
                lineWidth = 10.0
            case .WITH_BEAD:
                lineWidth = 3.0
            }
        }
    }
    
    let xDelta = 15.0
    let yDelta = 5.0

    init(frame: CGRect, 
         color: UIColor = .black,
         bgColor: UIColor = .white,
         direction: StripNodeDirection = .TOP_TO_RIGHT,
         span: StripNodeSpan = .FIRST,
         style: StripStyle = .ONLY_LINE)
    {
        self.lineColor = color
        self.dotColor = color
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
        var dotPath = UIBezierPath()
        
        switch direction {
        case .TOP_TO_RIGHT: 
            
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength)

            switch span {
            case .FIRST:
                let cornerRadii = lineWidth/2.0
                let topPath = UIBezierPath.init(roundedRect: topRect, 
                                                byRoundingCorners: [.topLeft, .topRight],
                                                cornerRadii: CGSize(width: cornerRadii, height: 1))
                path.append(topPath)
                break
            default:
                let hPath = UIBezierPath()
                hPath.move(to: CGPoint(x: startX, y: 0.0))
                hPath.addLine(to: CGPoint(x: startX, y: startY + lineLength))
                path.append(hPath)
            }
            
            let radius = (nodeSize - startX) * 0.5
            let arcCenter = CGPoint(x: startX + radius, y: topRect.maxY)
            let circlePath = UIBezierPath.init(arcCenter: arcCenter, 
                                               radius: radius,
                                               startAngle: Double.pi/2,
                                               endAngle: Double.pi,
                                               clockwise: true)
            path.append(circlePath)
            
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: startX + radius, y: topRect.maxY + radius))
            rightPath.addLine(to: CGPoint(x: nodeSize, y: topRect.maxY + radius))
            
            path.append(rightPath)
            
            if style == .WITH_BEAD {
                
                dotPath = UIBezierPath()
                dotPath.move(to: CGPoint(x: startX + radius - xDelta, y: topRect.maxY + radius - yDelta))
                dotPath.addLine(to: CGPoint(x: startX + radius - xDelta, y: topRect.maxY + radius - yDelta - 0.1))
            }
            
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
            
            if style == .WITH_BEAD {
                
                dotPath.move(to: CGPoint(x: nodeSize * 0.5 - xDelta - 0.1, y: yPosition))
                dotPath.addLine(to: CGPoint(x: nodeSize * 0.5 - xDelta, y: yPosition))
            }
            
            break
            
        case .LEFT_TO_BOTTOM:
            
            let startX = 0.0
            let startY = firstNodeTopHeightPadding()
            
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength)
            
            let shortLineWH = getFirstLineVerticalGauge()
            let radius = (nodeSize - firstNodeLeftWidthPadding()) * 0.5
            
            let hPathY = topRect.maxY+radius
            
            let hPath = UIBezierPath()
            hPath.move(to: CGPoint(x: startX, y: hPathY))
            hPath.addLine(to: CGPoint(x: startX + shortLineWH, y: hPathY))
            path.append(hPath)
            
            if style == .WITH_BEAD {
                
                dotPath.move(to: CGPoint(x: startX + lineWidth * 4 + xDelta, y: hPathY + yDelta))
                dotPath.addLine(to: CGPoint(x: startX + lineWidth * 4 + xDelta, y: hPathY + yDelta + 0.1))
            }
                        
            let arcCenter = CGPoint(x: startX + shortLineWH, y: hPathY + radius)
            let cPath = UIBezierPath.init(arcCenter: arcCenter, 
                                          radius: radius,
                                          startAngle: Double.pi*1.5,
                                          endAngle: 0,
                                          clockwise: true)
            path.append(cPath)
            
            switch span {
            case .NORMAL:
                let vPath = UIBezierPath()
                vPath.move(to: CGPoint(x: startX+shortLineWH+radius, y: hPathY + radius))
                vPath.addLine(to: CGPoint(x: startX+shortLineWH+radius, y: nodeSize))
                path.append(vPath)
            default:
                let topRect = CGRectMake(startX+shortLineWH+radius, hPathY + radius, 0.01, shortLineWH-6)
                let cornerRadii = lineWidth/2.0
                let vPath = UIBezierPath.init(roundedRect: topRect, 
                                              byRoundingCorners: [.bottomLeft, .bottomRight],
                                              cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
                path.append(vPath)
            }
            
            break
            
        case .TOP_TO_LEFT:
            
            let tempStartX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(tempStartX, startY, 0.01, lineLength)
            let radius = (nodeSize - tempStartX) * 0.5
            let yPosition = topRect.maxY + radius
            
            // 1.画竖线
            let path1 = UIBezierPath()
            let startX = 0.0
            let shortLineWH = getFirstLineVerticalGauge()
            let xPosition = startX + shortLineWH + radius
            
            path1.move(to: CGPoint(x: xPosition, y: 0))
            path1.addLine(to: CGPoint(x: xPosition, y: topRect.maxY))
            
            path.append(path1)

            // 2.画四分之一圆弧
            let path2 = UIBezierPath(arcCenter: CGPoint(x: startX + shortLineWH,
                                                        y: topRect.maxY),
                                     radius: radius,
                                     startAngle: 360 / 180 * .pi,
                                     endAngle: 90 / 180 * .pi,
                                     clockwise: true)
            path.append(path2)
            
            // 3.画横线
            
            let path3 = UIBezierPath()
            path3.move(to: CGPoint(x: shortLineWH, y: yPosition))
            path3.addLine(to: CGPoint(x: 0, y: yPosition))
            
            path.append(path3)
            
            if style == .WITH_BEAD {
                
                dotPath.move(to: CGPoint(x: shortLineWH + xDelta, y: yPosition - yDelta))
                dotPath.addLine(to: CGPoint(x: shortLineWH + xDelta, y: yPosition - yDelta - 0.1))
            }
            
            break
            
        case .RIGHT_TO_BOTTOM:
            
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            let lineLength = firstNodeTopHeightPadding()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength)
            let radius = (nodeSize - startX) * 0.5
            let yPosition1 = topRect.maxY + radius
            let endX = nodeSize - startX
            
            // 1.画横线
            
            let path1 = UIBezierPath()
            path1.move(to: CGPoint(x: nodeSize, y: yPosition1))
            path1.addLine(to: CGPoint(x: endX, y: yPosition1))
            path.append(path1)
            
            if style == .WITH_BEAD {
                
                dotPath.move(to: CGPoint(x: endX - xDelta, y: yPosition1 + yDelta))
                dotPath.addLine(to: CGPoint(x: endX - xDelta, y: yPosition1 + yDelta + 0.1))
            }
            
            // 2.画四分之一圆
            let yPosition = yPosition1 + radius
            let path2 = UIBezierPath(arcCenter: CGPoint(x: endX,
                                                        y: yPosition),
                                     radius: radius,
                                     startAngle: 180 / 180 * .pi,
                                     endAngle: 270 / 180 * .pi,
                                     clockwise: true)
            path.append(path2)
            
            // 3.画竖线
            let path3 = UIBezierPath()
            let xPosition = nodeSize - endX
            path3.move(to: CGPoint(x: xPosition, y: yPosition))
            switch span {
            case .LAST:
                path3.addLine(to: CGPoint(x: xPosition, y: nodeSize - lineWidth * 0.5))
                path3.close()
                path3.lineWidth = lineWidth
                path3.lineJoinStyle = .round
                lineColor.set()
                path3.stroke()
            case .NORMAL, .FIRST:
                path3.addLine(to: CGPoint(x: xPosition, y: nodeSize))
            }
            
            path.append(path3)
            
            break
        }
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        context.setFillColor(lineColor.cgColor)

        context.addPath(path.cgPath)
        context.drawPath(using: .stroke)
        
        dotPath.close()
        dotPath.lineWidth = lineWidth * 4
        dotPath.lineJoinStyle = .round
        dotColor.set()
        dotPath.stroke()
    }
    
}

extension StripLightsNode {
    
    func firstNodeLeftWidthPadding() -> CGFloat {
        return self.nodeSize / 3.0
    }
    
    func firstNodeTopHeightPadding() -> CGFloat {
        return self.nodeSize / 10.0
    }
    
    // For TOP_TO_LEFT & TOP_TO_RIGHT
    func getFirstLineVerticalGauge() -> CGFloat {
        return self.nodeSize / 8.0
    }
    
    // For LEFT_TO_BOTTOM & RIGHT_TO_BOTTOM
    func getFirstLineHorizontalGauge() -> CGFloat {
        return self.nodeSize / 4.0
    }
}

extension StripLightsNode {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        if style == .WITH_BEAD {
            if self.dotColor != UIColor.red {
                self.dotColor = UIColor.red
                self.setNeedsDisplay()
            }
        } else {
            if self.lineColor != UIColor.red {
                self.lineColor = UIColor.red
                
                print("\(self), touchesBegan ...")
                self.setNeedsDisplay()
            }
        }
    }
    
}
