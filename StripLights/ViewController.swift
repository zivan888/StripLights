//
//  ViewController.swift
//  StripLights
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit
import SnapKit

extension UIColor {
    
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16)/255.0,
            green: CGFloat((hex & 0xFF00) >> 8)/255.0,
            blue: CGFloat((hex & 0xFF))/255.0,
            alpha: alpha
        )
    }
}

class ViewController: UIViewController {
    
    var nodes: [[String: Any]] = [["color": "#FF0000", "backgroundColor": "#00FF00"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#00FF00"],
                                  ["color": "#FF0000", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#0000FF", "backgroundColor": "#FFFFFF"],
                                  ["color": "#FF0000", "backgroundColor": "#00FF00"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#0000FF", "backgroundColor": "#FFFFFF"],
                                  ["color": "#FF0000", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#00FF00"],
                                  ["color": "#0000FF", "backgroundColor": "#FFFFFF"],
                                  ["color": "#FF0000", "backgroundColor": "#FFFFFF"],
                                  ["color": "#00FF00", "backgroundColor": "#FFFFFF"],
                                  ["color": "#0000FF", "backgroundColor": "#FFFFFF"]]
    
    var fixCount: Int = 5
    var stripStyle: String = "WITH_BEAD"
    
    let stripBackgroundColor: String = "#FFFFFF"
    let touchingMode = "CLICK" // or "CLICK"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleSize = self.view.frame.size.width / Double(fixCount)
        let mainStackView = StripLightsView(dataSource: nodes,
                                            dimension: fixCount,
                                            singleSize: singleSize,
                                            stripBackgroundColor: stripBackgroundColor,
                                            stripStyle: stripStyle,
                                            touchingMode: touchingMode)
        
        view.addSubview(mainStackView)
        mainStackView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(singleSize * Double(fixCount))
            // 高度需要判断
            let n = nodes.count / fixCount
            let m = nodes.count % fixCount
            if m == 0 {
                make.height.equalTo(singleSize * Double(n))
            } else {
                make.height.equalTo(singleSize * (Double(n) + 1))
            }
        }
    }
}
