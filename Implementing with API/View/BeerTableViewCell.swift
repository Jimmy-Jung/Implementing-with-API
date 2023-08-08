//
//  BeerTableViewCell.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/08.
//

import UIKit
import Kingfisher

class BeerTableViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    
    var beer: Beer? {
        didSet {
            titleLabel.text = beer?.title
            descriptionLabel.text = beer?.description
            let imageUrl = URL(string: beer?.image ?? "")
            let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
            beerImageView.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "noImage"),
                options: [
                    .retryStrategy(retryStrategy),
                    .transition(.fade(0.5))
                ]
            )
        }
    }

    override func prepareForReuse() {
        beerImageView.image = UIImage(named: "noImage")
    }

}
