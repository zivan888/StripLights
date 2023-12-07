//
//  ViewController.swift
//  StripLights
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    typealias AllType = (StripNodeDirection, StripNodeSpan, StripStyle)
    
    var dataSource: [AllType] = [(StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.FIRST, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_LEFT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.RIGHT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_LEFT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.RIGHT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.LAST, StripStyle.ONLY_LINE)]
    var singleSize = 0.0
    var dimension = 0.0
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .fill
        return stackView
    }()
    
    var horizontalStackView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimension = 5
        singleSize = self.view.frame.size.width / dimension
        
        view.addSubview(mainStackView)
        mainStackView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(singleSize * dimension)
            // 高度需要判断
            let n = dataSource.count / Int(dimension)
            let m = dataSource.count % Int(dimension)
            if m == 0 {
                make.height.equalTo(singleSize * Double(n))
            } else {
                make.height.equalTo(singleSize * (Double(n) + 1))
            }
            
        }
        
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
                horizontalStackView = UIStackView()
                horizontalStackView!.axis = .horizontal
                horizontalStackView!.distribution = .fillEqually
                horizontalStackView!.spacing = 0
                horizontalStackView!.alignment = .fill
                
                mainStackView.addArrangedSubview(horizontalStackView!)
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
