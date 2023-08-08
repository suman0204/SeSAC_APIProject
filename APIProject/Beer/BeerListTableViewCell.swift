//
//  BeerListTableViewCell.swift
//  APIProject
//
//  Created by 홍수만 on 2023/08/08.
//

import UIKit

class BeerListTableViewCell: UITableViewCell {
    @IBOutlet var beerImage: UIImageView!
    @IBOutlet var beerTitle: UILabel!
    @IBOutlet var beerTagline: UILabel!
    @IBOutlet var beerInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beerTitle.font = .boldSystemFont(ofSize: 17)
        beerTagline.font = .boldSystemFont(ofSize: 15)
        beerInfo.font = .systemFont(ofSize: 14)
    }

    
}
