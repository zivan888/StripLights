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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(StripLightsViewController(), animated: true)
    }

}

