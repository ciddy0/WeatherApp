//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Diego Cid on 9/11/24.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherResponse?) -> Void) {
        let apiKey = "a4b37e257d6dd60c021c0eb33ec1a079"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
        guard let url = URL(string: urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url){
            data, response, error in if let error = error{
                print("Error Fetching weather data \(error)")
                completion(nil)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    completion(weatherResponse)
                } catch{
                    print("error decoding weather data: \(error)")
                    completion(nil)
                }
            }
        }.resume()
        
    }
    struct WeatherResponse: Codable {
        let main: Main
        let weather: [Weather]
    }
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    struct ForecastResponse: Codable {
        let list: [WeatherForecast]
    }

    struct WeatherForecast: Codable {
        let main: Main
        let weather: [Weather]
        let dtTxt: String // The forecast time as a string (e.g., "2024-09-11 15:00:00")
        
        enum CodingKeys: String, CodingKey {
            case main, weather
            case dtTxt = "dt_txt"
        }
    }

    struct DailyWeather {
        let date: String
        let temperature: Int
        let icon: String
    }
}

