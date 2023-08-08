//
//  ViewController.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

final class LottoViewController: UIViewController {
    
    @IBOutlet weak var winBackView: UIView!
    @IBOutlet weak var bonusBackView: UIView!
    @IBOutlet weak var drwNoLabel: UILabel!
    @IBOutlet weak var drwNoDateLabel: UILabel!
    @IBOutlet var ballColorViews: [UIView]!
    @IBOutlet var drwtNoLabels: [UILabel]!
    @IBOutlet weak var firstWinamntLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var selectionButton: UIButton!
    
    let pickerView = UIPickerView()
    let ballColors: [UIColor] = [.systemYellow, .systemBlue, .systemRed, .darkGray, .systemGreen]
    var list: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.inputView = pickerView
        numberTextField.tintColor = .clear
        pickerView.delegate = self
        pickerView.dataSource = self
        configUI()
        for i in stride(from: 1079, to: 1000, by: -1) {
            list.append(i)
        }
        getLotto(num: 1079)
    }
    
    private func getLotto(num: Int) {
        let url = "http://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(num)"
        AF.request(url, method: .get).validate().responseJSON { [weak self] response in
            guard let self else {return}
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let drwNoDate = json["drwNoDate"].stringValue
                let firstWinamnt = json["firstWinamnt"].intValue
                let bnusNo = json["bnusNo"].intValue
                
                for i in 0..<self.ballColorViews.count - 1 {
                    let num = json["drwtNo\(i+1)"].intValue
                    self.ballColorViews[i].backgroundColor = self.ballColors[(num - 1) / 10]
                    self.drwtNoLabels[i].text = "\(num)"
                }
                self.ballColorViews[6].backgroundColor = self.ballColors[(bnusNo - 1) / 10]
                self.drwtNoLabels[6].text = "\(bnusNo)"
                
                self.firstWinamntLabel.text = self.numberFormatter(num: firstWinamnt)
                self.drwNoLabel.text = "\(num)회"
                self.drwNoDateLabel.text = self.dateformatter(dateString: drwNoDate) + "추첨"
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configUI() {
        ballColorViews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
        }
        
        winBackView.layer.cornerRadius = 10
        bonusBackView.layer.cornerRadius = 10
    }
    
    private func dateformatter(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        return dateFormatter.string(from: date!)
    }
    
    private func numberFormatter(num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: num as NSNumber) ?? ""
        return formattedNumber + "원"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 행 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 열 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getLotto(num: list[row])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])"
    }
}
