//
//  AllProductsViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit

class AllProductsViewController: UIViewController {

    @IBOutlet weak var filterAll: UIButton!
    @IBOutlet weak var filterOutdoor: UIButton!
    @IBOutlet weak var filterTennis: UIButton!
    @IBOutlet weak var filterRunning: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sortedProducts: [Product] = []
    
    var selectedProduct = products.outdoor[0]
    
    var selectedType: Category = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        filter()
        
        filterAll.addTarget(self, action: #selector(filterAllTapped), for: .touchUpInside)
        filterOutdoor.addTarget(self, action: #selector(filterOutdoorTapped), for: .touchUpInside)
        filterTennis.addTarget(self, action: #selector(filterTennisTapped), for: .touchUpInside)
        filterRunning.addTarget(self, action: #selector(filterRunningTapped), for: .touchUpInside)
        downloadProducts()
    }
    
    @objc func filterAllTapped() {
        selectedType = .all
        filter()
    }
    
    @objc func filterOutdoorTapped() {
        selectedType = .outdoor
        filter()
    }
    
    @objc func filterTennisTapped() {
        selectedType = .tennis
        filter()
    }
    
    @objc func filterRunningTapped() {
        selectedType = .running
        filter()
    }
    
    func filter() {
        sortedProducts.removeAll()
        collectionView.setContentOffset(.zero, animated: false)
        switch selectedType {
        case .all:
            sortedProducts.append(contentsOf: products.outdoor)
            sortedProducts.append(contentsOf: products.tennis)
            sortedProducts.append(contentsOf: products.running)
        case .outdoor:
            sortedProducts = products.outdoor
        case .tennis:
            sortedProducts = products.tennis
        case .running:
            sortedProducts = products.running
        }
        
        collectionView.reloadData()
    }

}

extension AllProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        var product = sortedProducts[indexPath.row]
        
        cell.prouctImage.image = UIImage(named: product.image)
        cell.productName.text = product.name
        cell.productPrice.text = "\(product.price)₽"
        cell.productCategory.text = product.category.rawValue
        
        print("\(product.name) = \(product.isFavorite)")
        
        if product.isFavorite {
            cell.favoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
            cell.favoriteButtonAction = {
                product.isFavorite = false
                
                switch product.category {
                case .outdoor:
                    guard let index = products.outdoor.firstIndex(of: product) else { return }
                    products.outdoor[index].isFavorite = false
                case .running:
                    guard let index = products.running.firstIndex(of: product) else { return }
                    products.running[index].isFavorite = false
                default:
                    guard let index = products.tennis.firstIndex(of: product) else { return }
                    products.tennis[index].isFavorite = false
                }
                
                if let index = favorites.firstIndex(of: product) {
                    favorites.remove(at: index)
                }
                cell.favoriteButton.setImage(UIImage(named: "heart button"), for: .normal)
                uploadFavorites()
                self.filter()
                uploadProducts()
            }
        } else {
            cell.favoriteButton.setImage(UIImage(named: "heart button"), for: .normal)
            cell.favoriteButtonAction = {
                product.isFavorite = true
                
                switch product.category {
                case .outdoor:
                    guard let index = products.outdoor.firstIndex(of: product) else { return }
                    products.outdoor[index].isFavorite = true
                case .running:
                    guard let index = products.running.firstIndex(of: product) else { return }
                    products.running[index].isFavorite = true
                default:
                    guard let index = products.tennis.firstIndex(of: product) else { return }
                    products.tennis[index].isFavorite = true
                }
                
                addToFavorite(product)
                cell.favoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
                uploadFavorites()
                self.filter()
                uploadProducts()
            }
        }
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destinationVC = segue.destination as! DescriptionViewController
            destinationVC.product = selectedProduct
        }
    }
}


extension AllProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = sortedProducts[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}

extension AllProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.05, height: 150)
    }
}
