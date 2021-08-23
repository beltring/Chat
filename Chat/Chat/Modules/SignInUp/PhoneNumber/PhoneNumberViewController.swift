//
//  PhoneNumberViewController.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import UIKit
import PhoneNumberKit

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: PhoneNumberTextField!
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
    }
    
    private func setupTextField() {
        numberTextField.delegate = self
        numberTextField.withFlag = true
        numberTextField.withExamplePlaceholder = true
        numberTextField.withPrefix = true
    }
    
    // MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        TDManager.shared.setPhoneNumber(number: numberTextField.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Extensions
// MARK: - UITextFieldDelegate
extension PhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 17
    }
}