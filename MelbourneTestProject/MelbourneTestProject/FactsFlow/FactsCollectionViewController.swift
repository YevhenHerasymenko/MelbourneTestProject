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

  private struct Constants {
    static let defaultCellHeight: CGFloat = 60
  }

  private enum Segue: String {
    case showDetails
  }

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

  private var cellHeights: [CGFloat] = []
  private let refresh: UIRefreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()

    refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    if #available(iOS 10.0, *) {
      collectionView?.refreshControl = refresh
    } else {
      collectionView?.addSubview(refresh)
    }
    refreshAction()
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
    if #available(iOS 10.0, *) {
      collectionView?.prefetchDataSource = self
    }
    collectionView?.register(FactCollectionViewCell.nib,
                             forCellWithReuseIdentifier: FactCollectionViewCell.identifier) }
}

// MARK: - Actions
extension FactsCollectionViewController {

  @objc private func refreshAction() {
    mainStore.dispatch(FactsFlow.factsSync())
  }

}

// MARK: - Collection View Delegate and Data Source
extension FactsCollectionViewController: UICollectionViewDelegateFlowLayout {

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

    let callback: ((CGFloat?) -> Void) = { [unowned collectionView, unowned self] height in
      collectionView.collectionViewLayout.invalidateLayout()
      self.cellHeights[indexPath.row] = height ?? Constants.defaultCellHeight
    }

    let cell: FactCollectionViewCell = collectionView.dequeCell(
      forRowAt: indexPath,
      with: FactCollectionViewCell.Model(imageUrl: images[indexPath.row], callback: callback)
    )
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.row < cellHeights.count - 1 {
      return CGSize(width: collectionView.frame.width, height: cellHeights[indexPath.row])
    } else {
      cellHeights.append(Constants.defaultCellHeight)
      return CGSize(width: collectionView.frame.width, height: Constants.defaultCellHeight)
    }
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    mainStore.dispatch(FactsFlow.selectFact(by: indexPath.row))
    performSegue(withIdentifier: Segue.showDetails.rawValue, sender: nil)
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
      refresh.endRefreshing()
      collectionView?.reloadData()
    case .error(let error):
      refresh.endRefreshing()
      showError(model: error) {
        mainStore.dispatch(ErrorFlow.resetError())
      }
    }
    title = model.title
  }

}
