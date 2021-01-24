//
//  ViewController.swift
//  Currency
//
//  Created by 서상의 on 2021/01/20.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var textFieldToolbar: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var currencyList: [(key: String, value: String)]!
    
    var viewModel: CurrencyViewModel = {
        let service = CurrencyService(session: .shared)
        let viewModel = CurrencyViewModel(service: service)
        
        return viewModel
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.inputAccessoryView = textFieldToolbar
    }

    @IBAction func closeKeyboard(_ sender: Any) {
        textField.resignFirstResponder()
    }
    @IBAction func showPickerView(_ sender: Any) {
        textField.resignFirstResponder()
        pickerView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let number = textField.text?.asDouble else { return }
        let calculated = viewModel.calculate(number)
        
        textField.textColor = (calculated != nil) ? Color.text : Color.error
    }
}

extension String {
    var asDouble: Double? { return Double(self) }
}
// MARK: - UIPickerViewDataSource
extension CurrencyViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row].value
    }
}
// MARK: - UIPickerViewDelegate
extension CurrencyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code = currencyList[row].key
        
        viewModel.changeDestination(to: code)
        viewModel.requestCurrencyRate()
        
        pickerView.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
}
// MARK: - UITextFieldDelegate
extension CurrencyViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - CurrencyViewModelDelegate
extension CurrencyViewController: CurrencyViewModelDelegate {
    var amountInTextField: Double? {
        guard let amount = self.textField.text?.asDouble, amount > 0
        else { return nil }
        
        return amount
    }
    func currencyViewModel(didChangeDestination destination: String, description: String) {
        self.sendToLabel.text = description
        self.resultLabel.text = "송금액을 입력하세요"
        self.resultLabel.textColor = Color.text
    }
    
    func currencyViewModel(didChangeCurrencyList list: [String:String]) {
        currencyList = list.sorted(by: >)
        pickerView.reloadAllComponents()
    }
    
    func currencyViewModel(didReceiveCurrency currency: [String:String]) {
        DispatchQueue.main.async {
            self.timeLabel.text = currency["time"]!
            self.rateLabel.text = currency["description"]!
            
            if let amount = self.amountInTextField {
                self.viewModel.calculate(amount)
            }
        }
    }
    
    func currencyViewModel(didReceiveError error: String) {
        DispatchQueue.main.async {
            self.rateLabel.text = error
        }
    }
    
    func currencyViewModel(didCalculate result: String, isSuccessed: Bool) {
        resultLabel.text = result
        resultLabel.textColor = isSuccessed ? Color.text : Color.error
    }
}
