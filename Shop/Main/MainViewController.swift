//
//  MainViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 28.01.2025.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var filterAll: UIButton!
    @IBOutlet weak var filterOutdoor: UIButton!
    @IBOutlet weak var filterTennis: UIButton!
    @IBOutlet weak var filterRunning: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAll: UIButton!
    
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
        viewAll.addTarget(self, action: #selector(viewAllTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadProducts()
    }
    
    @IBAction func backToMain(segue: UIStoryboardSegue) {
        
    }
    
    @objc func viewAllTapped() {
        performSegue(withIdentifier: "allSnickers", sender: nil)
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
        downloadProducts()
        sortedProducts.removeAll()
//        collectionView.setContentOffset(.zero, animated: false)
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

extension MainViewController: UICollectionViewDataSource {
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
                
        if product.isFavorite {
            cell.favoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
            cell.favoriteButtonAction = {
                self.sortedProducts[indexPath.row].isFavorite = false
                
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
                    uploadFavorites()
                }
                uploadProducts()
                self.filter()
                cell.favoriteButton.setImage(UIImage(named: "heart button"), for: .normal)
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
                self.filter()
                cell.favoriteButton.setImage(UIImage(named: "heart button filled"), for: .normal)
                uploadFavorites()
            }
        }
        
        cell.cartButtonAction = {
            cart.append(product)
            uploadCart()
            let alert = UIAlertController(title: "Успешно", message: "Товар \(product.name) успешно добавлен в корзину!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "descriptionVC" {
            let destinationVC = segue.destination as! DescriptionViewController
            destinationVC.product = selectedProduct
        } else if segue.identifier == "allSnickers" {
            let destinationVC = segue.destination as! AllProductsViewController
            destinationVC.selectedType = selectedType
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = sortedProducts[indexPath.row]
        performSegue(withIdentifier: "descriptionVC", sender: self)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 122, height: 150)
    }
}
