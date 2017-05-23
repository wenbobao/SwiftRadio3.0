//
//  DataManager.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 3/24/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import UIKit

class DataManager {
    
    //*****************************************************************
    // Helper Class to get either local or remote JSON
    //*****************************************************************
    
    class func getStationDataWithSuccess(success: @escaping (Data) -> Void) {
        
        if useLocalStations {
            getDataFromFileWithSuccess() { data in
                success(data)
            }
        } else {
            loadDataFromURL(url: URL.init(string: stationDataURL)!, completion: {
                (data, error) -> Void in
                
                if let urlData = data {
                    success(urlData)
                } else {
                    if DEBUG_LOG { print("LAST FM TIMEOUT OR ERROR") }
                }
                
            })
        }
    }
    
    //*****************************************************************
    // Load local JSON Data
    //*****************************************************************
    
    class func getDataFromFileWithSuccess(success: @escaping (Data) -> Void) {
        
        DispatchQueue.global().async {
            
            let filePath = Bundle.main.path(forResource: "stations", ofType: "json")
            
            let fileURL = URL(fileURLWithPath: filePath!)
            
            do {
                let data = try Data(contentsOf: fileURL)
                success(data)
            } catch {
                fatalError()
            }
            
        }
        
    }
    
    //*****************************************************************
    // Get LastFM Data
    //*****************************************************************
    
    class func getTrackDataWithSuccess(queryURL: String, success: @escaping (Data) -> Void) {

        loadDataFromURL(url: URL.init(string: queryURL)!, completion: {
            (data, error) -> Void in
            
            if let urlData = data {
                success(urlData)
            } else {
                if DEBUG_LOG { print("LAST FM TIMEOUT OR ERROR") }
            }
         
        })
    }
    
    //*****************************************************************
    // REUSABLE DATA/API CALL METHOD
    //*****************************************************************
    
    class func loadDataFromURL(url: URL, completion:@escaping (Data?, Error?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess          = true
        sessionConfig.timeoutIntervalForRequest     = 15
        sessionConfig.timeoutIntervalForResource    = 30
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        let session = URLSession(configuration: sessionConfig)
        
        // Use NSURLSession to get data from an NSURL
        
        let loadDataTask = session.dataTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            
            if error != nil {
                completion(nil, error)
                
                if DEBUG_LOG { print("API ERROR: \(error)") }
                
                // Stop activity Indicator
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    
                    let statusError = NSError(domain:"io.codemarket", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    
                    if DEBUG_LOG { print("API: HTTP status code has unexpected value") }
                    
                    completion(nil, statusError)
                    
                } else {
                    
                    // Success, return data
                    completion(data, nil)
                }
            }
        
        })
        
        loadDataTask.resume()
    }
}
