//
//  FactCollectionViewCell.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Kingfisher

class FactCollectionViewCell: UICollectionViewCell, CellModelSupport {

  struct Model: CellModel {
    let imageUrl: URL?
    let callback: ((CGFloat?) -> Void)
  }

  static var identifier: String = String(describing: FactCollectionViewCell.self)

  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var noImageLabel: UILabel!

  var model: Model! {
    didSet {
      render()
    }
  }

  private func render() {
    if let url = model.imageUrl {
      noImageLabel.isHidden = true
      imageView.isHidden = false
      imageView.kf.setImage(with: url) { [weak self] (image, _, _, _)  in
        guard let strongSelf = self else {
          return
        }
        guard let image = image else {
          strongSelf.showNoImage()
          strongSelf.model.callback(nil)
          return
        }
        strongSelf.noImageLabel.isHidden = true
        strongSelf.imageView.isHidden = false
        if strongSelf.frame.width > image.size.width {
          strongSelf.model.callback(image.size.height)
        } else {
          let proportion = strongSelf.frame.width / image.size.width
          let height = image.size.height * proportion
          strongSelf.model.callback(height)
        }
      }
    } else {
      showNoImage()
    }

  }

  private func showNoImage() {
    noImageLabel.isHidden = false
    imageView.isHidden = true
  }

}
