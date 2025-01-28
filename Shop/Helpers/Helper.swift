//
//  Helper.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import Foundation
import UIKit


let storyboard = UIStoryboard(name: "Main", bundle: nil)

let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController

let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") 

let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingViewController

let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
