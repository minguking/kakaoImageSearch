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
    
    init(imageInfo: Results) {
        self.imageInfo = imageInfo
    }
    
    var detailImageURL: URL {
        return URL(string: imageInfo.image_url) ?? URL(string: "")!
    }
    
    var siteNameAndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return "출처: \(imageInfo.display_sitename)\n작성일: \(formatter.string(from: imageInfo.datetime ?? Date()))"
    }
    
}
