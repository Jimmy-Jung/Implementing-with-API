//
//  BeerTableViewController.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Beer {
    let title: String
    let description: String
    let image: String
}

class BeerTableViewController: UIViewController {
    
    @IBOutlet weak var beerTableView: UITableView!
    var beerList: [Beer] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beer"
        navigationController?.navigationBar.prefersLargeTitles = true
        beerTableView.delegate = self
        beerTableView.dataSource = self
        beerTableView.rowHeight = 128
        getBeer()
    }
    
    private func getBeer() {
        let url = "https://api.punkapi.com/v2/beers?page=1&per_page=20"
        AF.request(url, method: .get).validate().responseJSON { [weak self] response in
            guard let self else {return}
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let jsonArray = json.arrayValue
                for item in jsonArray {
                    let beer = Beer(
                        title: item["name"].stringValue,
                        description: item["description"].stringValue,
                        image: item["image_url"].stringValue
                    )
                    beerList.append(beer)
                }
                beerTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension BeerTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.identifier) as! BeerTableViewCell
        cell.beer = beerList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: BeerViewController.identifier) as! BeerViewController
        vc.beer = beerList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
