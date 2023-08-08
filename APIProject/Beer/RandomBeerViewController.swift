//
//  RandomBeerViewController.swift
//  APIProject
//
//  Created by 홍수만 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class RandomBeerViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var beerImage: UIImageView!
    @IBOutlet var beerName: UILabel!
    @IBOutlet var beerDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        callRequest()
    }
    


}

extension RandomBeerViewController{
    
    func configureView() {
        titleLabel.text = "랜덤으로 맥주를 추천해드려요!"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        beerName.textAlignment = .center
        beerName.font = .boldSystemFont(ofSize: 17)
        
        beerDescription.numberOfLines = 0
        beerDescription.font = .boldSystemFont(ofSize: 15)
    }
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)[0]
                print("JSON: \(json)")
                
                print("test=======")
                let name = json["name"].stringValue
                let imageURL = json["image_url"].stringValue
                let description = json["description"].stringValue
                print(name, imageURL, description)
                
                AF.request(imageURL).responseData { response in
                           switch response.result {
                           case .success(let data):
                               if let image = UIImage(data: data) {
                                   self.beerImage.image = image
                               } else {
                                   print("Failed to convert data to image.")
                               }
                           case .failure(let error):
                               print("Error loading image: \(error)")
                           }
                       }
                
                self.beerName.text = name
                self.beerDescription.text = description
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
