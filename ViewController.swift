//
//  ViewController.swift
//  ToDoList
//
//  Created by Ivan Chavdarov Ivanov on 16.01.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var itemManager = ItemManager()
    var motionManager = CoreMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        motionManager.delegate = self
        
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: ItemTableViewCell.identifier)
        
        title = "To Do List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        motionManager.startAccelerometerUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        motionManager.stopAccelerometerUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            if let destinationVC = segue.destination as? DetailsViewController,
               let object = sender as? Item {
                destinationVC.item = object
                destinationVC.itemManager = itemManager
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add new item",
                                      message: "Enter new to-do list item",
                                      preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Add new item here..."
            field.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Done",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let field = alert.textFields?.first,
               let text = field.text,
               !text.isEmpty {
                let item = Item(title: text, isCompleted: false)
                
                self?.itemManager.saveItem(item: item)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    func deleteCompletedItems() {
        let alert = UIAlertController(title: "Delete items",
                                      message: "Are you sure to delete completed items?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.itemManager.deleteCompletedItems()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemManager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell  else { return UITableViewCell() }
        
        cell.item = itemManager.items[indexPath.row]
        
        cell.itemCompletionHandler = { [weak self] completion in
            self?.itemManager.items[indexPath.row].isCompleted = completion
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Details", sender: itemManager.items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemManager.deleteItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController: CoreMotionManagerDelegate {
    func didDetectShake() {
        deleteCompletedItems()
    }
}
