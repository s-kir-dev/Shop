//
//  SignInViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit
import FirebaseFirestore

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    var validatedEmail: Bool = false
    var validatedPassword: Bool = false
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToolBar(emailTextField) // вызов функции создания панели
        addToolBar(passwordTextField) // вызов функции создания панели
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
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
    
    @objc func signInButtonTapped() {
        validatedEmail = validateEmail()
        validatedPassword = validatePassword()
        if validatedEmail && validatedPassword {
            let alert = UIAlertController(title: "Успешно!", message: "Вход в аккаунт выполнен успешно!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ок", style: .cancel, handler: { _ in
                self.db
                  .collection("Users")
                  .document("\(self.emailTextField.text!)").setData([
                    "email": "\(self.emailTextField.text!)",
                    "password": "\(self.passwordTextField.text!)"
                ])
                UserDefaults.standard.set(self.emailTextField.text, forKey: "Email")
                UserDefaults.standard.set(true, forKey: "SignedIn")
                welcomeVC.modalPresentationStyle = .fullScreen
                self.present(welcomeVC, animated: true)
            })
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    
    @objc func dismissPasswordKeyboard() { // функция для проверки корректности ввода пароля
        view.endEditing(true)
        if !validatePassword() {
            validatedPassword = false
            let alert = UIAlertController(title: "Ошибка", message: "Слишком короткий пароль. Введите не менее 6 символов.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Oк", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
    
    
    @objc func dismissEmailKeyboard() { // функция для проверки корректности ввода электронной почты
        view.endEditing(true)
        if !validateEmail() {
            validatedPassword = false
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
