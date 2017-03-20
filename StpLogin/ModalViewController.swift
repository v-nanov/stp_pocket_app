//
//  ModalViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2017-03-08.
//  Copyright © 2017 Rafy Zhao. All rights reserved.
//

import MarkupKit
import UIKit


class ModalViewController: LMTableViewController {
    
    var acronym: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.dataSource = self
        print("ModalViewControlloer loading: acronym = \(acronym)")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
        // Do any additional setup after loading the view.
    }
    
            
    override func viewWillAppear(_ animated: Bool) {
        tableView.layoutIfNeeded()
        
        view = LMViewBuilder.view(withName: "States", owner: self, root: nil)
        tableView.dataSource = self
        tableView.delegate = self
        preferredContentSize = tableView.contentSize
        print("now acronym is \(acronym)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let n: Int
        print("set the table view....")
        if (tableView.name(forSection: section) == "dynamic") {
            print("dynamic.")
            n = StpVariables.states.count
        } else {
            print("static.")
            n = super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        return n
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (tableView.name(forSection: indexPath.section) == "dynamic") {
            print("display dynamic")
            //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TopicTableViewCell
            cell.textLabel?.text = StpVariables.states[indexPath.row]
            
        } else {
            print("display static.")
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        return cell
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StpVariables.states.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = StpVariables.states[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor(white: 114/225, alpha: 1)
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
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
