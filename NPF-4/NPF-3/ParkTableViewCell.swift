//
//  ParkTableViewCell.swift
//  NPF-4
//
//  Created by Ellie on 4/20/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {

    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let park: Park = Park()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(subtitle)
        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        label.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20).isActive = true
        subtitle.leftAnchor.constraint(equalTo: cellView.leftAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
