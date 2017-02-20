//
//  testViewController.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/15.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let btn = UIButton(type: .contactAdd)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        view.addSubview(btn)
    }

    func click() {
        print("隐藏和显示tabbaritem")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
