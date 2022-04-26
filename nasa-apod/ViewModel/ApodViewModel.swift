//
//  ApodViewModel.swift
//  Dummy
//
//  Created by Ladoo on 24/04/2022.
//  Copyright © 2022 Ladoo. All rights reserved.
//

import Foundation
import UIKit

class ViewModel {
    var date: String?
    var title: String?
    var explanation: String?
    var url: String?
    
    func updateViewModel(for success:Bool, apiResponse: [String : Any]) {
        self.date = apiResponse["date"] as? String
        self.title = apiResponse["title"] as? String
        self.explanation = apiResponse["explanation"] as? String
        self.url = apiResponse["url"] as? String
        
        if success {
            self.store(response: apiResponse, forKey: "details")
        }
    }
    
    func getNasaApod(completion : @escaping(_ success: Bool, _ error: String?, _ cached: Bool) -> Void){
        
        guard let apiResource = APIResource.get() else {
            return
        }
        
        let todaysDay = getTodaysDate()
        
        let apiManager = ApiManager()
        
        if let apodResource = apiResource["apodResource"],
            let url = URL(string: "\(apodResource["host"] ?? "")?api_key=\(apodResource["apiKey"] ?? "")&date=\(todaysDay)")
        {
            apiManager.get(with: url, resultType: NasaApodResponse.self) { (httpResponse, error) in
                DispatchQueue.main.async {
                    if error == nil && httpResponse != nil {
                        if let response = httpResponse {
                            self.updateViewModel(for: true, apiResponse: response.asDictionary)
                            _ = completion(true, nil, false)
                        }
                    } else {
                        if let prevApodResponse = self.getPrevApod() {
                            self.updateViewModel(for: false, apiResponse: prevApodResponse)
                            _ = completion((prevApodResponse["date"] as? String == todaysDay), error, true)
                        } else {
                            _ = completion(false, error, false)
                        }
                    }
                }
            }
        } else {
            _ = completion(false, "Something went wrong while preparing URL!", false)
        }
    }
    
    private func getTodaysDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func loadImage(from imageUrl: String?, _ completion: @escaping(_ image: UIImage?) -> Void){
        if let imageURL = imageUrl,
            let url = URL(string: imageURL) {
            ApiManager().downloadImage(from: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                self.storeImage(image: image)
                _ = completion(image)
            }
        }
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
            let image = UIImage(data: imageData) {
            return image
        } else {
            return nil
        }
    }
    
    private func getPrevApod() -> [String: Any]? {
        if let prevApodDetails = UserDefaults.standard.object(forKey: "details") {
            return prevApodDetails as? [String : Any]
        } else {
            return nil
        }
    }
    
    private func store(response: [String: Any],
                       forKey key: String) {
        UserDefaults.standard.set(response, forKey: key)
    }
    
    private func storeImage(image: UIImage?) {
        
        if let apodImage = image,
            let pngRepresentation = apodImage.pngData(){
            DispatchQueue.global(qos: .background).async {
                UserDefaults.standard.set(pngRepresentation, forKey: "image")
            }
        }
    }
}

