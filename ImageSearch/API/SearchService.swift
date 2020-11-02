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
    
    func imageSearch(keyWord: String, page: Int, completion: @escaping(JSON) -> ()) {
        
        let safeKeyWord = keyWord.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        AF.request("https://dapi.kakao.com/v2/search/image?query=\(safeKeyWord)&size=30&page=\(page)", method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK \(myKey)"]).responseJSON { response in
            switch response.result {
            case .success(let json):
                
                print("DEBUG: json successfully fetched")
                let value = JSON(json)
                completion(value)
                
            case .failure(let err):
                print("DEBUG: failed with err. \(err.localizedDescription)")
    
            }
        }
    }
    
    func searchKeyword(keyword: String, index: Int, completion: @escaping (UIImage) -> Void) {
        let escapedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let strUrl = "https://dapi.kakao.com/v2/search/image?query=\(escapedString)&size=2"
        AF.request(strUrl, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK \(myKey)"]).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                let searchResult: JSON = JSON(response.result)
                let imageResult = searchResult["documents"]["image_url"].stringValue
                let encodedResult = imageResult.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                AF.request(encodedResult).responseData(completionHandler: { (response) in
                    
                    switch response.result {
                    case .success(_):
                        let image = UIImage(data: response.data!)
                        completion(image ?? UIImage())
                    case .failure(let err):
                        print("DEBUG: failed with error: \(err.localizedDescription)")
                    }
                    
                })
                case .failure(let err):
                    print("DEBUG: failed with error: \(err.localizedDescription)")
            }
        }
    }
}
