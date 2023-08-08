//
//  BeerViewController.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        titleLabel.text = beer?.title
        descriptionLabel.text = beer?.description
        let imageUrl = URL(string: beer?.image ?? "")
        beerImage.kf.setImage(with: imageUrl)
    }
    
    @IBAction func beerChangeButton(_ sender: Any) {
        getBeer()
    }
    
    private func getBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { [weak self] response in
            guard let self else {return}
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let imageurl = json[0]["image_url"].stringValue
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
                beerImage.kf.indicatorType = .activity
                beerImage.kf.setImage(
                    with: URL(string: imageurl),
                    placeholder: UIImage(named: "noImage"),
                    options: [
                        .retryStrategy(retryStrategy),
                        .transition(.fade(0.5))
                    ]
                )
                titleLabel.text = name
                descriptionLabel.text = description
      
            case .failure(let error):
                print(error)
            }
        }
    }

}
