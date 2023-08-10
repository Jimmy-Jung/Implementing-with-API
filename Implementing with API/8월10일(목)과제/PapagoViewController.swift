//
//  PapagoViewController.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit



final class PapagoViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleHeight: NSLayoutConstraint!
    @IBOutlet private weak var exchangeButton: UIButton!
    @IBOutlet private weak var selectOriginalButton: UIButton!
    @IBOutlet private weak var selectTranslatedButton: UIButton!
    @IBOutlet private weak var originalTextView: UITextView!
    @IBOutlet private weak var translatedTextView: UITextView!
    @IBOutlet private weak var copyButton: UIButton!
    private let pastedLabel = UILabel()
    
    private var networkWorkItem: DispatchWorkItem?
    private let textViewPlaceHolder = "번역할 내용를 입력하세요."
    private var originalLanguage: Language = .ko {
        didSet {
            selectOriginalButton.setTitle(originalLanguage.localizedString, for: .normal)
        }
    }
    private var translatedLanguage: Language = .en {
        didSet {
            selectTranslatedButton.setTitle(translatedLanguage.localizedString, for: .normal)
        }
    }
    private let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalLanguage = .ko
        translatedLanguage = .en
        setupTextView()
        setupPickerView()
        configUI()
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func requestDetectLang() {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Naver-Client-Id": APIKEY.Naver_Client_ID,
            "X-Naver-Client-Secret": APIKEY.Naver_Client_Secret
        ]
        let parameters: Parameters = [
            "query": originalTextView.text ?? ""
        ]
        translatedTextView.text += "..."
        AF.request(url, method: .post,parameters: parameters, headers: header).validate().responseJSON { [weak self] response in
            guard let self else {return}
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["langCode"].stringValue
                self.originalLanguage = Language(rawValue: data) ?? .ko
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestTranslate() {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Naver-Client-Id": APIKEY.Naver_Client_ID,
            "X-Naver-Client-Secret": APIKEY.Naver_Client_Secret
        ]
        let parameters: Parameters = [
            "source": originalLanguage.rawValue,
            "target": translatedLanguage.rawValue,
            "text": originalTextView.text ?? ""
        ]
        translatedTextView.text += "..."
        AF.request(url, method: .post,parameters: parameters, headers: header).validate().responseJSON { [weak self] response in
            guard let self else {return}
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["message"]["result"]["translatedText"].stringValue
                self.translatedTextView.text = data
            case .failure(let error):
                print(error)
                self.translatedTextView.text = ""
            }
        }
    }
    
    private func configUI() {
        exchangeButton.backgroundColor = .clear
        exchangeButton.layer.cornerRadius = 15
        exchangeButton.clipsToBounds = true
        exchangeButton.layer.borderWidth = 1
        exchangeButton.layer.borderColor = UIColor.darkGray.cgColor
        
        copyButton.layer.cornerRadius = 10
        copyButton.clipsToBounds = true
        copyButton.isEnabled = false
        makePastedMassage()
    }
    
    private func makePastedMassage() {
        pastedLabel.text = "클립보드에 복사되었습니다"
        pastedLabel.textColor = .white
        pastedLabel.textAlignment = .center
        pastedLabel.font = .boldSystemFont(ofSize: 14)
        pastedLabel.backgroundColor = .lightGray
        pastedLabel.layer.cornerRadius = 25
        pastedLabel.clipsToBounds = true
        pastedLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pastedLabel)

        pastedLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(copyButton.snp.top).offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        pastedLabel.alpha = 0
    }
    
    private func setupTextView() {
        originalTextView.delegate = self
        translatedTextView.delegate = self
        originalTextView.text = textViewPlaceHolder
        originalTextView.textColor = .lightGray
    }
    
    @IBAction func selectOriginalButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "언어를 선택하세요.", message: nil, preferredStyle: .actionSheet)
        let vc = UIViewController()
        vc.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        alert.setValue(vc, forKey: "contentViewController")
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self else { return }
            let row = pickerView.selectedRow(inComponent: 0)
            originalLanguage = Language.allCases[row]
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func selectTranslatedButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "언어를 선택하세요.", message: nil, preferredStyle: .actionSheet)
        let vc = UIViewController()
        vc.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        alert.setValue(vc, forKey: "contentViewController")
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self else { return }
            let row = pickerView.selectedRow(inComponent: 0)
            translatedLanguage = Language.allCases[row]
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction func exchangeButtonTapped(_ sender: UIButton) {
        sender.buttonTapEffect(target: .background, defaults: .clear, highlighted: .systemGreen)
        swap(&originalLanguage, &translatedLanguage)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        sender.buttonTapEffect(target: .tint, defaults: .label, highlighted: .systemGreen)
        originalTextView.text = ""
        translatedTextView.text = ""
        originalTextView.resignFirstResponder()
    }
    @IBAction func copyButtonTapped(_ sender: UIButton) {
        let clipboard = UIPasteboard.general
        clipboard.string = translatedTextView.text
        UIView.animate(withDuration: 0.5, animations: {
            self.pastedLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1) {
                self.pastedLabel.alpha = 0
            }
        })
    }
    
}

extension PapagoViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
            self.titleHeight.constant = 0
            self.view.layoutIfNeeded()
        }
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        requestTranslate()
        UIView.animate(withDuration: 0.3) {
            self.titleHeight.constant = 40
            self.view.layoutIfNeeded()
        }
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            translatedTextView.text = ""
            copyButton.isEnabled = false
        } else {
            // 이전에 예약된 네트워크 요청을 취소합니다.
            networkWorkItem?.cancel()
            
            // 지연 후 새로운 네트워크 요청을 예약합니다.
            let workItem = DispatchWorkItem { [weak self] in
                self?.requestTranslate()
                self?.requestDetectLang()
            }
            networkWorkItem = workItem
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + 0.3,
                execute: workItem
            )
        }
        if textView == translatedTextView, textView.text.isEmpty {
            copyButton.isEnabled = false
        } else {
            copyButton.isEnabled = true
        }
    }
}

extension PapagoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Language.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Language.allCases[row].localizedString
    }
    
}
