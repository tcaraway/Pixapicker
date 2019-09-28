//
//  JSONHandler.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 9/26/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation

class PixaBayAPIService {
    
    struct PixaBayResponse : Decodable {
        let totalHits : Int
        let hits : [Hit]
    }
    
    struct Hit : Decodable {
        let webformatURL : URL
    }
    
    public static func loadPixaBayRequest(withURL: String){
        guard let url = URL(string : withURL) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard let data = data else { print(error!); return }
            do {
                let result = try JSONDecoder().decode(PixaBayResponse.self, from: data)
                let hits = result.hits
                for hit in hits {
                    print(hit.webformatURL) //FOR TESTING
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
}
