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
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)!
                
                let splitIt = webContent.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")[1]
                
                let stringOfInterest = splitIt.componentsSeparatedByString("</span></span></span></p><div class=\"forecast-cont\"><div class=\"units-cont\"><a class=\"units metric active\">")[0]
                
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        self.searchResults.text = saveTheCity + " 1 – 3 Day Weather Forecast Summary: " + stringOfInterest
                       
                    })
            }
                
            else {
                print(error)
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

