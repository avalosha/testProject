//
//  VideosViewModel.swift
//  testProject
//
//  Created by Sferea-Lider on 19/08/22.
//

import Foundation
import Alamofire

func getVideoTitle(id: String) {
    let api = "https://www.googleapis.com/youtube/v3/videos?id=\(id)&key=AIzaSyBkH-qoGYyuHEwdSBsu0WxY8Ofj6tTuAjU&part=snippet"
    let request = AF.request(api)
    request.response { response in
        print("Response: ",response)
    }
    
//    AF.request(api).validate().response { response in
//        switch response.result {
//        case .success:
//            let responseJson = response.result.value! as! NSDictionary
//            print(responseJson)
//
//            if let results = responseJson.object(forKey: "items")! as? [NSDictionary] {
//                print(results)
//                if results.count > 0 {
//                    print(results)
//                    if let snippet = results[0]["snippet"] as? NSDictionary{
//                        print(snippet)
//                        DispatchQueue.main.async {
//                            //self.nameLabel.text = snippet["title"] as? String ?? "" // assign the title to the label
//                        }
//                    }
//                }
//            }
//        case .failure(let error):
//            print("Error: ", error)
//        }
//    }
}
