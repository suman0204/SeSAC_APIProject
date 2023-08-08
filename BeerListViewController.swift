//
//  BeerListViewController.swift
//  APIProject
//
//  Created by 홍수만 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Beer {
    var name: String
    var tagline: String
    var abv: Double
    var ibu: Double
    var srm: Double
    var imageURL: String
    
    var infoText: String {
        return "ABV: \(abv) | IBU: \(ibu) | SRM: \(srm)"
    }
}

class BeerListViewController: UIViewController {

    var beerList: [Beer] = []
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var beerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerTableView.delegate = self
        beerTableView.dataSource = self
        
        callRequest()
        
//        let nib = UINib(nibName: "BeerListTableViewCell", bundle: nil)
//        beerTableView.register(nib, forCellReuseIdentifier: "BeerListTableViewCell")
        
        let nib = UINib(nibName: "BeerListTableViewCell", bundle: nil)
        beerTableView.register(nib, forCellReuseIdentifier: "BeerListTableViewCell")
    }
    



}

extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                print("beer info=====")
                for item in json.arrayValue {
                    let name = item["name"].stringValue
                    let tagline = item["tagline"].stringValue
                    let abv = item["abv"].doubleValue
                    let ibu = item["ibu"].doubleValue
                    let srm = item["srm"].doubleValue
                    let imageURL = item["image_url"].stringValue
                    
                    let beer = Beer(name: name, tagline: tagline, abv: abv, ibu: ibu, srm: srm, imageURL: imageURL)
                    
                    self.beerList.append(beer)
                }
                
                self.beerTableView.reloadData()

                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = beerTableView.dequeueReusableCell(withIdentifier: "BeerListTableViewCell") as! BeerListTableViewCell
        
        AF.request(beerList[indexPath.row].imageURL).responseData { response in
                   switch response.result {
                   case .success(let data):
                       if let image = UIImage(data: data) {
                           cell.beerImage.image = image
                       } else {
                           print("Failed to convert data to image.")
                       }
                   case .failure(let error):
                       print("Error loading image: \(error)")
                   }
               }
        
        cell.beerTitle.text = beerList[indexPath.row].name
        cell.beerTagline.text = beerList[indexPath.row].tagline
        cell.beerInfo.text = beerList[indexPath.row].infoText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
