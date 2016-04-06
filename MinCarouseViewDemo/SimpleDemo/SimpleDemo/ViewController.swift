//
//  ViewController.swift
//  SimpleDemo
//
//  Created by songmin.zhu on 16/4/6.
//  Copyright © 2016年 zhusongmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var carouse1: MinCarouseView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageArray = [
            UIImage(named: "bamboo")!,
            UIImage(named: "plum blossom")!,
            UIImage(named: "lotus")!
        ]
        //storyboard创建
        carouse1.imageArray = imageArray
        
        let urlArray = [
            "http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-04.png",
            "http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-05.png",
            "http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-03.png"
        ]
        
        // 代码创建
        let carouse2Frame = CGRect(
            x: carouse1.frame.origin.x,
            y: carouse1.frame.height + 20.0,
            width: UIScreen.mainScreen().bounds.width - 40.0,
            height: 200.0)
        let carouse2 = MinCarouseView(frame: carouse2Frame, imageArray: urlArray)
        self.view.addSubview(carouse2)
        carouse2.scrollInterVal = 2.0
        carouse2.tapClosure = { index in
            print(index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

