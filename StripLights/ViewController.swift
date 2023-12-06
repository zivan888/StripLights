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
                                 (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_LEFT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.RIGHT_TO_BOTTOM, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.TOP_TO_RIGHT, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.HORIZONTAL, StripNodeSpan.NORMAL, StripStyle.ONLY_LINE),
                                 (StripNodeDirection.LEFT_TO_BOTTOM, StripNodeSpan.LAST, StripStyle.ONLY_LINE)]
    var singleSize = 0.0
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.backgroundColor = .cyan
        return stackView
    }()
    
    var horizontalStackView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleSize = self.view.frame.size.width / (CGFloat(dataSource.count) / 3)
        
        view.addSubview(mainStackView)
        mainStackView.backgroundColor = UIColor.cyan
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(singleSize * 3)
        }
        
        for (index, item) in dataSource.enumerated() {
            
            let stripLightView = StripLightsNode(frame: CGRect.zero)
            stripLightView.nodeSize = singleSize
            stripLightView.direction = item.0
            stripLightView.span = item.1
            stripLightView.style = item.2
            
            // 换行
            if index % 3 == 0 {
                horizontalStackView = UIStackView()
                horizontalStackView!.axis = .horizontal
                horizontalStackView!.distribution = .fillEqually
                horizontalStackView!.spacing = 0
                horizontalStackView!.alignment = .fill
                
                mainStackView.addArrangedSubview(horizontalStackView!)
            }
            
            horizontalStackView!.addArrangedSubview(stripLightView)
        }

    }
}
