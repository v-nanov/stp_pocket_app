//
//  RulebookTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-01.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit

class RulebookTableViewController: UITableViewController {
    
    var topicKey: Int? // topicKey will be passed from topic controller.
    var topic: String? // topic will be passed from topic controller.
    var rbKey: Int? // rbKey will be passed to section controller.
    var offline: Bool = false // passed from topic controller
    var TableData: Array<String> = Array<String>()
    var rbKeyArray: Array<Int> = Array<Int>()
    var rbName: String?
        
    override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.layoutMargins = UIEdgeInsets.zero
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 140;
            
            navigationItem.title = "RULE BOOK"
            self.navigationController?.navigationBar.topItem!.title = "Back"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
            
            guard topicKey != nil else {
                debugPrint("empty topicKey")
                return
            }
            
            if offline == false {
                callGetTopicsAPI()
            } else {
                browseLocal()
            }
            
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Rule Book"
    }
    
    
    func signOut() {
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    
    // browse publications in local database
    func browseLocal() {
        debugPrint("browse local rulebooks..")
        let items = StpDB.instance.getRulebooks(key: topicKey!)
        
        for item in items {
            let rbKey = item.rbKey
            let rbName = item.rbName
            
            TableData.append(rbName)
            rbKeyArray.append(rbKey)

        }
        
    }
        
        // call web API to get publications list
        func callGetTopicsAPI(){
            
            // create request
            let apiURL: String = Constants.URL_END_POINT + "Rulebook?topicKey=\(topicKey!)"
            guard let api = URL(string: apiURL) else {
                print("Error: cannot create URL")
                return
            }
            var request = URLRequest(url: api)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                    print("404")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("error is \(error), \(response.debugDescription)")
                    //self.loginSuccess(userId: nil, error: error.debugDescription)
                    return
                }
                // parse the result as JSON
                self.extract_topics(jsonData: data!)
            }
            task.resume()
        }
        
        func extract_topics(jsonData: Data){
            
            guard let rb = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
                return
            }
            
            for item in rb! {
                let rbName = item["rbName"] as? String
                let summary = item["summary"] as? String
                let rbKey = item["rbKey"] as? Int
                
                TableData.append(rbName!)
                rbKeyArray.append(rbKey!)
            }
            do_table_refresh()
        }
        
        func do_table_refresh()  {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                return
            }
        }
        
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSection" {
            if let destination = segue.destination as? SectionTableViewController {
                destination.rbKey = rbKey
                destination.offline = offline
                destination.rbName = rbName
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        rbKey = rbKeyArray[row]
        rbName = TableData[row]
        print("the row is tabbed:\(rbKey)")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueSection", sender: self)
        }
    }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return TableData.count
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! RulebookCell
            cell.titleLabel.text = TableData[indexPath.row]
            cell.titleLabel.textColor = UIColor(white: 114/225, alpha: 1)
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableCell(withIdentifier: "header")
            
            let title = UILabel()
            title.font = UIFont(name: "Myriad Pro", size: 18)!
            title.text = topic
            title.textColor = UIColor.white
            
            header?.textLabel?.font = title.font
            header?.textLabel?.textColor = title.textColor
            header?.textLabel?.text = title.text
            
            return header
        }
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        
}
