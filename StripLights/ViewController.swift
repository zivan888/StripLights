//
//  ViewController.swift
//  StripLights
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var dataSource: [StripLightsContainer.AllType] = [(StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.FIRST, StripStyle.ONLY_LINE),
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
                                                      (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dimension: Double = 5
        let singleSize = self.view.frame.size.width / dimension
        let mainStackView = StripLightsContainer(dataSource: dataSource, dimension: dimension, singleSize: singleSize)
        
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
    }
}
