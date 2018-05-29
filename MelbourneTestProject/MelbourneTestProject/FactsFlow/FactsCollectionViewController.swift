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
import Kingfisher

class FactsCollectionViewController: UICollectionViewController {
    
    enum Status {
        case loading
        case data
        case error(ErrorModel)
    }
    
    struct Model: ViewControllerModel {
        let status: Status
        let images: [URL?]?
        let title: String?
    }
    
    var model: Model? {
        didSet {
            model.flatMap { [unowned self] in self.render($0) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            collectionView?.prefetchDataSource = self
        }
        setupCollectionView()
        mainStore.dispatch(FactsFlow.factsSync())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self) { $0.select(FactsDataTransformer.transform) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainStore.unsubscribe(self)
    }
    
    private func setupCollectionView() {
        collectionView?.register(FactCollectionViewCell.nib,
                                 forCellWithReuseIdentifier: FactCollectionViewCell.identifier)
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 300)
        }
    }

}

// MARK: - Collection View Delegate and Data Source
extension FactsCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let images = model?.images else {
            fatalError()
        }
        
        let callback = { [unowned collectionView] in
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        let cell: FactCollectionViewCell = collectionView.dequeCell(
            forRowAt: indexPath,
            with: FactCollectionViewCell.Model(imageUrl: images[indexPath.row], callback: callback)
        )
        return cell
    }
    
}

// MARK: - Prefetch
extension FactsCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let images = model?.images else {
            return
        }
        let urls = indexPaths.compactMap { images[$0.row] }
        ImagePrefetcher(urls: urls).start()
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
            collectionView?.reloadData()
        case .error(let error):
            showError(model: error) {
                mainStore.dispatch(ErrorFlow.resetError())
            }
        }
    }
    
}
