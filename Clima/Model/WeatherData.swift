//
//  WeatherData.swift
//  Clima
//
//  Created by Noam Moyal on 01/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [weather]
    
}

struct Main :Decodable {
    let temp : Double
}

struct weather : Decodable{
    let description : String
    let id : Int
    
}
