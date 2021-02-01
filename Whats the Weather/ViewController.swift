//
//  ViewController.swift.
//  Whats the Weather
//
//  Created by Alan Mendez on 1/29/21.
//  
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    
    
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherReport: UILabel!
    
    
    @IBAction func submit(_ sender: Any) {
        
        var dataStringArrayWolf: String = ""
        
        
        //convert multi-word phrase into version that weather-forecast.com can accept
        var city = String(cityTextField.text!)
        
        
        if city.contains(" ") {
            let cityHyphen = city.replacingOccurrences(of: " ", with: "-")
            city = cityHyphen
        }
        print(city)
        
        
        //access code/content from website
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + city + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                if error != nil {
                    print(error!)
                } else {
                    if let unwrappedData = data {
                        if let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) {
    
                        
                        //isolate part of code that references the weather. Use substring from or substring with
                        //separate text into chunks divided by 3 days)</div><p class="b-forecast__table-description-content"><span class="phrase">
                        //and the first instance of </span></p></td><td class="b-forecast__table-description-cell--js" colspan="9"><div class="b-forecast__table-description-title"><h2> + cityTextField.text.
                        //relevant text is what's in between.
                        
                            if dataString.contains("3 days)</div><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">") {
                                
                                let dataStringArray = dataString.components(separatedBy: "3 days)</div><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">")
                                
                                let dataStringArrayStraw = dataStringArray[1]
                                
                                let dataStringArrayWood = dataStringArrayStraw.components(separatedBy: "</span></p></td><td class=\"b-forecast__table-description-cell--js\" colspan=\"9\"><div class=\"b-forecast__table-description-title\"><h2>")
                                
                                let dataStringArrayBrick = dataStringArrayWood[0]
                                
                                dataStringArrayWolf = dataStringArrayBrick.replacingOccurrences(of: "&deg;", with: "°")
            
                                print(dataStringArrayWolf)
                                
                                //Update UI
                                DispatchQueue.main.sync {
                                    self.weatherReport.text = dataStringArrayWolf
                                }
                            } else {
                                //name of city not found on website
                                DispatchQueue.main.sync {
                                    self.weatherReport.text = "City not found. Please confirm city's spelling/existence."
                                }
                            }
                        }
                        
                    
                    }
                }
            }
            task.resume()
            
            //self.weatherReport.text = dataStringArrayWolf
            

        }
        
        //reset cityTextField to ""
            cityTextField.text = ""
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

