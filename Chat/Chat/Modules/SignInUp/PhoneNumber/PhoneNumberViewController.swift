//
//  PhoneNumberViewController.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import PhoneNumberKit
import UIKit

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet private weak var numberTextField: PhoneNumberTextField!
    
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
    @IBAction private func nextTapped(_ sender: Any) {
        guard let phoneNumber = numberTextField.text else { return }
        navigationController?.pushViewController(AuthenticationCodeViewController.initial(), animated: true)
        TDManager.shared.setPhoneNumber(number: phoneNumber) { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.pushViewController(AuthenticationCodeViewController.initial(), animated: true)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
