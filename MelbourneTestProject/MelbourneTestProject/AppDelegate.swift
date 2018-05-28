//
//  AppDelegate.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit
import MelbourneTestProjectCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        mainStore.dispatch(
            MelbourneTestProjectCore.SideEffects.setupNetworkSessionBuilder(builder: SessionManagerBuilder())
        )
        return true
    }

}
