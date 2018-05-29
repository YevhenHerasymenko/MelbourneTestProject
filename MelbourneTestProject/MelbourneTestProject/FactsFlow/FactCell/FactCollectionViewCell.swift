//
//  FactCollectionViewCell.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit

class FactCollectionViewCell: UICollectionViewCell, CellModelSupport {
    
    struct Model: CellModel {
        let imageUrl: URL
    }
    
    static var identifier: String = String(describing: FactCollectionViewCell.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    
    var model: Model! {
        didSet {

            render()
        }
    }
    
    private func render() {
        
    }

}
