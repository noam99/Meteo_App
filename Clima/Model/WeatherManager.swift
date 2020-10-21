//
//  WeatherManager.swift
//  Clima
//
//  Created by Noam Moyal on 29/03/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather : WeatherModel) // 166 we update protocol since in WeatherViewController we wanted to add the weatherManager: WeatherManager
    
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    
    let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(API.API_KEY)&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
   
    
    func fetchWeather(cityName:String)  {
        let urlString = "\(WeatherURL)&q=\(cityName)"
        type(of: urlString)
        performRequest(with: urlString) //166 before it was (urlString: urlString) but we put woth in the performRequest methos so now we just need to pass the input after the with
        print(1)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees ){
         let urlString = "\(WeatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString:String){//166 we added with
        print("a")
        print(urlString)
        //1 create a URL
        if let url = URL(string: urlString){
            print(2)
        print(url)
        //2 create a URL Session
        let session = URLSession(configuration: .default)
            
        //3 give the session a task
            let task = session.dataTask(with: url ) {(data,response,error) in // before it was like this: completionHandler: handle(data: response: error: )
            
            if error != nil {
                    print(error!)
                self.delegate?.didFailWithError(error: error!)
                    return
                }
                
            if let safeData = data{
                //let dataString = String(data: safeData, encoding: .utf8)
                //164_1 self.parseJson(weatherData: safeData)
                if let weather = self.parseJson(safeData) {//166 before it was (weatherData: safeData) but we added _ in the parseJson method so we dont need to use write weatherData: and just put the input
                        
                    // let weatherVC = WeatherViewController()
                    // weatherVC.didUpdateWeather(weather: weather)
                    self.delegate?.didUpdateWeather( self ,weather: weather) //lesson 166 before there was no need to add self but we updated the protocol
                }
            }
        }
        //4 start the task
         task.resume()
            
    }
        
}
    
    
    func parseJson(_ weatherData: Data) -> WeatherModel?{//164_2 before there was not any return we did it to give an output directly in line 164_1 (look at notes and video)
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //print(weather.getConditionName(weatherID: id)) this was ok if there was the part commented in weather Model
            print(weather.conditionName)
            print(weather.temperatureString)
            return weather
            
            
            
        }catch{
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
//before it was like this
/*
    func handle(data:Data?, response:URLResponse?, error: Error? ){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print("c")
            print(dataString!)
        }
    }
}
*/

}
