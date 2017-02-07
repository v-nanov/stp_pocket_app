//
//  ParaTableViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-12-05.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//
//  Display paragraphes under a section

import UIKit

class ParaTableViewController: UITableViewController {
    
    var sectionKey: Int? // sectionKey will be passed from section controller.
    var offline: Bool = false // offline will be passed from section controller.
    var paraKey: Int?
    
    var paraNumArray: Array<String> = Array<String>()
    var paraKeyArray: Array<Int> = Array<Int>()
    var questionArray: Array<String> = Array<String>()
    var guideNoteArray: Array<String> = Array<String>()
    var citationArray: Array<String> = Array<String>()
    
    var rowTapped: Int?
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140;
            
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25;

        navigationItem.title = "PARAGRAPH"
        self.navigationController?.navigationBar.topItem!.title = "Back"
        
        
        guard sectionKey != nil else {
            debugPrint("empty sectionKey")
            return
        }
            
        if offline == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
            callWebAPI()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(signOut))
            browseLocal()
        }
    }
    
    
    func signOut() {
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    
    // browse publications in local database
    func browseLocal() {
        let items = StpDB.instance.getParagraphs(key: sectionKey!)
        
        for item in items {
            let question = item.question
            let guideNote = item.guideNote
            let paraKey = item.paraKey
            let paraNum = item.paraNum
            let citation = item.citation
            
            paraNumArray.append(paraNum!)
            paraKeyArray.append(paraKey)
            
            questionArray.append(question!)
            guideNoteArray.append(guideNote!)
            
            if let ci = citation {
                citationArray.append(ci)
            } else {
                citationArray.append("")
            }
        }
    }
    
    
    // call web API to get publications list
    func callWebAPI(){
            
            // create request
            let apiURL: String = Constants.URL_END_POINT + "Para?sectionKey=\(sectionKey!)"
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
            
            guard let rb = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] else{
                return
            }
            
            for item in rb! {
                let question = item["question"] as? String
                let guideNote = item["guideNote"] as? String
                let paraKey = item["paraKey"] as? Int
                let paraNum = item["paraNum"] as? String
                let citation = item["citation"] as? String
                
                paraNumArray.append(paraNum!)
                paraKeyArray.append(paraKey!)
                
                questionArray.append(question!)
                guideNoteArray.append(guideNote!)
                
                if let ci = citation {
                    citationArray.append(ci)
                }else{
                    citationArray.append("")
                }
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
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        rowTapped = indexPath.row
        debugPrint("tapped: \(rowTapped!)")
        do_table_refresh()
    }
    
    
        // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
        print("table will display \(paraNumArray.count) rows")
        return paraNumArray.count + 1
            
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! ParaTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        print("display row \(indexPath.row)")
        if indexPath.row == 0 {
            cell.titleLabel.textColor = UIColor.black
            cell.titleLabel.font = UIFont(name: "Futura", size: 18)
            
            if let row = rowTapped { // The first row will show the contents of the tapped row
                print("tapped header")
                if row != 0 {
                    cell.titleLabel.text = paraNumArray[row - 1] + " " + questionArray[row - 1]
                    cell.titleLabel.text = cell.titleLabel.text! + "\n\n" + guideNoteArray[row - 1]
                }
            } else { // display the first row when no row is tapped.
                print("no tap, normal header.")
                print("question: \(questionArray.count)")
                print("guideNote: \(guideNoteArray.count)")
                print("paraNum: \(paraNumArray.count)")
                if (paraNumArray.count > 0) {
                    cell.titleLabel.text = paraNumArray[0] + " " + questionArray[0] + "\n\n" + guideNoteArray[0]
                    print("first row displayed. ")
                } else {
                    cell.titleLabel.text = "No data."
                }
            }
        } else {
            print("come to display the row.")
            cell.titleLabel.textColor = UIColor(white: 114/225, alpha: 1)
            cell.titleLabel.text = paraNumArray[indexPath.row - 1] + "：" + citationArray[indexPath.row - 1]
        }
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
        let header = tableView.dequeueReusableCell(withIdentifier: "header")
        
        let title = UILabel()
        title.font = UIFont(name: "Myriad Pro", size: 18)!
        title.text = "Choose a paragraph to show detail"
        title.textColor = UIColor.white
        
        header?.textLabel?.font = title.font
        header?.textLabel?.textColor = title.textColor
        header?.textLabel?.text = title.text
        header?.backgroundColor = UIColor.black
        
        return header
    }
}
