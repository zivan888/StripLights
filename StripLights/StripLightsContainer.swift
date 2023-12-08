//
//  StripLightsContainer.swift
//  StripLights
//
//  Created by ThomasLau on 2023/12/7.
//

import UIKit

class HorizontalStackView: UIStackView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

extension UIView {
    
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
}

extension StripLightsContainer {
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchePoint = touch.location(in: self)
        
        for subView in UIView.getAllSubviews(from: self) {
            let insidePoint = self.convert(touchePoint, to: subView)
            let hitView = subView.hitTest(insidePoint, with: event)

            if let hitView = hitView as? StripLightsNode, hitView.color != UIColor.red {

                hitView.color = UIColor.red
                hitView.setNeedsDisplay()
                print("ddd")
            }
        }
        
    }
}

class StripLightsContainer: UIStackView {
    
    typealias AllType = (StripNodeDirection, StripNodeSpan, StripStyle)

    var dataSource: [AllType]?
    var dimension: Double = 0.0
    var horizontalStackView: HorizontalStackView?
    var singleSize: Double = 0.0
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init(dataSource: [AllType], dimension: Double, singleSize: Double) {
        self.init()
        
        self.dataSource = dataSource
        self.dimension = dimension
        self.singleSize = singleSize
        
        setupView()
    }
    
    func setupView() {
        
        guard let dataSource = dataSource else { return }
        
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 0
        self.alignment = .fill
        
        var isOdd = false
        var finalDataArray = [AllType]()
        var tempDataArray = [AllType]()
        var rowCount = 0
        
        for (index, item) in dataSource.enumerated() {
            // 换行
            if index % Int(dimension) == 0 && index != 0 {
                isOdd = !isOdd
                rowCount += 1
            }
            // 当为偶数行时逆序排列
            if isOdd {
                tempDataArray.append(item)
            } else {
                tempDataArray = tempDataArray.reversed()
                finalDataArray += tempDataArray
                finalDataArray.append(item)
                tempDataArray.removeAll()
            }
        }
        
        if tempDataArray.count > 0 {
            if isOdd {
                finalDataArray += (tempDataArray.reversed())
            } else {
                finalDataArray += tempDataArray
            }
        }
        
        var lastHorizontalStackView: UIStackView?
        
        for (index, item) in finalDataArray.enumerated() {
            
            // 换行
            if index % Int(dimension) == 0 {
                horizontalStackView = HorizontalStackView()
                horizontalStackView!.axis = .horizontal
                horizontalStackView!.distribution = .fillEqually
                horizontalStackView!.spacing = 0
                horizontalStackView!.alignment = .fill
                
                self.addArrangedSubview(horizontalStackView!)
            }
            
            let stripLightView = StripLightsNode(frame: CGRect.zero)
            stripLightView.nodeSize = singleSize
            stripLightView.direction = item.0
            stripLightView.span = item.1
            stripLightView.style = item.2
            
            horizontalStackView!.addArrangedSubview(stripLightView)
            
            if index == finalDataArray.count - 1 {
                lastHorizontalStackView = horizontalStackView
            }
        }
        
        // 最后一行有空余区间，则补全
        let tempDelata = Int(dimension) - finalDataArray.count % Int(dimension)
        if tempDelata > 0 && (finalDataArray.count % Int(dimension)) != 0 {
            for _ in 0..<tempDelata {
                let n = dataSource.count / Int(dimension)
                let m = dataSource.count % Int(dimension)
                var tempLine = n
                if m != 0 {
                    tempLine += 1
                }
                // 奇数行左对齐
                if tempLine % 2 != 0 {
                    lastHorizontalStackView?.addArrangedSubview(UIView())
                // 偶数行右对齐
                } else {
                    lastHorizontalStackView?.insertArrangedSubview(UIView(), at: 0)
                }
            }
        }
    }
}

