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
    @IBOutlet private weak var noImageLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    var model: Model! {
        didSet {
            render()
        }
    }
    
    private func render() {
        imageView.kf.indicatorType = .activity
        if let url = model.imageUrl {
            imageView.kf.setImage(with: url) { [weak self] (image, _, _, _)  in
                let isExistImage = image != nil
                self?.noImageLabel.isHidden = isExistImage
                self?.imageView.isHidden = !isExistImage
                guard isExistImage else {
                    return
                }
                DispatchQueue.main.async {
                    //self?.model.callback()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.isHidden = false
        noImageLabel.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.width
        widthConstraint.constant = screenWidth
    }

}
