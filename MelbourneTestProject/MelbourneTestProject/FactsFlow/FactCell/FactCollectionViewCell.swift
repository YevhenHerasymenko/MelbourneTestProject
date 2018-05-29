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
        let callback: (() -> Void)
    }
    
    static var identifier: String = String(describing: FactCollectionViewCell.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    var model: Model! {
        didSet {
            render()
        }
    }
    
    private func render() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: model.imageUrl) { [weak self] (_, _, _, _)  in
            self?.model.callback()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.width
        widthConstraint.constant = screenWidth
    }

}
