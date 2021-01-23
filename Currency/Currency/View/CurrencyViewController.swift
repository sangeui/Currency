//
//  ViewController.swift
//  Currency
//
//  Created by 서상의 on 2021/01/20.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var orderedList: [(key: String, value: String)]!
    var viewModel: CurrencyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = CurrencyService(session: .shared)
        viewModel = CurrencyViewModel(service: service)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        viewModel.delegate = self
        
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        amountTextField.inputAccessoryView = toolbar
    }

    @IBAction func closeKeyboard(_ sender: Any) {
        amountTextField.resignFirstResponder()
    }
    @IBAction func showPickerView(_ sender: Any) {
        currencyPickerView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        guard let number = Double(text) else { return }
        
        viewModel.calculate(number)
    }
}

extension CurrencyViewController: UIPickerViewDataSource {
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

extension CurrencyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = orderedList[row].key
        
        viewModel.changeDestination(to: code)
        
        pickerView.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        viewModel.requestCurrencyRate()
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CurrencyViewController: CurrencyViewModelDelegate {
    func currencyViewModel(didChangeDestination destination: String, description: String) {
        self.sendToLabel.text = description
        self.descriptionLabel.text = "송금액을 입력하세요"
    }
    
    func currencyViewModel(didChangeCurrencyList list: [String:String]) {
        orderedList = list.sorted(by: >)
        currencyPickerView.reloadAllComponents()
    }
    
    func currencyViewModel(didReceiveCurrency currency: [String : String]) {
        DispatchQueue.main.async {
            self.timeLabel.text = currency["time"]!
            self.rateLabel.text = currency["description"]!
            
            if let text = self.amountTextField.text,
               let amount = Double(text),
               amount > 0 {
                self.viewModel.calculate(amount)
            }
        }
    }
    
    func currencyViewModel(didReceiveError error: String) {
        
    }
    
    func currencyViewModel(didCalculate result: String, isSuccessed: Bool) {
        if isSuccessed {
            descriptionLabel.text = result
        } else {
            
        }
    }

}
