/// PROJET OPEN WEATHER MAP L3 DANT SORBONNE UNIVERSITÉ 2018-2019 ///
/// BEZALIEL MARVEL PRIBADI & MOHAMMED NGUYEN LAM ///////////////////

import PlaygroundSupport
import WebKit

PlaygroundPage.current.needsIndefiniteExecution = true

let API_KEY = "057235dd5c2aec8dee5db666fe163476"

let singleURL : String = "https://api.openweathermap.org/data/2.5/weather"
let groupURL : String = "https://api.openweathermap.org/data/2.5/group"
let forecastURL : String = "https://api.openweathermap.org/data/2.5/forecast"

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        return components?.url
    }
}

////////////////////////////// S T R U C T ////////////////////////////////////////

struct resForecast: Codable {
    let cod: String
    let message: Float
    let cnt: Int
    let list: [listItem]
    let city: city
}

struct listItem: Codable {
    let dt: Int
    let main: main
    let weather: [weather]
    let clouds: clouds?
    let wind: wind?
    let snow: snow?
    let sys: sysForecast
    let dt_txt: String
}

struct city: Codable {
    let id: Int
    let name: String
    let coord: coord
    let country: String
}

struct listRes: Codable {
    let list: [resultat]
}

struct resultat: Codable {
    let name: String
    let id: Int
    let weather: [weather]
    let coord: coord
    let sys: sys
    let main: main
    let wind: wind?
    let clouds: clouds?
    let visibility: Int
    let dt: Int
}

struct weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct sysForecast: Codable {
    let pod: String
}

struct sys: Codable {
    let type: Int
    let id: Int
    let message: Double
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct main: Codable {
    let temp: Float?
    let pressure: Float?
    let humidity: Float?
    let temp_min: Float?
    let temp_max: Float?
}

struct coord: Codable {
    let lon: Double
    let lat: Double
}

struct wind: Codable {
    let speed: Float?
    let deg: Float?
    
    enum MyStructKeys: String, CodingKey {
        case speed, deg
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self)
        self.speed = try container.decodeIfPresent(Float.self, forKey: .speed) ?? 0.0
        self.deg = try container.decodeIfPresent(Float.self, forKey: .deg) ?? 0.0
    }
    
    init() {
        self.speed = 0.0
        self.deg = 0.0
    }
}

struct snow: Codable {
    let one: Float?
    let three: Float?
    
    private enum CodingKeys: String, CodingKey {
        case one = "1h"
        case three = "3h"
    }
    
    init() {
        self.one = 0.0
        self.three = 0.0
    }
}

struct clouds: Codable {
    let all: Float?
}

///////////////////////////// F U N C T I O N S ///////////////////////////////////////////

// lire le fichier json de la liste des villes et le decoder
func readJson() -> [String: String]? {
    struct City: Codable {
        let id: Int
        let name: String
    }
    do {
        if let file = Bundle.main.url(forResource: "city.list.min", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let  cities = try JSONDecoder().decode([City].self, from: data)
            var citiesDictionary = [String: String]()
            for (city) in cities {
                citiesDictionary[city.name] = String(city.id)
            }
            return citiesDictionary;
        } else {
            print("no file")
            return nil;
        }
    } catch {
        print("error")
        print(error.localizedDescription)
    }
    return nil;
}

// retourner le city id à partir de city name
func getCityIdFromCityName (cityName: String, cityDic: [String: String]) -> String? {
    if let cityId = cityDic[cityName] {
        return cityId;
    } else {
        print("cityNotFound");
        return nil;
    }
}

// retourner un tableau de city id à partir d'un tableau de city name
func getMultipleCityIdsFromCityNames (cityTab: [String], cityDic: [String: String]) -> [String]? {
    var tabCity = [String]()
    for cityName in cityTab{
        if let cityId = cityDic[cityName] {
            tabCity.append(cityId);
        } else {
            print("cityNotFound");
            return nil;
        }
    }

    return tabCity
}

// renvoie la meteo actuelle pour une ville à partir de son city id
func getCurrentWeatherForCity(cityId: String) -> URLSessionTask {
    
    let query: [String: String] = [
        "id": cityId,
        "appid": API_KEY
    ]
    
    let stringURL = URL(string : singleURL)!
    let url = stringURL.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
        do{
            guard let data = data else{return}
            let res = try JSONDecoder().decode(resultat.self, from: data)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json = try! encoder.encode(res)
            print(String(data: json, encoding: .utf8) ?? "Default Value")
        }catch let erreur{
            print(erreur)
        }
        
    }

    return task
}

// renvoie la meteo actuelle pour une liste de ville à partir d'un tableau de ville
func getCurrentWeatherForMultipleCities(listCityId: [String]) -> URLSessionTask {
    
    var multipleCityIDs = ""
    for string in listCityId
    {
        multipleCityIDs.append(string)
        multipleCityIDs.append(",")
        
    }
    multipleCityIDs.removeLast()

    let query: [String: String] = [
        "id": multipleCityIDs,
        "appid": API_KEY
    ]
    
    let stringURL = URL(string : groupURL)!
    let url = stringURL.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
        do{
            guard let data = data else{return}
            let res = try JSONDecoder().decode(listRes.self, from: data)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json = try! encoder.encode(res)
            print(String(data: json, encoding: .utf8) ?? "Default Value")
        }catch let erreur{
            print(erreur)
        }
        
    }
    
    return task
}

// renvoie la prevision de la meteo pour 5 jours / 3 heures pour une ville à partir de son city id
func getWeatherForecastForCity(cityId: String) -> URLSessionTask {
    
    let query: [String: String] = [
        "id": cityId,
        "appid": API_KEY
    ]
    
    let stringURL = URL(string : forecastURL)!
    let url = stringURL.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
        do{
            guard let data = data else{return}
            let res = try JSONDecoder().decode(resForecast.self, from: data)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let json = try! encoder.encode(res)
            print(String(data: json, encoding: .utf8) ?? "Default Value")
        }catch let erreur{
            print(erreur)
        }
        
    }
    
    return task
}

//////////////////////////////////// M A I N ////////////////////////////////////////////////

// TEST SANS READJSON()
//getCurrentWeatherForCity(cityId: "3890338").resume()
//let tabCityId = ["3890338","3106054"]
//getCurrentWeatherForMultipleCities(listCityId: tabCityId).resume()
//getWeatherForecastForCity(cityId: "524901").resume()


// TEST AVEC READJSON()

let cityIdLondon = getCityIdFromCityName(cityName: "London", cityDic: readJson() ?? <#default value#>)
//print(cityIdLondon)
//let tabCityId = getMultipleCityIdsFromCityNames(cityTab: ["London","Paris"], cityDic: readJson() ?? <#default value#>)

getCurrentWeatherForCity(cityId: cityIdLondon ?? <#default value#>).resume()
//getCurrentWeatherForMultipleCities(listCityId: tabCityId ?? default value).resume()
//getWeatherForecastForCity(cityId: cityIdLondon ?? <#default value#>).resume()


