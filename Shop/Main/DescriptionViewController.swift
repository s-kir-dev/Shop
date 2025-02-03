//
//  DescriptionViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    
    var product: Product = products.outdoor[0]
    
    var favoriteButtonAction: (() -> Void)?
    var cartButtonAction: (() -> Void)?
    
    @IBAction func addToFavoriteTapped(_ sender: Any) {
        favoriteButtonAction?()
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        cartButtonAction?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadProducts()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.title = product.name
        productName.text = product.name
        productImage.image = UIImage(named: product.image)
        productPrice.text = "\(product.price)₽"
        productCategory.text = product.category.rawValue
        //productDescription.text = product.description
        print("\(product.isFavorite)")
        
        if product.isFavorite {
            addToFavoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
            favoriteButtonAction = {
                self.product.isFavorite = false
                
                switch self.product.category {
                case .outdoor:
                    guard let index = products.outdoor.firstIndex(of: self.product) else { return }
                    products.outdoor[index].isFavorite = false
                case .running:
                    guard let index = products.running.firstIndex(of: self.product) else { return }
                    products.running[index].isFavorite = false
                default:
                    guard let index = products.tennis.firstIndex(of: self.product) else { return }
                    products.tennis[index].isFavorite = false
                }
                
                if let index = favorites.firstIndex(of: self.product) {
                    favorites.remove(at: index)
                    uploadFavorites()
                }
                uploadProducts()
                self.addToFavoriteButton.setImage(UIImage(named: "heart button"), for: .normal)
            }
        } else {
            addToFavoriteButton.setImage(UIImage(named: "heart button"), for: .normal)
            favoriteButtonAction = {
                self.product.isFavorite = true
                
                switch self.product.category {
                case .outdoor:
                    guard let index = products.outdoor.firstIndex(of: self.product) else { return }
                    products.outdoor[index].isFavorite = true
                case .running:
                    guard let index = products.running.firstIndex(of: self.product) else { return }
                    products.running[index].isFavorite = true
                default:
                    guard let index = products.tennis.firstIndex(of: self.product) else { return }
                    products.tennis[index].isFavorite = true
                }
                
                addToFavorite(self.product)
                uploadProducts()
                self.addToFavoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
                uploadFavorites()
            }
        }
        
    }

}
