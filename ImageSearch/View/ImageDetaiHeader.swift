//
//  ImageDetaiHeader.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/03.
//

import UIKit

class ImageDetailHeader: UIView {
    
    // MARK: - Properties
    
    let detailImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(detailImage)
        
        detailImage.addConstraintsToFillView(self)
//        detailImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
