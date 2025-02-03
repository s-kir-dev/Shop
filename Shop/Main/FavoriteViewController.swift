//
//  FavoriteViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 29.01.2025.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedProduct = products.outdoor[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = downloadFavorites()
        downloadProducts()
        collectionView.reloadData()
    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        var product = favorites[indexPath.row]
        
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
                uploadProducts()
                uploadFavorites()
                collectionView.reloadData()
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
                uploadProducts()
                cell.favoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
                uploadFavorites()
                collectionView.reloadData()
            }
        }
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsVC" {
            let destinationVC = segue.destination as! DescriptionViewController
            destinationVC.product = selectedProduct
        }
    }
}


extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = favorites[indexPath.row]
        performSegue(withIdentifier: "detailsVC", sender: self)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.05, height: 150)
    }
}

