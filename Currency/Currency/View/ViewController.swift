//
//  ViewController.swift
//  Currency
//
//  Created by 서상의 on 2021/01/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var orderedList: [(key: String, value: String)]!
    var viewModel: CurrencyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = CurrencyService(session: .shared)
        viewModel = CurrencyViewModel(service: service)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        viewModel.delegate = self
        
    }

    @IBAction func showPickerView(_ sender: Any) {
        currencyPickerView.isHidden = false
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderedList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orderedList[row].value
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = orderedList[row].key
        
        viewModel.changeDestination(to: code)
        
        pickerView.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        viewModel.requestCurrencyRate()
    }
}

extension ViewController: CurrencyViewModelDelegate {
    func currencyViewModel(didChangeDestination destination: String, description: String) {
        self.sendToLabel.text = description
    }
    
    func currencyViewModel(didChangeCurrencyList list: [String:String]) {
        orderedList = list.sorted(by: >)
        currencyPickerView.reloadAllComponents()
    }
    
    func currencyViewModel(didReceiveCurrency currency: [String : String]) {
        DispatchQueue.main.async {
            self.timeLabel.text = currency["time"]!
            self.rateLabel.text = currency["description"]!
        }
    }
    
    func currencyViewModel(didReceiveError error: String) {
        
    }

}
