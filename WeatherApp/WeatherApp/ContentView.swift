//
//  ContentView.swift
//  WeatherApp
//
//  Created by Diego Cid on 9/9/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var isNight = false
    @State private var temperature: Int = 100
    @State private var weatherIcon: String =  "cloud.sun.fill"
   
    
    var weatherManager = WeatherManager()
    var body: some View {
        ZStack {
            BackgroundView( isNight: isNight)
            VStack{
                CityTextView(cityName: "Los Angeles, CA")
                
                MainWeatherStatusView(imageName: isNight ? "cloud.moon.fill" : "cloud.sun.fill", temperature: temperature)

                HStack(spacing:20){
                    WeatherDayView(dayOfWeek: "TUE", imageName: "tornado", temperature: 88)
                    WeatherDayView(dayOfWeek: "WED", imageName: "wind", temperature: 93)
                    WeatherDayView(dayOfWeek: "THU", imageName: "cloud.sun.bolt.fill", temperature: 99)
                    WeatherDayView(dayOfWeek: "FRI", imageName: "cloud.hail.fill", temperature: 91)
                    WeatherDayView(dayOfWeek: "SAT", imageName: "cloud.bolt.fill", temperature: 90)
                }
                Spacer()
                Button{
                    isNight.toggle()
                } label:{
                    WeatherButton(title: "Change Day Time", textColor: .black, backgroundColor: .white)
                }
                Spacer()
            }
        }
        .onAppear {
            fetchWeather()
        }
    }
    // MARK: - Fetch Weather Data
    func fetchWeather() {
            // Coordinates for Los Angeles
            let latitude = 34.05
            let longitude = -118.24
            
            weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude) { weatherResponse in
                if let response = weatherResponse {
                    DispatchQueue.main.async {
                        temperature = Int(response.main.temp)
                        weatherIcon = getWeatherIcon(icon: response.weather.first?.icon ?? "sun.max.fill")
                    }
                }
            }
        }
    func getWeatherIcon(icon: String) -> String {
            switch icon {
            case "01d": return "sun.max.fill"
            case "01n": return "moon.stars.fill"
            case "02d": return "cloud.sun.fill"
            case "02n": return "cloud.moon.fill"
            case "03d", "03n": return "cloud.fill"
            case "04d", "04n": return "cloud.fill"
            case "09d", "09n": return "cloud.rain.fill"
            case "10d": return "cloud.sun.rain.fill"
            case "10n": return "cloud.moon.rain.fill"
            case "11d", "11n": return "cloud.bolt.fill"
            case "13d", "13n": return "snow"
            case "50d", "50n": return "cloud.fog.fill"
            default: return "sun.max.fill"
            }
        }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:55, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    var isNight: Bool
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightblue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

struct CityTextView: View{
    var cityName: String
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View{
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height: 80)
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }.padding(50)
    }
}
