//
//  ViewController.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit
import MelbourneTestProjectCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.dispatch(FactsFlow.factsSync())
    }

}
