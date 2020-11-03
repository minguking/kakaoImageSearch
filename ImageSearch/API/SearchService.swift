//
//  SearchService.swift
//  ImageSearch
//
//  Created by Kang Mingu on 2020/11/02.
//

import UIKit

import Alamofire
import SwiftyJSON

struct SearchService {
    
    static let shared = SearchService()
    
    func imageSearch(keyWord: String, page: Int, completion: @escaping([Results]) -> Void) {
        
        let safeKeyWord = keyWord.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        AF.request("https://dapi.kakao.com/v2/search/image?query=\(safeKeyWord)&size=30&page=\(page)",
                   method: .get,
                   encoding: JSONEncoding.prettyPrinted,
                   headers: ["Authorization": "KakaoAK \(myKey)"]).responseJSON { response in
            switch response.result {
            case .success(let json):
                
                print("DEBUG: data fetched successfully")
                
                let value = JSON(json)
                var imageInfo = [Results]()
                
                var results = Results(dictionary: value["documents"].dictionaryValue)
                for item in value["documents"].arrayValue {
                    results.collection = item["collection"].stringValue
                    results.display_sitename = item["display_sitename"].stringValue
                    results.thumbnail_url = item["thumbnail_url"].stringValue
                    results.image_url = item["image_url"].stringValue
                    imageInfo.append(results)
                }
                
                completion(imageInfo)
                
            case .failure(let err):
                print("DEBUG: failed with error => \(err.localizedDescription)")
            }
        }
    }
    
}
