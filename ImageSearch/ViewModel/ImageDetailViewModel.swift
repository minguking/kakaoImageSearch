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
    
    var siteName: String {
        return "출처: \(imageInfo.display_sitename)"
    }
    
    var dateTime: String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy년 MM월 dd일 hh시 mm분"
        return "작성 시간:\(formatter.string(from: imageInfo.datetime ?? Date()))"
    }
    
}
