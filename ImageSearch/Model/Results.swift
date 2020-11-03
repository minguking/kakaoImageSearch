//
//  Results.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/02.
//

/*
 {
       "collection": "news",
       "thumbnail_url": "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
       "image_url": "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg",
       "width": 540,
       "height": 457,
       "display_sitename": "한국경제TV",
       "doc_url": "http://v.media.daum.net/v/20170621155930002",
       "datetime": "2017-06-21T15:59:30.000+09:00"
     }
 */

import Foundation

struct Results {
    
    var collection: String
    var thumbnail_url: String
    var image_url: String
    var width: Int
    var height: Int
    var display_sitename: String
    var doc_url: String
    var datetime: Date?
    
    init(dictionary: [String: Any]) {
        self.collection = dictionary["collection"] as? String ?? ""
        self.thumbnail_url = dictionary["thumbnail_url"] as? String ?? ""
        self.image_url = dictionary["image_url"] as? String ?? ""
        self.width = dictionary["width"] as? Int ?? 0
        self.height = dictionary["height"] as? Int ?? 0
        self.display_sitename = dictionary["display_sitename"] as? String ?? ""
        self.doc_url = dictionary["doc_url"] as? String ?? ""
    }
}
