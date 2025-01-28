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
    
    var products: [Product] = []
    
    var selectedProduct = Products.outdoor[0]
    
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
        products.removeAll()
        collectionView.setContentOffset(.zero, animated: false)
        switch selectedType {
        case .all:
            products.append(contentsOf: Products.outdoor)
            products.append(contentsOf: Products.tennis)
            products.append(contentsOf: Products.running)
        case .outdoor:
            products = Products.outdoor
        case .tennis:
            products = Products.tennis
        case .running:
            products = Products.running
        }
        
        collectionView.reloadData()
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.row]
        
        cell.prouctImage.image = UIImage(named: product.image)
        cell.productName.text = product.name
        cell.productPrice.text = "\(product.price)₽"
        cell.productCategory.text = product.category.rawValue
        
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
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: "descriptionVC", sender: self)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 122, height: 150)
    }
}
