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
    
    
    let nodes = "[{\"color\":\"#000000\",\"backgroundColor\":\"#cccccc\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"},{\"color\":\"#000000\"}]"
    
    var fixCount: Int = 5
    var stripStyle: String = "ONLY_LINE"//"WITH_BEAD"
    
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
        
        let v = UIView()
        self.view.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        v.layoutIfNeeded()
        
        let mainStackView = StripLightsView()
        view.addSubview(mainStackView)
        
        mainStackView.dataSource = jsonStrToDic(jsonString: nodes)
        mainStackView.dimension = fixCount
        if stripStyle == "ONLY_LINE" {
            mainStackView.stripStyle = .ONLY_LINE
        } else if stripStyle == "WITH_BEAD" {
            mainStackView.stripStyle = .WITH_BEAD
        }
        mainStackView.touchingMode = touchingMode
        mainStackView.setupView()
    }
}
