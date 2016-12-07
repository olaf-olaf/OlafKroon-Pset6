//
//  BookWallTableViewCell.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 07/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//

import UIKit

class BookWallTableViewCell: UITableViewCell {

    @IBOutlet weak var emailOfOwner: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
