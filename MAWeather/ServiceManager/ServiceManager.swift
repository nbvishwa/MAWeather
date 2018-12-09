//
//  ServiceManager.swift
//  MAWeather
//
//  Created by Vishwavijet on 09/12/18.
//  Copyright © 2018 Tarento. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ServiceManager {
    
    private let baseURL: String = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey: String = "3ea317d2f3bec55a6ca05a15b9808207"
    
    
    
    
    private func getCompleteURL(_ city: String) -> URL {
        let queryItems = [URLQueryItem(name: "q", value: city), URLQueryItem(name: "APPID", value: apiKey)]
        let urlComps = NSURLComponents(string: baseURL)!
        urlComps.queryItems = queryItems
        let URL = urlComps.url!
        print(URL)
        
        return URL
    }
    
    func getWeatherData(for city:String, completionHandler:@escaping ((_ weatherData : WeatherModel?,_ error: Error?) -> Void)){
        let session = URLSession.shared
        
        session.dataTask(with: self.getCompleteURL(city)) { (data, response, error) in
            let receivedResponse : HTTPURLResponse = response! as! HTTPURLResponse
            var parsedData : Dictionary<String, Any> = [:]
            if receivedResponse.statusCode == 200 {
                
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary
                }
                catch {
                    print("Response is invalid")
                }
                let model = WeatherModel.init(parsedData)
                //Core Data Stuff
                self.saveToCoreData(model.name!, completion: { (status) in
                    completionHandler(model,nil)
                })
            }
            else if receivedResponse.statusCode == 404 {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary
                    let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey : parsedData["message"] as! String])
                    completionHandler(nil, error)
                }
                catch {
                    print("Response is invalid")
                }
            }
            
        }.resume()
    }
    
    private func saveToCoreData(_ city: String, completion: ((_ status: Bool) -> Void)){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let existingResults = self.getRecordsFromCoreData()
        let exists = existingResults.contains { (cityName) -> Bool in
            if cityName.lowercased() == city.lowercased() {
                return true
            }
            else{
                return false
            }
        }
        if !exists {
            let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context)
            let newCity = NSManagedObject(entity: entity!, insertInto: context)
            newCity.setValue(city, forKey: "cityName")
            do {
                try context.save()
                completion(true)
            } catch {
                print("Failed saving")
                completion(false)
            }
        }
        else{
            completion(false)
        }
        
    }
    
    func getRecordsFromCoreData() -> [String] {
        var results : [String] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                results.append(data.value(forKey: "cityName") as! String)
            }
        } catch {
            print("Failed")
        }
        return results
    }
}
