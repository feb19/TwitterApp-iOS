//
//  TimelineViewController.swift
//  TwitterApp
//
//  Created by TakahashiNobuhiro on 2018/06/18.
//  Copyright © 2018 feb19. All rights reserved.
//

import Foundation
import UIKit

struct Tweet: Decodable {
    let id: Int64
    let text: String
    let created_at: String
}

class TimerlineViewController: UITableViewController {
    
    var timelineData:[Tweet] = []

    override func viewDidLoad() {
        getTimeline()
    }
    
    @IBAction func logoutButtonWasTapped(_ sender: Any) {
        logout()
    }
    @IBAction func tweetButtonWasTapped(_ sender: Any) {
        tweet()
    }
    
    // MARK: -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timelineData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.timelineData[indexPath.row].text
        cell?.detailTextLabel?.text = self.timelineData[indexPath.row].created_at
        return cell!
    }
    
    // MARK: -
    
    
    func getTimeline() {
        var clientError: NSError?
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            let apiClient = TWTRAPIClient(userID: session.userID)
            let request = apiClient.urlRequest(
                withMethod: "GET",
                url: "https://api.twitter.com/1.1/statuses/user_timeline.json",
                parameters: [
                    "user_id": session.userID,
                    "count": "10",
                    ],
                error: &clientError
            )
            
            apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let json = String(data: data, encoding: .utf8) {
                    print(json)
                    let decoder = JSONDecoder()
                    do {
                        self.timelineData = try decoder.decode([Tweet].self, from: data)
                    } catch let error {
                        print(error as NSError)
                    }
                    print(self.timelineData)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func logout() {
        if let session = Twitter.sharedInstance().sessionStore.session() {
            Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
            self.dismiss(animated: true) {
                //
            }
        }
    }
    
    func tweet() {
        var clientError: NSError?
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            let apiClient = TWTRAPIClient(userID: session.userID)
            let request = apiClient.urlRequest(
                withMethod: "POST",
                url: "https://api.twitter.com/1.1/statuses/update.json",
                parameters: [
                    "status": "test tweet",
                    ],
                error: &clientError
            )
            
            apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
                if let error = error {
                    print(error.localizedDescription)
                }
                
                // finished
            }
        }
    }
}
