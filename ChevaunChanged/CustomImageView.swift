//
//  CustomImageView.swift
//  ChevaunChanged
//
//  Created by Nishant Punia on 16/07/17.
//  Copyright © 2017 MLBNP. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUsedUrlForDownloadingImage: String?
    
    func settingUpImage(urlString: String) {
        
        lastUsedUrlForDownloadingImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Unable to download the image:", error)
                return
            }
            
            if url.absoluteString != self.lastUsedUrlForDownloadingImage {
                return
            }
            
            guard let imageData = data else { return }
            let finalImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = finalImage
            
            DispatchQueue.main.async {
                self.image = finalImage
            }
        }.resume()
    }
    
}
