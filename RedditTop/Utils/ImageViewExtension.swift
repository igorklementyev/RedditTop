//
//  ImageViewExtension.swift
//  RedditTop
//
//  Created by Igor Klementyev on 7/15/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

@IBDesignable
class DownloadableImageView: UIImageView {
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func downloadFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            defer{
                DispatchQueue.main.async(){
                    self?.actInd.stopAnimating()
                }
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async() {
                self?.image = image
            }
        }.resume()
    }
    
    func downloadFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        showActivityIndicator(self)
        
        downloadFrom(url: url, contentMode: mode)
    }
    
    func showActivityIndicator(_ uiView: UIView) {
        
        actInd.frame = uiView.bounds;
        
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    override var bounds: CGRect {
        willSet {
            actInd.frame = newValue
        }
    }
}
