//
//  ItemTableViewCell.swift
//  ToDoList
//
//  Created by Ivan Chavdarov Ivanov on 16.01.24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    static var identifier: String = "CustomCell"
    var itemCompletionHandler: ((_ completion: Bool) -> Void)?
    var item: Item? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkMarkImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizser = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        checkMarkImageView.addGestureRecognizer(tapGestureRecognizser)
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction private func imageTapped(_ sender: UITapGestureRecognizer) {
        item?.isCompleted.toggle()
        itemCompletionHandler?(item?.isCompleted ?? false)
    }
    
    func configureCell() {
        guard let item = item else { return }
        
        taskLabel.text = item.title
        checkMarkImageView.image = item.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
    }
}
