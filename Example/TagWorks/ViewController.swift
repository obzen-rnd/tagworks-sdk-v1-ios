//
//  ViewController.swift
//  TagWorks
//
//  Created by 68175154 on 07/31/2023.
//  Copyright (c) 2023 68175154. All rights reserved.
//

import UIKit
import TagWorks

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Tracker.shared.pageView(pagePath: ["Main","Home"], pageTitle: "홈스크린")
        //Tracker.shared.event(eventType: "Click")
        
        Tracker.shared.event(eventType: "Search", dimensions: [Dimension(index: 0, value: "디멘젼0"), Dimension(index: 1, value: "디멘젼1")], customUserPath: "/main/home")
        //Tracker.shared.dispatch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

