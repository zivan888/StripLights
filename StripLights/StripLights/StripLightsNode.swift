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
    
    var nodeWidth: CGFloat {
        return frame.size.width
    }
    
    var nodeHeight: CGFloat {
        return frame.size.height
    }

    init(frame: CGRect, color: UIColor = .white, bgColor: UIColor = .red, direction: StripNodeDirection = .TOP_TO_RIGHT, span: StripNodeSpan = .FIRST, style: StripStyle = .ONLY_LINE) {
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
        
        switch direction {
        case .TOP_TO_RIGHT: 
            let startX = firstNodeLeftWidthPadding()
            let startY = firstNodeTopHeightPadding()
            
            let lineLength = getFirstLineVerticalGauge()
            let topRect = CGRectMake(startX, startY, 0.01, lineLength-1)
            let cornerRadii = lineWidth/2.0
            let topPath = UIBezierPath.init(roundedRect: topRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadii, height: 1))
            path.append(topPath)
            
            let radius = (nodeWidth - startX) * 0.5
            let arcCenter = CGPoint(x: startX + radius, y: topRect.maxY)
            let circlePath = UIBezierPath.init(arcCenter: arcCenter, radius: radius, startAngle: Double.pi/2, endAngle: Double.pi, clockwise: true)
            path.append(circlePath)
            
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: startX + radius, y: topRect.maxY + radius))
            rightPath.addLine(to: CGPoint(x: nodeWidth, y: topRect.maxY + radius))
            path.append(rightPath)
            
            break
            
        case .HORIZONTAL:
            
            break
            
        case .LEFT_TO_BOTTOM:
            
            break
            
        case .TOP_TO_LEFT:
            
            break
            
        case .RIGHT_TO_BOTTOM:
            
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
        return self.nodeWidth / 3.0
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


