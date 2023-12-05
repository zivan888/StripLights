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
        let nodeView = StripLightsNode(frame: rect, color: .red, bgColor: .green, direction: .TOP_TO_LEFT, span: .FIRST, style: .ONLY_LINE)
        view.addSubview(nodeView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.navigationController?.pushViewController(StripLightsViewController(), animated: true)
    }

}

