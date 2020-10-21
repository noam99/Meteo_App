//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController  { // before i had after : both WeatherManagerDelegate and UITextFieldDelegate

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var WeatherManager1 = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        WeatherManager1.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

   
    
}

//MARK:- CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            WeatherManager1.fetchWeather(latitude:lat, longitude: lon )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK:- UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{
    
    @IBAction func SearchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
       searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)// to dismiss keyboard
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        
        else{
            textField.placeholder = "type something"
            return false
        }
        
        // this function is used to return nothing until it didnt write something valid
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            WeatherManager1.fetchWeather(cityName: city)
        }
        
        searchTextField.text = "" // to reset the placeholder with zero words and not keep the city searched
    }
    
}

//MARK:- WeatherManagerDelegate
// above is the snippet that i created

extension WeatherViewController: WeatherManagerDelegate{
     func didUpdateWeather(_ weatherManager:WeatherManager , weather : WeatherModel){ //166 we added the weatherManager in the inputs
            print(weather.temperature)
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
                
            }
            
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
}
