//
//  ViewController.swift.
//  Whats the Weather
//
//  Created by Alan Mendez on 1/29/21.
//  
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //test

    // MARK: - Outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherReport: UILabel!
    
    // MARK: - Actions
    @IBAction func submit(_ sender: Any) {
        //convert multi-word phrase into version that weather-forecast.com can accept
        var city = String(cityTextField.text!)
        if city.contains(" ") {
            let cityNoSpace = city.replacingOccurrences(of: " ", with: "%20")
            city = cityNoSpace
        }
        print(city)
        //access code/content from website
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=53717e823d330db719913b12f232bc5a") {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let urlContent = data {
                     do {
                     let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                         print(jsonResult)
                         if let jsonResultArray = jsonResult as? NSDictionary  {
                             print(jsonResultArray["name"]!)
                             print(jsonResultArray["weather"]!)
                             if let weatherArray = (jsonResultArray["weather"] as? NSArray) {
                                 print(weatherArray[0])
                                 if let weatherDict = weatherArray[0] as? NSDictionary {
                                    print(weatherDict["description"]!)
                                    //Update UI
                                    DispatchQueue.main.sync {
                                        self.weatherReport.text = weatherDict["description"] as? String
                                    }
                                 }
                             }
                         }
                     } catch {
                         print("JSON failed.")
                     }
                    }
                }
            }
         task.resume()
     } else {
        //name of city not found on website
        DispatchQueue.main.sync {
            self.weatherReport.text = "City not found. Please confirm city's spelling/existence."
        }
     }
        cityTextField.text = ""
    }
            
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //make keyboard disappear when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //make keyboard disappear when return is pressed - set up delegate for text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    
    

}

