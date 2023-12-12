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
    
    
    let nodes = "[{\"color\":\"#000000\",\"backgroundColor\":\"#cccccc\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"}]"
    
    var fixCount: Int = 5
    var stripStyle: String = "WITH_BEAD"
    
    let stripBackgroundColor: String = "#FFFFFF"
    let touchingMode = "TOUCH" // or "CLICK"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func jsonStrToDic(jsonString: String) -> [[String: Any]]? {
            
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        print(jsonArray)
                        return jsonArray
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            
            return nil
        }
        
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
            let n = (jsonStrToDic(jsonString: nodes)?.count ?? 0) / fixCount
            let m = (jsonStrToDic(jsonString: nodes)?.count ?? 0) % fixCount
            if m == 0 {
                make.height.equalTo(singleSize * Double(n))
            } else {
                make.height.equalTo(singleSize * (Double(n) + 1))
            }
        }
    }
}
