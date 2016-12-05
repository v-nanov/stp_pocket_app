//
//  SectionTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-05.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//
//  List all the sections under a rulebook

import UIKit

class SectionTableViewController: UITableViewController {
    var rbKey: Int? // passed from Rulebook controller
    var sectionKey: Int? // passed to Paralist controller
    var TableData: Array<String> = Array<String>()
    var sectionKeyArray: Array<Int> = Array<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero

        debugPrint("passed acroynm: \(rbKey)");
        guard rbKey != nil else {
            debugPrint("empty rbKey")
            return
        }
        
        callGetTopicsAPI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;

    }
    
    // call web API to get publications list
    func callGetTopicsAPI(){
        
        // create request
        let apiURL: String = Constants.urlEndPoint + "Section?rbKey=\(rbKey!)"
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
            self.extract_json(jsonData: data!)
        }
        task.resume()
    }
    
    func extract_json(jsonData: Data){
        
        guard let sections = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
            return
        }
        
        for item in sections! {
            let sectionKey = item["sectionKey"] as? Int
            let sectName = item["sectName"] as? String
            debugPrint(sectionKey)
            debugPrint(sectName)
            TableData.append(sectName!)
            sectionKeyArray.append(sectionKey!)
        }
        do_table_refresh()
    }
    
    func do_table_refresh()  {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
   /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueParalist" {
            if let destination = segue.destination as? RulebookTableViewController {
                destination.sectionKey = sectionKey
            }
        }
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        sectionKey = sectionKeyArray[row]
        print("the row is tabbed:\(sectionKey)")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueParalist", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SectionCell
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
        title.text = "Select one of the sections below"
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
