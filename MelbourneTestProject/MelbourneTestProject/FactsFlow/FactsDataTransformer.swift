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
        let data = state.factsState.factsGroup?.rows.map { $0.imageURL }
        let title = state.factsState.factsGroup?.title
        let status: FactsCollectionViewController.Status
        if let serverError = state.errorState.error {
            status = .error(ErrorModel(title: nil, message: serverError.localizedDescription))
        } else {
            status = state.factsState.isLoading ? .loading : .data
        }
        return FactsCollectionViewController.Model(status: status, images: data, title: title)
    }
    
}
