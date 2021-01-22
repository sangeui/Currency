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
    
    var list: [String: String]!
    var orderedList: [(key: String, value: String)]!
    var viewModel: CurrencyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = CurrencyService(session: .shared)
        viewModel = CurrencyViewModel(service: service)
        
        self.list = viewModel.list
        self.orderedList = viewModel.list.sorted(by: >)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
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
        sendToLabel.text = orderedList[row].value
        pickerView.isHidden = true
    }
}
