//
//  ViewIdentifier.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/29/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import UIKit

protocol ViewIdentifier {
    static var identifier: String { get }
}

protocol ReusableView: ViewIdentifier {
    static var nib: UINib { get }
}

protocol ViewNib: ReusableView {
    associatedtype ViewType
    
    static var instanceFromNib: ViewType { get }
}

protocol CellModel {}

protocol CellModelSupport: ReusableView {
    associatedtype ModelType: CellModel
    
    var model: ModelType! { get set }
}

extension CellModelSupport where Self: UICollectionViewCell {
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UICollectionView {
    
    func dequeCell<A: CellModelSupport>(forRowAt indexPath: IndexPath,
                                        with model: A.ModelType) -> A {
        guard var cell = dequeueReusableCell(withReuseIdentifier: A.identifier, for: indexPath) as? A else {
            fatalError("incorrect cell")
        }
        cell.model = model
        return cell
    }
    
}
