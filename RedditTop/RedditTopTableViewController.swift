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
    
    @IBOutlet weak var thumbnail: UIImageView!
}


class RedditTopTableViewController: UITableViewController {

    var redditTopItems: [String] = [String]()
    
    func parseJSON () {
        
        let url = URL(string: "https://www.reddit.com/top.json?limit=10")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            guard let data = json["data"] as? [String: Any] else {
                print("Not containing data")
                return
            }
            
            guard let children = data["children"] as? [Any] else {
                print("Not containing children")
                return
            }
            
            children.forEach {child in
                
                guard let childDictionary = child as? [String: Any] else {
                    print("Incorrect child")
                    return
                }
                
                guard let data = childDictionary["data"] as? [String: Any]  else {
                    print("No data in child")
                    return
                }
                
                guard let title = data["title"] as? String  else {
                    print("No data in child")
                    return
                }
                
                self.redditTopItems.append(title)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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

        // Configure the cell...
        cell.title?.text = redditTopItems[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reddit Top"
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}