//
//  ColumnFlowLayout.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 06/11/2023.
//

import UIKit

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    private let cellHeight: CGFloat = 250.0
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let numberOfCollumns = numberOfCollumns()
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        let cellWidth = (availableWidth / CGFloat(numberOfCollumns)).rounded(.down) - 20
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
    
    private func numberOfCollumns() -> Int {
        if collectionView?.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular {
            return 1
        } else {
            return 2
        }
    }
}
