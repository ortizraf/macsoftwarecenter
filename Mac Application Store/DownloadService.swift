//
//  StringUtils.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//
import Cocoa

class DownloadService {
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    let url: NSURL
    
    init(url: NSURL)
    {
        self.url = url
    }
    
    func downloadData(completion: @escaping ((NSData) -> Void))
    {
        let request = NSURLRequest(url: self.url as URL)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 200:
                        if let data = data {
                            
                            print(data.count)

                            print("complete download")
                            
                            completion(data as NSData)
                            
                        }
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            } else {
                print("Error download data: \(error?.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
}
