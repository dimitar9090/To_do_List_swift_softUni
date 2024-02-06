//
//  ItemManager.swift
//  ToDoList
//
//  Created by Ivan Chavdarov Ivanov on 16.01.24.
//

import Foundation

class ItemManager {
    
    var items = [Item]()
    //    var items: [Item] = [Item(title: "Beer", isCompleted: false), Item(title: "Wine", isCompleted: true)]
    
    func saveItem(item: Item) {
        items.append(item)
    }
    
    func deleteItem(atIndex index: Int) {
        items.remove(at: index)
    }
    
    func deleteCompletedItems() {
        items.removeAll { item in
            item.isCompleted == true
        }
    }
    
    func updateItem(item: Item) {
        if let index = items.firstIndex(where: {$0.title == item.title}) {
            items[index] = item
        }
    }
}
