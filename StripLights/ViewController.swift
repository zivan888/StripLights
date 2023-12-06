//
//  ViewController.swift
//  StripLights
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let rect = CGRectMake(100, 100, 100, 100)
        let nodeView = StripLightsNode(frame: rect, color: .red, bgColor: .blue, direction: .LEFT_TO_BOTTOM, span: .LAST, style: .ONLY_LINE)
//        let nodeView = StripLightsNode(frame: rect, color: .red, bgColor: .green, direction: .RIGHT_TO_BOTTOM, span: .FIRST, style: .ONLY_LINE)

        view.addSubview(nodeView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.pushViewController(StripLightsViewController(), animated: true)
    }

}

