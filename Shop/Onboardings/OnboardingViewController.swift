//
//  OnboardingViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit

class OnboardingViewController: UIViewController {

    let images = ["Onboarding 2", "Onboarding 3"]
    let titles = ["Начнем путешествие", "У Вас Есть Сила,\nЧтобы"]
    let texts = ["Умная, великолепная и модная\nколлекция Изучите сейчас", "В вашей комнате много красивых и\nпривлекательных растений"]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    

    @objc func nextButtonTapped() {
        if counter < 2 {
            counter += 1
            setupUI()
        } else {
            tabbar.modalPresentationStyle = .fullScreen
            UserDefaults.standard.set(true, forKey: "OnboardingsPassed")
            present(tabbar, animated: true)
        }
    }
    
    func setupUI() {
        titleLabel.text = titles[counter - 1]
        textLabel.text = texts[counter - 1]
        pageControl.currentPage = counter
    }
}
