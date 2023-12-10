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
    
    var nodes: [StripLightsView.AllType] = [(StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.FIRST),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.TOP_TO_LEFT, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.RIGHT_TO_BOTTOM, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.TOP_TO_LEFT, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.RIGHT_TO_BOTTOM, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL),
                                            (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.LAST)]
    
    var fixCount: Int = 5
    var stripStyle: String = "WITH_BEAD"
    
    let stripBackgroundColor: String = "0xF2F2F7"
    let touchingMode = "TOUCH" // or "CLICK"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleSize = self.view.frame.size.width / Double(fixCount)
        let mainStackView = StripLightsView(dataSource: nodes,
                                            dimension: fixCount,
                                            singleSize: singleSize,
                                            stripBackgroundColor: stripBackgroundColor,
                                            stripStyle: stripStyle)
        
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
