//
//  ViewController.swift
//  DashboardDemo
//
//  Created by 四川 wwgps on 2020/11/26.
//

import UIKit
import DashboardDemo

class ViewController: UIViewController {

    let p:PointView = PointView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    
    var value:Int = 0{
        didSet{
            p.setValue(value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(p)
        
    }
    
    @IBAction func onAction_plus(_ sender: Any) {
        guard value < 100 else {return}
        value += 10
    }
    
    @IBAction func onAction_minus(_ sender: Any) {
        guard value >= 10 else {
            return
        }
        value -= 10
    }
}

