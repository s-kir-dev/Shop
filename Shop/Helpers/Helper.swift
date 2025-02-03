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

let tabbar = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController

let descriptionVC = storyboard.instantiateViewController(withIdentifier: "DescriptionVC") as! DescriptionViewController

var favorites: [Product] = []
var cart: [Product] = []

func addToFavorite(_ product: Product) {
    favorites.append(product)
    uploadFavorites()
}

func addToCart(_ product: Product) {
    cart.append(product)
    uploadCart()
}

func uploadFavorites() {
    let encodedData = try! JSONEncoder().encode(favorites)
    UserDefaults.standard.set(encodedData, forKey: "favorites")
}

func uploadCart() {
    let encodedData = try! JSONEncoder().encode(cart)
    UserDefaults.standard.set(encodedData, forKey: "cart")
}

func downloadFavorites() -> [Product] {
    guard let savedData = UserDefaults.standard.data(forKey: "favorites") else { return [] }
    let favoritesArray = try! JSONDecoder().decode([Product].self, from: savedData)
    return favoritesArray
}

func downloadCart() -> [Product] {
    guard let savedData = UserDefaults.standard.data(forKey: "cart") else { return [] }
    let cartArray = try! JSONDecoder().decode([Product].self, from: savedData)
    return cartArray
}

enum Category: String, Codable {
    case all = "All"
    case outdoor = "Outdoor"
    case tennis = "Tennis"
    case running = "Running"
}

struct Product: Codable, Equatable {
    let name: String
    let image: String
    var isFavorite: Bool
    let category: Category
    let price: Double
    let description: String
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}

struct Products: Codable {
    var outdoor: [Product] = [
        Product(name: "Nike Air Force 1", image: "product", isFavorite: false, category: .outdoor, price: 1000.00, description: "Cool"),
        Product(name: "Nike Air Force 2", image: "product", isFavorite: false, category: .outdoor, price: 1100.00, description: "Cool"),
        Product(name: "Nike Air Force 3", image: "product", isFavorite: false, category: .outdoor, price: 1200.00, description: "Cool"),
        Product(name: "Nike Air Force 4", image: "product", isFavorite: false, category: .outdoor, price: 1300.00, description: "Cool")
    ]
    
    var tennis: [Product] = [
        Product(name: "Asics Gel-Kayano 28", image: "product", isFavorite: false, category: .tennis, price: 1150.00, description: "Cool"),
        Product(name: "Asics TeknoFlyer", image: "product", isFavorite: false, category: .tennis, price: 1280.00, description: "Cool"),
        Product(name: "Nike Tech Fit", image: "product", isFavorite: false, category: .tennis, price: 1000.00, description: "Cool"),
        Product(name: "Tennis Snickers", image: "product", isFavorite: false, category: .tennis, price: 1300.00, description: "Cool")
    ]
    
    var running: [Product] = [
        Product(name: "Nike Air", image: "product", isFavorite: false, category: .running, price: 1050.00, description: "Cool"),
        Product(name: "Adidas Ultraboost", image: "product", isFavorite: false, category: .running, price: 1100.00, description: "Cool"),
        Product(name: "Puma Suede", image: "product", isFavorite: false, category: .running, price: 1150.00, description: "Cool"),
        Product(name: "Reebok Classic", image: "product", isFavorite: false, category: .running, price: 1200.00, description: "Cool")
    ]
}

var products = Products()

func uploadProducts() {
    if let encodedProducts = try? JSONEncoder().encode(products) {
        UserDefaults.standard.set(encodedProducts, forKey: "products")
    }
}

func downloadProducts() {
    guard let savedData = UserDefaults.standard.data(forKey: "products"),
          let decodedProducts = try? JSONDecoder().decode(Products.self, from: savedData) else {
        return
    }
    products = decodedProducts
}

