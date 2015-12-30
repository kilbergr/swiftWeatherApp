//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rebecca Kilberg on 12/29/15.
//  Copyright © 2015 Rebecca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityChoice: UITextField!
    
    @IBOutlet weak var searchResults: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func searchWeb(sender: AnyObject) {
        
        var city = NSString(string: cityChoice.text!)
        let saveTheCity = cityChoice.text!
        
        if city.componentsSeparatedByString(" ").count > 1 {
        
            var cityWordsArray = city.componentsSeparatedByString(" ")
            //to address place names with abbreviation "St" in them
            if city.containsString("St") {
               
                cityWordsArray[0] = "Saint"
                
            }
           //to address place names with multiple word names
            city = cityWordsArray.joinWithSeparator("-")
            
        }
     
       let url = NSURL(string: "http://www.weather-forecast.com/locations/" + (city as String) + "/forecasts/latest")!
       
     
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                //splitting to find the part of interest
                
                var splitIt = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:")
                
                //checking to make sure that it exists in the string and we haven't reached some weird place
                if splitIt!.count > 1 {
                    let prefixRemoved = splitIt![1]
                    
                    let arrayOfInterest = prefixRemoved.componentsSeparatedByString("</span>")
                    let finalArray = arrayOfInterest[0].componentsSeparatedByString("phrase\">")
                    
                    if arrayOfInterest.count > 1 {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.searchResults.text = saveTheCity + " 1 – 3 Day Weather Forecast Summary: " + finalArray[1]
                            
                        })
                    }
                    else {
                        self.searchResults.text = "I'm sorry, there's been an error. Try a different city."
                    }
                }
                //error handling
                else {
                        self.searchResults.text = "I'm sorry, there's been an error. Try a different city."
                }
            }
                
            else {
                print(error)
                self.searchResults.text = "I'm sorry, it looks like we're having trouble connecting right now. Try again later."
            }
        }
        task.resume()
     
        cityChoice.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

