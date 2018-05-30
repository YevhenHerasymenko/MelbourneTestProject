//
//  FactDetailsViewController.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit
import ReSwift
import MelbourneTestProjectCore
import Kingfisher

class FactDetailsViewController: UIViewController {

  struct Model: ViewControllerModel {
    let image: URL?
    let title: String?
    let description: String?
  }

  var model: Model? {
    didSet {
      model.flatMap { [unowned self] in self.render($0) }
    }
  }

  @IBOutlet private var imageView: UIImageView!
  @IBOutlet private var descriptionLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainStore.subscribe(self) { $0.select(FactDetailsDataTransformer.transform) }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mainStore.unsubscribe(self)
  }

}

// MARK: - store subscriber
extension FactDetailsViewController: StoreSubscriber {

  func newState(state: Model) {
    // model update
    model = state
  }

}

// MARK: - model supporting
extension FactDetailsViewController: ViewControllerModelSupport {

  func render(_ model: Model) {
    title = model.title
    descriptionLabel.text = model.description
    imageView.kf.setImage(with: model.image)
  }

}
