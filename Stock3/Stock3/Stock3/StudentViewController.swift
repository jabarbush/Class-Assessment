//  StudentViewController.swift
//  Created by Barbush, Jacob on 5/2/20.
//  Copyright © 2020 Barbush, Jacob. All rights reserved.

import UIKit

class StudentViewController: UIViewController {
    
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var unsureButton: UIButton!
    @IBOutlet weak var lostMeButton: UIButton!
    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var classroomTextbox: UITextField!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var gotLabel: UILabel!
    @IBOutlet weak var unsureLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func gotItButton(_ sender: Any) {
        var classroomID: String = classroomTextbox.text!
        var email: String = emailTextbox.text!
        var vote: String = "Got it"
        postRequest1(classroomID: classroomID, email: email, vote: vote)
        queryParse(classroomID: classroomID)
    }
    
    @IBAction func unsureButton(_ sender: Any) {
        var classroomID: String = classroomTextbox.text!
        var email: String = emailTextbox.text!
        var vote: String = "Unsure"
        postRequest1(classroomID: classroomID, email: email, vote: vote)
        queryParse(classroomID: classroomID)
    }
    
    @IBAction func lostMeButton(_ sender: Any) {
        var classroomID: String = classroomTextbox.text!
        var email: String = emailTextbox.text!
        var vote: String = "Lost me"
        postRequest1(classroomID: classroomID, email: email, vote: vote)
        queryParse(classroomID: classroomID)
    }
    
    func queryParse(classroomID:String){
        let jsonUrlString = "https://iuc2eauvwe.execute-api.us-east-1.amazonaws.com/production/pollsession?ClassroomId=" + classroomID
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {let allData = try JSONDecoder().decode(AllData.self, from: data)
                DispatchQueue.main.async{
                    self.sessionLabel.text = (allData.Item.ClassroomId)
                    self.gotLabel.text = String(allData.Item.Got)
                    self.unsureLabel.text = String(allData.Item.Unsure)
                    self.lostLabel.text = String(allData.Item.Lost)
                }
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
        }.resume()
    }
    
    func postRequest1(classroomID: String, email: String, vote: String){
        let parameters: [String:Any] = [
            "ClassroomId": classroomID,
            "Email": email,
            "TheVote": vote
        ]
        
    //create the url with NSURL
    let url = URL(string: "https://qyg64r5u12.execute-api.us-east-1.amazonaws.com/production/pollsession")!
    //now create the Request object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    do {request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        print(request.httpBody as Any)
    } catch let error {print(error.localizedDescription)}
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
     let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print(dataString)}
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
            
        }
    }
    task.resume()
    }
}
