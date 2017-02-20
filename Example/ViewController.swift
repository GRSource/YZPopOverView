//
//  ViewController.swift
//  YZPopOverView
//
//  Created by iOS_Dev5 on 2017/2/20.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit
let kCellIdentifier_YZSubjectCell = "kCellIdentifier_YZSubjectCell"
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(myTableView)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(YZTestCell.self, forCellReuseIdentifier: kCellIdentifier_YZSubjectCell)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: YZTestCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_YZSubjectCell, for: indexPath) as! YZTestCell
        cell.btnAction = { sender in
            let rectInTableView = tableView.rectForRow(at: indexPath)
            var rectInView = tableView.convert(rectInTableView, to: UIApplication.shared.keyWindow!)
            rectInView.origin.x += sender.frame.origin.x
            rectInView.origin.y += sender.frame.origin.y
            rectInView.size = sender.frame.size
            let menuItem = YZPopOverItem.item("菜单一", image: UIImage(named: "action_icon"), target: self, action: #selector(self.click))
            menuItem.foreColor = .black
            let menuItem2 = YZPopOverItem.item("菜单二", image: UIImage(named: "action_icon"), target: self, action: #selector(self.click))
            YZPopOverView.showMenuInView(UIApplication.shared.keyWindow!, fromRect: rectInView, menuItems: [menuItem, menuItem2])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(testViewController(), animated: true)
    }
    
    func click() {
        print("123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

