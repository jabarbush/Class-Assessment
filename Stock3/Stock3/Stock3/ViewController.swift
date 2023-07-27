//  ViewController.swift
//  Created by Barbush, Jacob on 4/22/20.
//  Copyright © 2020 Barbush, Jacob. All rights reserved.


import UIKit

struct AllData: Decodable {
    let Item: ClassroomData
}

struct ClassroomData: Decodable {
    let ClassroomId: String
    let Got: Int
    let Unsure: Int
    let Lost: Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var teacherButton: UIButton!
    @IBOutlet weak var sessionTextbox: UITextField!
    @IBOutlet weak var postTest: UIButton!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var gotLabel: UILabel!
    @IBOutlet weak var unsureLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func postTest(_ sender: Any) {
        var sessionID:String
        sessionID = sessionTextbox.text!
        postRequest(sessionID: sessionID)
    }
    
    @IBAction func teacherButton(_ sender: Any) {
        var sessionID:String?
        sessionID = sessionTextbox.text!
        queryParse(sessionID: sessionID!)
    }
    
    func queryParse(sessionID:String){
        let jsonUrlString = "https://iuc2eauvwe.execute-api.us-east-1.amazonaws.com/production/pollsession?ClassroomId="+sessionID
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
                dump(allData)
            }catch let jsonErr{
                print("Error serializing json:", jsonErr)}
        }.resume()
    }
    
    //Reference: https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
    func postRequest(sessionID:String){
        let parameters : [String:Any] = ["ClassroomId": sessionID]
        let url = URL(string: "https://zhhmg4c2q1.execute-api.us-east-1.amazonaws.com/production/pollsession")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)}
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                return}
            guard let data = data else {
                return}
            do {guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    return}
                print(json)
            } catch let error {
                print(error.localizedDescription)}
        })
        task.resume()
    }
}
