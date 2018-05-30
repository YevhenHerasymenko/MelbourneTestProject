//
//  SplitViewController.swift
//  MelbourneTestProject
//
//  Created by YevhenHerasymenko on 5/30/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      minimumPrimaryColumnWidth = view.frame.width*0.3
      maximumPrimaryColumnWidth = view.frame.width*0.3
      preferredDisplayMode = .allVisible
    }

}
