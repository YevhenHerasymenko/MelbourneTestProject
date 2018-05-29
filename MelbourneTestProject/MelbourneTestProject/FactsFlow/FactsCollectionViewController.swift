//
//  FactsCollectionViewController.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit
import ReSwift
import MelbourneTestProjectCore

class FactsCollectionViewController: UICollectionViewController {
    
    enum Status {
        case loading
        case data(cells: [FactCollectionViewCell.Model])
    }
    
    struct Model: ViewControllerModel {
        let status: Status
        let error: ErrorModel?
    }
    
    var model: Model? {
        didSet {
            model.flatMap { [unowned self] in self.render($0) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self) { $0.select(FactsDataTransformer.transform) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainStore.unsubscribe(self)
    }
    
    private func registerNib() {
        collectionView?.register(FactCollectionViewCell.nib,
                                 forCellWithReuseIdentifier: FactCollectionViewCell.identifier)
    }

}

// MARK: - Collection View Delegate and Data Source
extension FactsCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FactCollectionViewCell.identifier,
                                                      for: indexPath)
        return cell
    }
    
}

// MARK: - store subscriber
extension FactsCollectionViewController: StoreSubscriber {
    
    func newState(state: Model) {
        // model update
        model = state
    }
    
}

// MARK: - model supporting
extension FactsCollectionViewController: ViewControllerModelSupport, ErrorHandlerController {
    
    func render(_ model: Model) {
        switch model.status {
        case .loading:
            break
        case .data:
            break
        }
        if let error = model.error {
            showError(model: error, completion: nil)
        }
    }
    
}
