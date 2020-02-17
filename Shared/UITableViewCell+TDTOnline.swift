//
//  UIImageView+TDTOnline.swift
//  TDTOnline iOS
//
//  Created by Ruben Fernandez on 31/10/2019.
//  Copyright © 2019 Ruben Fernandez. All rights reserved.
//

import UIKit

var cellImageCache: [String:UIImage] = [:]

extension UITableViewCell {
    
    func setImage(from urlString: String?) {
        imageView?.image = nil
        imageView?.contentMode = .scaleAspectFit
        guard let urlStr = urlString, let url = URL(string: urlStr) else { return }
        if let image = cellImageCache[urlStr] {
            imageView?.image = image
            setNeedsLayout()
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                cellImageCache[urlStr] = image
                DispatchQueue.main.async {
                    self.imageView?.image = image
                    self.setNeedsLayout()
                }
            }.resume()
        }
    }
    
}
