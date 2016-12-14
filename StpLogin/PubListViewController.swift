//
//  PubListViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-02.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit

class PubListViewController: UITableViewController {
    
    var userId: Int? // userId will be passed from login controller.
    var TableData: Array<String> = Array<String>()
    var acroynm: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //cellView.delegate = self
        //cellView.dataSource = self

        debugPrint("passed userId: \(userId)");
        guard userId != nil else {
            debugPrint("empty userID")
            return
        }
        
        callGetPubsAPI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;
    }
    
    // call web API to get publications list
    func callGetPubsAPI(){
        
        // create request
        let apiURL: String = Constants.urlEndPoint + "Publications?userId=\(userId!)"
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
                //self.loginSuccess(userId: nil, error: "Bad username/password.")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("error is \(error), \(response.debugDescription)")
                //self.loginSuccess(userId: nil, error: error.debugDescription)
                return
            }
            // parse the result as JSON
            self.extract_publications(jsonData: data!)
        }
        task.resume()
    }
    
    func extract_publications(jsonData: Data){
        
        guard let pubs = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
            return
        }
        
        for item in pubs! {
            let acronym = item["acronym"] as? String
            let title = item["title"] as? String
            debugPrint(acronym)
            debugPrint(title)
            TableData.append(acronym! + ": " + title!)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        debugPrint("passed userId: \(self.userId)");

        return TableData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PublicationTableViewCell
        cell.titleLabel.text = TableData[indexPath.row]
        cell.titleLabel.textColor = UIColor(white: 114/225, alpha: 1)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        header?.backgroundColor = UIColor.blue
        
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 18)!
        title.text = "Select a publication blew:"
        title.textColor = UIColor.red
        
        header?.textLabel?.font = title.font
        header?.textLabel?.textColor = title.textColor
        header?.textLabel?.text = title.text
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTopic" {
            if let destination = segue.destination as? TopicTableViewController {
                destination.acroynm = acroynm
            }
        }
    }
    
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        let cellValue = TableData[row]
        let range1 = cellValue.range(of: ":") // get acroynm from the cell data like 'CALO: OSHA Auditing: California Occupational'
        let endInt = range1?.lowerBound
        
        acroynm = cellValue.substring(to: endInt!)
        print("the row is tabbed:" + acroynm!)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueTopic", sender: self)
        }
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
