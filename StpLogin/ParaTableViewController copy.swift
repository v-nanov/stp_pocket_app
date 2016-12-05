//
//  ParaTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-05.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//
//  Show paragraphes under a section

import UIKit

class ParaTableViewController: UITableViewController {
    
    var topicKey: Int? // topicKey will be passed from publication controller.
    var rbKey: Int? // rbKey will be passed to section controller.
    
    var TableData: Array<String> = Array<String>()
    var rbKeyArray: Array<Int> = Array<Int>()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.layoutMargins = UIEdgeInsets.zero
            tableView.separatorInset = UIEdgeInsets.zero
            
            debugPrint("passed topicKey: \(topicKey)");
            guard topicKey != nil else {
                debugPrint("empty topicKey")
                return
            }
            
            callGetTopicsAPI()
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 140;
            
        }
        
        // call web API to get publications list
        func callGetTopicsAPI(){
            
            // create request
            let apiURL: String = Constants.urlEndPoint + "Rulebook?topicKey=\(topicKey!)"
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
                debugPrint(rbName)
                debugPrint(summary)
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
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        rbKey = rbKeyArray[row]
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
            header?.backgroundColor = UIColor.blue
            
            let title = UILabel()
            title.font = UIFont(name: "Futura", size: 18)!
            title.text = "Select one rulebook to continue"
            title.textColor = UIColor.red
            
            header?.textLabel?.font = title.font
            header?.textLabel?.textColor = title.textColor
            header?.textLabel?.text = title.text
            
            return header
        }
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        
        
        /*
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
         
         // Configure the cell...
         
         return cell
         }
         */
        
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
