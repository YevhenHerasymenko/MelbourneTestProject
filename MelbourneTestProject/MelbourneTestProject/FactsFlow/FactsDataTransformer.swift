//
//  FactsDataTransformer.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import MelbourneTestProjectCore

struct FactsDataTransformer {
    
    static func transform(state: AppState) -> FactsCollectionViewController.Model {
        return .init(status: .loading, error: nil)
    }
    
}
