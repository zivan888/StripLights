//
//  StripLightsContainer.swift
//  StripLights
//
//  Created by ThomasLau on 2023/12/7.
//

import UIKit

extension UIView {
    
    class func getAllLayerSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllLayerSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
}

extension StripLightsView {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard touchingMode == "CLICK" else { return }
        guard let touch = touches.first else { return }
        let touchePoint = touch.location(in: self)
        
        for subView in UIView.getAllLayerSubviews(from: self) {
            let insidePoint = self.convert(touchePoint, to: subView)
            let hitView = subView.hitTest(insidePoint, with: event)

            if let hitView = hitView as? StripLightsNode, hitView.lineColor != UIColor.red {
                
                if hitView.style == .WITH_BEAD {
                    if hitView.dotColor != UIColor.red {
                        hitView.dotColor = UIColor.red
                        hitView.setNeedsDisplay()
                    }
                } else {
                    if hitView.lineColor != UIColor.red {
                        hitView.lineColor = UIColor.red
                        
                        print("\(self), touchesBegan ...")
                        hitView.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard touchingMode == "TOUCH" else { return }
        guard let touch = touches.first else { return }
        let touchePoint = touch.location(in: self)
        
        for subView in UIView.getAllLayerSubviews(from: self) {
            let insidePoint = self.convert(touchePoint, to: subView)
            let hitView = subView.hitTest(insidePoint, with: event)

            if let hitView = hitView as? StripLightsNode, hitView.lineColor != UIColor.red {
                
                if hitView.style == .WITH_BEAD {
                    if hitView.dotColor != UIColor.red {
                        hitView.dotColor = UIColor.red
                        hitView.setNeedsDisplay()
                    }
                } else {
                    if hitView.lineColor != UIColor.red {
                        hitView.lineColor = UIColor.red
                        
                        print("\(self), touchesBegan ...")
                        hitView.setNeedsDisplay()
                    }
                }
            }
        }
        
    }
}

class StripLightsView: UIStackView {
    
    typealias StripNodeColor = UIColor
    typealias StripNodeBackColor = UIColor
    typealias AllType = (StripNodeDirection, StripNodeSpan, StripNodeColor, StripNodeBackColor)

    var dataSource: [[String: Any]]?
    var dimension: Int = 0
    var horizontalStackView: UIStackView?
    var singleSize: Double = 0.0
    var stripStyle: StripStyle = .ONLY_LINE
    var stripBackgroundColor: UIColor?
    var touchingMode: String = ""
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init(dataSource: [[String: Any]],
                     dimension: Int,
                     singleSize: Double,
                     stripBackgroundColor: String?,
                     stripStyle: String,
                     touchingMode: String)
    {
        self.init()
        
        self.dataSource = dataSource
        self.dimension = dimension
        self.singleSize = singleSize
        self.touchingMode = touchingMode
        
        if stripStyle == "ONLY_LINE" {
            self.stripStyle = .ONLY_LINE
        } else if stripStyle == "WITH_BEAD" {
            self.stripStyle = .WITH_BEAD
        }
        
        if let stripBackgroundColor = stripBackgroundColor {
            let tempBackColor = hexStringToInt(from: stripBackgroundColor)
            self.stripBackgroundColor = UIColor(hex: tempBackColor)
        }
        
        setupView()
    }
    
    func hexStringToInt(from: String) -> Int {
        let str = from.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 { // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    func setupView() {
        
        guard let dataSource = dataSource, dimension > 1 else { return }
        
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 0
        self.alignment = .fill
        
        var isOdd = false
        var finalDataArray = [AllType]()
        var tempDataArray = [AllType]()
        var rowCount = 0
        var tempStripNodeDirectionArr: [StripNodeDirection] = [.TOP_TO_RIGHT, .LEFT_TO_BOTTOM, .TOP_TO_LEFT, .RIGHT_TO_BOTTOM]
        var stripNodeDirectionArr: [StripNodeDirection] = []
        
        for _ in 0...(dataSource.count / dimension + dataSource.count % dimension) {
            
            tempStripNodeDirectionArr.append(.TOP_TO_RIGHT)
            tempStripNodeDirectionArr.append(.LEFT_TO_BOTTOM)
            tempStripNodeDirectionArr.append(.TOP_TO_LEFT)
            tempStripNodeDirectionArr.append(.RIGHT_TO_BOTTOM)
        }
        
        for nodeDirection in tempStripNodeDirectionArr {
            
            stripNodeDirectionArr.append(nodeDirection)
            
            if (nodeDirection == .TOP_TO_RIGHT) || (nodeDirection == .TOP_TO_LEFT) {
                for _ in 0..<(dimension - 2) {
                    stripNodeDirectionArr.append(.HORIZONTAL)
                }
            }
        }
        
        for (index, item) in dataSource.enumerated() {
            
            // 这里需要对每个Node从字典类型转换到AllType类型
            // (StripNodeDirection, StripNodeSpan, StripNodeColor, StripNodeBackColor)
            var finalItem: AllType = (.HORIZONTAL, .NORMAL, .white, .black)
            
            if index < stripNodeDirectionArr.count {
                finalItem.0 = stripNodeDirectionArr[index]
            }
            
            if index == 0 {
                finalItem.1 = .FIRST
            } else if index == dataSource.count - 1 {
                finalItem.1 = .LAST
            } else {
                finalItem.1 = .NORMAL
            }
            
            if let color = item["color"] as? String {
                let finalColor = hexStringToInt(from: color)
                finalItem.2 = UIColor.init(hex: finalColor)
            }
            if let stripBackgroundColor = stripBackgroundColor {
                finalItem.3 = stripBackgroundColor
            } else if let backgroundColor = item["backgroundColor"] as? String {
                let finalBackgroundColor = hexStringToInt(from: backgroundColor)
                finalItem.3 = UIColor.init(hex: finalBackgroundColor)
            }
            // 换行
            if index % Int(dimension) == 0 && index != 0 {
                isOdd = !isOdd
                rowCount += 1
            }
            // 当为偶数行时逆序排列
            if isOdd {
                tempDataArray.append(finalItem)
            } else {
                tempDataArray = tempDataArray.reversed()
                finalDataArray += tempDataArray
                finalDataArray.append(finalItem)
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
        
        for (index, finalItem) in finalDataArray.enumerated() {
            
            // 换行
            if index % Int(dimension) == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView!.axis = .horizontal
                horizontalStackView!.distribution = .fillEqually
                horizontalStackView!.spacing = 0
                horizontalStackView!.alignment = .fill
                
                self.addArrangedSubview(horizontalStackView!)
            }
            
            let stripLightView = StripLightsNode(frame: CGRect.zero, 
                                                 dotColor: finalItem.2,
                                                 bgColor: finalItem.3,
                                                 direction: finalItem.0,
                                                 span: finalItem.1,
                                                 nodeSize: singleSize)
            stripLightView.style = stripStyle
            stripLightView.touchingMode = touchingMode
            
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

