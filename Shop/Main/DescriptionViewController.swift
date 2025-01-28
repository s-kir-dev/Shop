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
    
    
    var product: Product = Products.outdoor[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        titleLabel.title = product.name
        productName.text = product.name
        productImage.image = UIImage(named: product.image)
        productPrice.text = "\(product.price)₽"
        productCategory.text = product.category.rawValue
        //productDescription.text = product.description
    }

}
