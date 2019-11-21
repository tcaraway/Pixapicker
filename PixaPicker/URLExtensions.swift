//
//  URLExtensions.swift
//  PixaPicker
//
//  Created by Thomas Caraway on 9/24/19.
//  Copyright © 2019 Thomas Caraway. All rights reserved.
//

import Foundation

class URLExtensions {
    
    static func pixabaySearchURL(with text: String, with PageNumber: Int) -> String{
        
        let apiKey = "13683470-874d69ddffa828cbb82551e32" //API key for my Pixabay account
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: String(PageNumber))
        ]
        guard let finalURL = urlComponents.url?.absoluteString else { return ""}
        return finalURL
        
    }
    
}
