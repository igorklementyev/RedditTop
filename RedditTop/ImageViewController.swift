//
//  ImageViewController.swift
//  RedditTop
//
//  Created by Igor Klementyev on 7/15/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import WebKit

class ImageViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webkitView: WKWebView!
    
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Long press to save image"

        // Do any additional setup after loading the view.
        if (imageUrl.count > 0){
            webkitView.load(URLRequest(url: URL(string: imageUrl)!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Encoding/Decoding
    override func encodeRestorableState(with coder: NSCoder) {

        coder.encode(imageUrl, forKey: "imageUrlId")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        let object = coder.decodeObject(forKey: "imageUrlId")
        
        if object is String {
            imageUrl = object as! String
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
       webkitView.load(URLRequest(url: URL(string: imageUrl)!))
    }
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/

}
