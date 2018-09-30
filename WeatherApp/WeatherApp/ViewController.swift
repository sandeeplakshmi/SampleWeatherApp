//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ashritha S on 9/30/18.
//  Copyright © 2018 sample. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController , CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var temparatureLbl:UILabel!
    @IBOutlet weak var weatherImg:UIImageView!
    @IBOutlet weak var weatherLbl:UILabel!
    @IBOutlet weak var locationLbl:UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var weatherModel: WeatherModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.dateLabel.text = "";
        self.temparatureLbl.text = "0°F"
        self.weatherLbl.text = ""
        self.locationLbl.text = ""
        self.weatherImg.image = nil
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        weatherModel = WeatherModel()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchDetails()
    }


    func fetchDetails() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            self.fetchWeatherDetails {
                
                self.dateLabel.text = self.weatherModel.date;
                self.temparatureLbl.text = String(format:"%.f°F", self.weatherModel.temparature)
                self.weatherLbl.text = self.weatherModel.weatherType
                self.locationLbl.text = self.weatherModel.locationName;
                self.weatherImg.image = UIImage(named: self.weatherModel.weatherType)
                
            }
        }
    }
    
    func fetchWeatherDetails(finish: @escaping () -> ()) {
        let URL = "http://api.openweathermap.org/data/2.5/weather?appid=0911fa7d85012f59535a95dbe8ec5d09&lat=\(self.currentLocation.coordinate.latitude)&lon=\(self.currentLocation.coordinate.longitude)"
        
        Alamofire.request(URL).responseJSON { response in
            let result = response.result
            print("Weather Data ->%@",result.value!)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self.weatherModel._locationName = name.capitalized
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self.weatherModel._weatherType = main.capitalized
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        self.weatherModel._temparature = kelvinToFarenheit
                    }
                }
            }
            finish()
        }
    }

    //Location Manager delegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            fetchDetails()
        }
    }
    
}

