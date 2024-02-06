//
//  DetailsViewController.swift
//  ToDoList
//
//  Created by Ivan Chavdarov Ivanov on 16.01.24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var item: Item!
    var itemManager: ItemManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        title = item.title
    }
    
    @IBAction func addDetailsButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add details about this item",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Details here..."
            field.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Add",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let field = alert.textFields?.first,
               let text = field.text,
               !text.isEmpty {
                if self?.item.details != nil {
                    self?.item.details?.append(text)
                } else {
                    self?.item.details = [text]
                }
                
                guard let item = self?.item else { return }
                
                self?.itemManager.updateItem(item: item)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }))
        
        present(alert, animated: true)
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item.details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        var contentConfig = UIListContentConfiguration.cell()
        contentConfig.text = item.details?[indexPath.row]
        
        cell.contentConfiguration = contentConfig
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            item.details?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            itemManager.updateItem(item: item)
        }
    }
}
