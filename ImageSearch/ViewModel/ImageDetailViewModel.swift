//
//  ImageDetailViewModel.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/03.
//

import UIKit

import Kingfisher

struct ImageDetailViewModel {
    
    var imageInfo: Results
    var view: UIView
    
    init(imageInfo: Results, view: UIView) {
        self.imageInfo = imageInfo
        self.view = view
    }
    
    var detailImageURL: URL {
        return URL(string: imageInfo.image_url) ?? URL(string: "")!
    }
    
}
