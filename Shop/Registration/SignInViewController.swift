//
//  SignInViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBar(emailTextField) // вызов функции создания панели
        addToolBar(passwordTextField) // вызов функции создания панели
        
    }
    
    func addToolBar(_ textField: UITextField) { // функция для добавления панели с кнопкой Готово, по нажатию на которую происходит проверка корректности ввода данных и скрытие клавиатуры
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPasswordKeyboard))
        
        if textField == emailTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEmailKeyboard))
        }
        
        toolbar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    
    @objc func dismissPasswordKeyboard() { // функция для проверки корректности ввода пароля
        view.endEditing(true)
        if !validatePassword() {
            let alert = UIAlertController(title: "Ошибка", message: "Слишком короткий пароль. Введите не менее 6 символов.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Oк", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    
    @objc func dismissEmailKeyboard() { // функция для проверки корректности ввода электронной почты
        view.endEditing(true)
        if !validateEmail() {
            let alert = UIAlertController(title: "Ошибка", message: "Неверный формат электронной почты.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Oк", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    
    func validateEmail() -> Bool { // функция возвращающая истину, если введенная электронная почта заканчивается на @gmail.com и ложь во всех иных случаях
        guard let email = emailTextField.text else { return false }
        return email.hasSuffix("@gmail.com")
    }
    
    
    func validatePassword() -> Bool { // функция возвращающая истину, если введенный пароль содержит как минимум 6 символов и ложь во всех иных случаях
        guard let password = passwordTextField.text else { return false }
        return password.count >= 6
    }

}
