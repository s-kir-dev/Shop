//
//  CartViewController.swift
//  Shop
//
//  Created by Кирилл Сысоев on 29.01.2025.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var summaLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var summa = 0.00
    var deliveryPrice = 90.00
    var finalPrice = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTable.delegate = self
        cartTable.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartTable.reloadData()
        
        for product in cart {
            summa += product.price
        }
        finalPrice = summa + deliveryPrice
        
        updateLabels()
    }
    
    func updateLabels() {
        summaLabel.text = "\(summa)₽"
        finalPriceLabel.text = "\(finalPrice)₽"
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        cell.productImage.image = UIImage(named: cart[indexPath.row].image)
        cell.productName.text = cart[indexPath.row].name
        cell.productPrice.text = "\(cart[indexPath.row].price)₽"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let removedProduct = cart[indexPath.row]
            summa -= removedProduct.price
            finalPrice = summa + deliveryPrice

            cart.remove(at: indexPath.row)

            uploadCart()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateLabels()
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red.withAlphaComponent(0.5)
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
}
