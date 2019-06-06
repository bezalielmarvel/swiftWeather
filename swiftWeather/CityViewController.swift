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
    
    @IBOutlet weak var dayDate: UILabel!
    
    @IBOutlet var detailsView: UITableView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var orientationLabel: UILabel!
    
    @IBOutlet weak var Weekdate: UILabel!
    
    @IBOutlet weak var Date2: UILabel!
    
    @IBOutlet weak var Date3: UILabel!
    
    @IBOutlet weak var Date4: UILabel!
    
    @IBOutlet weak var Date5: UILabel!
    
    @IBOutlet weak var Description1: UILabel!
    
    @IBOutlet weak var Description2: UILabel!
    
    @IBOutlet weak var Description3: UILabel!
    
    @IBOutlet weak var Description4: UILabel!
    
    @IBOutlet weak var Description5: UILabel!
    
    @IBOutlet var forecastView: UITableView!
    
    @IBOutlet weak var cat1: UILabel!
    
    @IBOutlet weak var cat2: UILabel!
    
    @IBOutlet weak var cat3: UILabel!
    
    @IBOutlet weak var cat4: UILabel!
    
    @IBOutlet weak var cat5: UILabel!
    
    var effect:UIVisualEffect!
    
    var wc: WeatherClient = WeatherClient(key: "057235dd5c2aec8dee5db666fe163476")
    
    var selectedCity: City!
    
    // data source
    var dataArray: [String] = []
    
    // delegate
    var tableViewDelegate: TableViewDelegate?
    
    
    // Animation
    var animations:[UIViewPropertyAnimator] = []
    var currentAnimationProgress:CGFloat = 0
    var animationProgressWhenIntrupped:CGFloat = 0
    
    
    // visual effects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creating the delegate object and passing the data
        tableViewDelegate = TableViewDelegate(data: dataArray)
        
        // passing a function to the delegate object
        //tableViewDelegate?.didSelectRow = didSelectRow
        
        // setting the delegate object to tableView
        detailsView.delegate = tableViewDelegate
        detailsView.dataSource = tableViewDelegate
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        forecastView.layer.cornerRadius = 5
        detailsView.layer.cornerRadius = 5
        
        if selectedCity == nil {
            selectedCity = wc.citiesSuggestions(for: "Jakarta")[1]
        }
        
        wc.forecast(for: selectedCity){ (forecast) in
            print(forecast)
            DispatchQueue.main.async{
                var tempDate : Date?
                var first: Bool = true
                var second: Bool = true
                var third: Bool = true
                var fourth = true
                var fifth = true
                var sixth = true
                for weather in forecast!{
                    if(first){
                        self.Weekdate.text = self.formatDate(for: weather.date)
                        self.Description1.text = weather.temperature.description + " °C"
                        self.cat1.text = weather.weather[0].title
                        tempDate = Calendar.current.date(byAdding: .day, value:1, to:weather.date)
                        first = false
                    }
                    if(self.formatDate(for: weather.date) == self.formatDate(for: tempDate!) && second){
                        self.Date2.text = self.formatDate(for: weather.date)
                        self.Description2.text = weather.temperature.description + " °C"
                        self.cat2.text = weather.weather[0].title
                        tempDate = Calendar.current.date(byAdding: .day, value:1, to:weather.date)
                        second = false
                    }
                    if(self.formatDate(for: weather.date) == self.formatDate(for: tempDate!) && third){
                        self.Date3.text = self.formatDate(for: weather.date)
                        self.Description3.text = weather.temperature.description + " °C"
                        self.cat3.text = weather.weather[0].title
                        tempDate = Calendar.current.date(byAdding: .day, value:1, to:weather.date)
                        third = false
                    }
                    if(self.formatDate(for: weather.date) == self.formatDate(for: tempDate!) && fourth){
                        self.Date4.text = self.formatDate(for: weather.date)
                        self.Description4.text = weather.temperature.description + " °C"
                        self.cat4.text = weather.weather[0].title
                        tempDate = Calendar.current.date(byAdding: .day, value:1, to:weather.date)
                        fourth = false
                    }
                    if(self.formatDate(for: weather.date) == self.formatDate(for: tempDate!) && fifth){
                        self.Date5.text = self.formatDate(for: weather.date)
                        self.Description5.text = weather.temperature.description + " °C"
                        self.cat5.text = weather.weather[0].title
                        tempDate = Calendar.current.date(byAdding: .day, value:1, to:weather.date)
                        fifth = false
                    }
                    
                }
            }
        }
        
        cityNameLabel.text = "\(selectedCity.name), \(selectedCity.country)"
        
        wc.weather(for: selectedCity) { (forecast) in
            print(forecast)
            DispatchQueue.main.async {
//                if(forecast?.weather.titl)
//                self.date.text = forecast?.date.description
//                self.temp.text = forecast?.temperature.description
//                self.pression.text = forecast?.pressure.description
                
                let todayDate = forecast?.date.description
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "EEEE, d MMM"
                
                let dateF = dateFormatterGet.date(from: todayDate!)
            
                self.dayDate.text = dateFormatterPrint.string(from: dateF!).uppercased()
                
                let temperatureMax = Int((forecast?.temperatureMax)!)
                let temperatureMin = Int((forecast?.temperatureMin)!)
                let temperatureAvg = Int((forecast?.temperature)!)
                
                //var detailsArray: [String] = []
//                self.dataArray.append((forecast?.humidity.description)!)
//                self.dataArray.append((forecast?.pressure.description)!)
//                self.dataArray.append((forecast?.windOrientation.description)!)
//                self.dataArray.append((forecast?.windSpeed.description)!)
                
                self.pressureLabel.text = (forecast?.pressure.description)!
                self.humidityLabel.text = (forecast?.humidity.description)!
                self.speedLabel.text = (forecast?.windSpeed.description)!
                self.orientationLabel.text = (forecast?.windOrientation.description)!
                

                
                let str = forecast?.weather.description
 
                let string = str!.replacingOccurrences(of: "[(title: \"", with: "")
                if let range = string.range(of: "description") {
                    let firstPart = string[string.startIndex..<range.lowerBound]
                    let weatherName = firstPart.replacingOccurrences(of: "\",", with: "")
                    
                    self.modifyBasedOnWeather(weatherName: weatherName, tempMax: temperatureMax, tempMin: temperatureMin, temp: temperatureAvg)
                }
            }
            
        }

    }
    
    func formatDate(for date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
    
    @IBAction func showDetails(_ sender: Any) {
        animateInDetails()
    }
    
    @IBAction func closeDetails(_ sender: Any) {
        animateOutDetails()
    }
    
    func animateInDetails() {
        self.view.addSubview(detailsView)
       
        detailsView.center = self.view.center
        
        detailsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        detailsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.detailsView.alpha = 1
            self.detailsView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOutDetails() {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.detailsView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.detailsView.removeFromSuperview()
        }
    }
    
    @IBAction func showForecast(_ sender: Any) {
        animateInForecast()
    }
    
    @IBAction func closeForecast(_ sender: Any) {
        animateOutForecast()
    }
    
    func animateInForecast() {
        self.view.addSubview(forecastView)
        
        forecastView.center = self.view.center
        
        forecastView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        forecastView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.forecastView.alpha = 1
            self.forecastView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOutForecast() {
        UIView.animate(withDuration: 0.3, animations: {
            self.forecastView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.forecastView.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.forecastView.removeFromSuperview()
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
            self.descriptionLine2.text = "Expected highest : \(tempMax)°C."
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
