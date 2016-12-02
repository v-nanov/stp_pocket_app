//
//  ViewController.swift
//  StpLogin
//
//  Created by Rafy Zhao on 2016-11-01.
//  Copyright © 2016 Rafy Zhao. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var Signin: UIButton!
    @IBOutlet weak var emailText: UITextField!
    
    var userID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "STP Pocket Reference"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginSuccess(userId: Int?, error: String?){
        guard let userId = userId else {
            print("cannot login")
            OperationQueue.main.addOperation {
                if let error = error{
                        self.showAlert(msg: error)
                } else {
                        self.showAlert(msg: "Cannot login, please try later.")
                }
            }
            return
        }
        userID = userId
       

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueDisplayPubList", sender: self)
         
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDisplayPubList" {
            if let destinationVC = segue.destination as? PubListViewController {
                destinationVC.userId = userID
            }
        }
    }
    
    
    func showAlert(msg: String){
        let alertController = UIAlertController(title:"STP in Pocket", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
            print("OK")
            
        }
        alertController.addAction(remindAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // call web API to login
    func callLoginAPI(email: String, password: String){
        
        // prepare json data
        let json = ["email": email, "password": password]
        
        // create post request
        let loginEndpoint: String = "http://10.1.48.110:9001/api/users"
        guard let localIIS = URL(string: loginEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: localIIS)
        request.httpMethod = "POST"
        
        // insert json data to request
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if !JSONSerialization.isValidJSONObject(json){
            print("invalid input")
            print(json)
            return
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            
            guard  error == nil else{
                print("error=\(error)")
                self.loginSuccess(userId: nil, error: error.debugDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {
                print("404")
                self.loginSuccess(userId: nil, error: "Bad username/password.")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("error is \(error), \(response.debugDescription)")
                self.loginSuccess(userId: nil, error: error.debugDescription)
                return
            }
            // parse the result as JSON
            guard let todo = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] else{
                return
            }
            
            for object in todo!{
                if let unwrapped = object["userid"] {
                    print("unwrapped = \(unwrapped)")
                    self.loginSuccess(userId: unwrapped as? Int , error: "")
                }
            }
        }
        task.resume()
    }


    // MARK: Actions
    @IBAction func signinStp(_ sender: UIButton) {
        
        guard let email = emailText.text, !email.isEmpty else{
            let alertController = UIAlertController(title:"STP in Pocket", message: "Please enter your email address", preferredStyle: UIAlertControllerStyle.alert)
            let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
                print("OK")
                
            }
            alertController.addAction(remindAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        guard let pwd = passwordText.text, !pwd.isEmpty else {
            let alertController = UIAlertController(title:"STP in Pocket", message: "Please enter your password", preferredStyle: UIAlertControllerStyle.alert)
            let remindAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(result: UIAlertAction)-> Void in
                print("OK")
                
            }
            alertController.addAction(remindAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        debugPrint("email=" + email + ", pwd=" + pwd)
        callLoginAPI(email: email, password: pwd)
    }
    


}

