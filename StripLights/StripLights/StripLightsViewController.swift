//
//  StripLightsViewController.swift
//  smartunify
//
//  Created by zhangxueyang on 2023/12/5.
//

import UIKit

class StripLightsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let rect = CGRectMake(100, 100, 100, 100)
        let nodeView = StripLightsNode(frame: rect, color: .red, bgColor: .green, direction: .HORIZONTAL, span: .FIRST, style: .ONLY_LINE)
        view.addSubview(nodeView)
        
        
    }

}
