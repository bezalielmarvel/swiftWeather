//
//  CityViewController.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 14/05/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit
import Weather

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var headerLine1: UILabel!
    
    @IBOutlet weak var headerLine2: UILabel!
    
    @IBOutlet weak var headerLine3: UILabel!
    
    @IBOutlet weak var headerLine4: UILabel!
    
    @IBOutlet weak var descriptionLine1: UILabel!
    
    @IBOutlet weak var descriptionLine2: UILabel!
    
    @IBOutlet weak var descriptionLine3: UILabel!
    
    var wc: WeatherClient = WeatherClient(key: "057235dd5c2aec8dee5db666fe163476")
    
    var selectedCity: City!
    
    
    // Animation
    var animations:[UIViewPropertyAnimator] = []
    var currentAnimationProgress:CGFloat = 0
    var animationProgressWhenIntrupped:CGFloat = 0
    
    
    // visual effects
    
    var visualEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedCity == nil {
            selectedCity = wc.citiesSuggestions(for: "Paris")[1]
        }
        
        cityNameLabel.text = "\(selectedCity.name), \(selectedCity.country)"
        
        wc.weather(for: selectedCity) { (forecast) in
            print(forecast)
            DispatchQueue.main.async {
//                if(forecast?.weather.titl)
//                self.date.text = forecast?.date.description
//                self.temp.text = forecast?.temperature.description
//                self.pression.text = forecast?.pressure.description
                //self.weath.text =
                
                let temperatureMax = Int((forecast?.temperatureMax)!)
                let temperatureMin = Int((forecast?.temperatureMin)!)
                let temperatureAvg = Int((forecast?.temperature)!)
                
                let str = forecast?.weather.description
                //print(str)
                let string = str!.replacingOccurrences(of: "[(title: \"", with: "")
                if let range = string.range(of: "description") {
                    let firstPart = string[string.startIndex..<range.lowerBound]
                    let weatherName = firstPart.replacingOccurrences(of: "\",", with: "")
                    
                    self.modifyBasedOnWeather(weatherName: weatherName, tempMax: temperatureMax, tempMin: temperatureMin, temp: temperatureAvg)
                }
            }
            
        }

    }
    
    func modifyBasedOnWeather(weatherName: String, tempMax: Int, tempMin: Int, temp: Int) {
        
        let clouds = "Clouds"
        let clear = "Clear"
        let rain = "Rain"
        let snow = "Snow"
        let drizzle = "Drizzle"
        let thunderstorm = "Thunderstorm"
        
        let whiteGradient = UIImageView(frame: UIScreen.main.bounds)
        whiteGradient.image = UIImage(named: "white-gradient")
        whiteGradient.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(whiteGradient, at: 1)
        
        if tempMin < 5 {
            self.descriptionLine1.text = "Take your winter coat."
            self.descriptionLine2.text = "Expected lowest : \(tempMin)°C."
            self.descriptionLine3.text = "Today's average : \(temp)°C."
        }
        else if tempMin < 15 {
            self.descriptionLine1.text = "Wear something warm."
            self.descriptionLine2.text = "Expected lowest : \(tempMin)°C."
            self.descriptionLine3.text = "Today's average : \(temp)°C."
        }
        else if tempMax > 25 {
            self.descriptionLine1.text = "Put some shorts on."
            self.descriptionLine2.text = "Expected highest : \(tempMax)°C."
            self.descriptionLine3.text = "Today's average : \(temp)°C."
        }
        else if tempMax > 20 {
            self.descriptionLine1.text = "Wear your favorite t-shirt."
            self.descriptionLine2.text = "Expected highest h : \(tempMax)°C."
            self.descriptionLine3.text = "Average temperature : \(temp)°C."
        }
        else {
            self.descriptionLine1.text = "Today's neither cold nor hot."
            self.descriptionLine2.text = "Expected average"
            self.descriptionLine3.text = "Temperature : \(temp)°C."
        }
        
        if weatherName.contains(clouds) {
            self.headerLine1.text = "Today"
            self.headerLine2.text = "Is a"
            self.headerLine3.text = "Cloudy"
            self.headerLine4.text = "Day"

            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "clouds-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }
        else if weatherName.contains(clear) {
            self.headerLine1.text = "Enjoy"
            self.headerLine2.text = "The"
            self.headerLine3.text = "Clear"
            self.headerLine4.text = "Skies"
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "clear-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
            
        }
        else if weatherName.contains(snow) {
            self.headerLine1.text = "Wear"
            self.headerLine2.text = "Your"
            self.headerLine3.text = "Jacket &"
            self.headerLine4.text = "Gloves"
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "snow-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
            
        }
        else if weatherName.contains(rain) {
            self.headerLine1.text = "Don't"
            self.headerLine2.text = "Forget"
            self.headerLine3.text = "Your"
            self.headerLine4.text = "Umbrella"
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "rain-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }
        else if weatherName.contains(drizzle) {
            self.headerLine1.text = "Put"
            self.headerLine2.text = "Your"
            self.headerLine3.text = "Hoodie"
            self.headerLine4.text = "On"
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "rain-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }
        else if weatherName.contains(thunderstorm) {
            self.headerLine1.text = "You"
            self.headerLine2.text = "Should"
            self.headerLine3.text = "Stay at"
            self.headerLine4.text = "Home"
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "thunderstorm-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }
        else {
            self.headerLine1.text = "You"
            self.headerLine2.text = "Should"
            self.headerLine3.text = "Bring a"
            self.headerLine4.text = "Flashlight"

            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "else-bg")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
            self.view.insertSubview(backgroundImage, at: 0)
        }

    }
    
    
    
    
    
    
}
