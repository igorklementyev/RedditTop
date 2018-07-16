//
//  RedditTopTableViewController.swift
//  RedditTop
//
//  Created by Igor Klementyev on 7/15/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class RedditTopTableViewCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var comments: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postedInfo: UILabel!
}


class RedditTopTableViewController: UITableViewController {

    private var redditTopItems: [RedditTopEntity] = [RedditTopEntity]()
    private var after: String? = nil
    //private var before: String? = nil
    private var loadingStatus = false
    private var imageUrl = ""
    
    func parseJSON () {
        
        if !loadingStatus{
            
            loadingStatus = true
            
            let url = URL(string: "https://www.reddit.com/top.json?limit=10" + (self.after != nil ? "&after=\(self.after!)" : ""))
        
            let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error ) in
                
                defer {
                    self?.loadingStatus = false
                }
                
                guard error == nil else {
                    self?.showError("returned error")
                    return
                }
                
                guard let content = data else {
                    self?.showError("No data")
                    return
                }
                
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                    self?.showError("Not containing JSON")
                    return
                }
                
                guard let data = json["data"] as? [String: Any] else {
                    self?.showError("Not containing data")
                    return
                }
                
                self?.after = nil;
                if let after = data["after"] as? String{
                    self?.after = after
                }
                
//                weakSelf!.before = nil;
//                if let before = data["before"] as? String {
//                    weakSelf!.before = before
//                }
                
                guard let children = data["children"] as? [Any] else {
                    self?.showError("Not containing children")
                    return
                }
                
                children.forEach{ child in
                    
                    guard let childDictionary = child as? [String: Any] else {
                        self?.showError("Incorrect child")
                        return
                    }
                    
                    guard let data = childDictionary["data"] as? [String: Any]  else {
                        self?.showError("No data in child")
                        return
                    }
                    
                    guard let title = data["title"] as? String  else {
                        self?.showError("No title")
                        return
                    }
                    
                    guard let author = data["author"] as? String  else {
                        self?.showError("No author")
                        return
                    }
                    
                    guard let created_utc = data["created_utc"] as? Double else {
                        self?.showError("No created_utc")
                        return
                    }
                    
                    guard let num_comments = data["num_comments"] as? Int else {
                        self?.showError("No num_comments")
                        return
                    }
                    
                    let createdUtcDate = Date(timeIntervalSince1970: created_utc)
                    
                    var thumbnail: String? = nil;
                    
                    if let thumbnail_link = data["thumbnail"] as? String {
                        if thumbnail_link.hasPrefix("http") {
                            thumbnail = thumbnail_link
                        }
                    }
                    
                    var image_url: String? = nil;
                    
                    if let image_link = data["url"] as? String {
                        // chek the destination is image
                        if image_link.hasSuffix("jpg") || image_link.hasSuffix("png") {
                            image_url = image_link
                        }
                    }
                    
                    let entity = RedditTopEntity(title: title, author: author, created: createdUtcDate, commentsNumber: num_comments, thumbnailUrl: thumbnail, imageUrl: image_url);
                    
                    self?.redditTopItems.append(entity)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Reddit top app"
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension;
        self.tableView?.estimatedRowHeight = 210
        
        parseJSON ()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditTopItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedditTopCell", for: indexPath) as! RedditTopTableViewCell

        let redditTopEntity = redditTopItems[indexPath.row];
        
        // Configure the cell...
        cell.title?.text = redditTopEntity.title
        cell.postedInfo?.text = "Posted by " + redditTopEntity.author + " " + redditTopEntity.hoursAgo() + " hours ago"
        cell.comments?.text = "\(redditTopEntity.commentsNumber) Comments"
        
        cell.thumbnail.image = UIImage() // to clear content
        cell.thumbnail.gestureRecognizers?.forEach(cell.thumbnail.removeGestureRecognizer) //clear recognizers for reusable cell
        
        if let thumbnailUrl = redditTopEntity.thumbnailUrl {
            cell.thumbnail.downloadFrom(link: thumbnailUrl)
            cell.thumbnailHeightConstraint.constant = 78;
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
            cell.thumbnail.isUserInteractionEnabled = true
            cell.thumbnail.tag = indexPath.row
            cell.thumbnail.addGestureRecognizer(tapGestureRecognizer)
        }else{
            cell.thumbnailHeightConstraint.constant = 0;
        }
        
        cell.setNeedsLayout()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reddit Top"
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // call your API for more data
            parseJSON()
        }
    }
    
    private func showError(_ error: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 215.0
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @objc
    func viewImage(_ sender: AnyObject) {
        if let tag = sender.view?.tag{
            if let imageUrl = redditTopItems[tag].imageUrl{
                self.imageUrl = imageUrl
                performSegue(withIdentifier: "ShowImage", sender: self)
            }else{
                showError("Destination is not image")
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ImageViewController
        destinationVC?.imageUrl = imageUrl
    }
}
