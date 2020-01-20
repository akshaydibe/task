//
//  DataService.swift
//  proof of concept
//
//  Created by Amit Dhadse on 10/12/19.
//  Copyright © 2019 Akshay Dibe. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct DataService
{
    // MARK: - Singleton
    static var sharedInstance = DataService()
    
    
    
    mutating func callWebservice(completion: @escaping (Response?, Error?) -> ()) {
        

        let headers = [
            "cache-control": "no-cache"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _ , error) -> Void in
            guard let data = data else {return}

            do {

                let decoder = JSONDecoder()
                let dataDictionar = try decoder.decode(Response.self, from: Data(String(data: data, encoding: .ascii)!.utf8))
                print(dataDictionar)
                completion(dataDictionar,nil)

            }catch let err {
                print(err)
            }

            guard let err = error else {return}
            completion(nil,err)
        })

        dataTask.resume()
        

    }
    
    
    mutating func downloadImages(image : String,completion: @escaping (_ downloadedImage : UIImage) -> ()) {
        let newImage = image.replacingOccurrences(of: "http", with: "https")
        
        Alamofire.request(newImage).responseImage { response in
            debugPrint(response)

            print(response.request ?? "")
            print(response.response ?? "")
            debugPrint(response.result)

            if let image = response.result.value {
                print("image downloaded: \(image)")
                completion(image)
            }
            else{
                completion(UIImage(named: "placeholder")!)
            }
        }
        
    }
}
