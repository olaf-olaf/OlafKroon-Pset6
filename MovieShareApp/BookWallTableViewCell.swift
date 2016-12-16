//
//  BookWallTableViewCell.swift
//  MovieShareApp
//
//  Created by Olaf Kroon on 07/12/16.
//  Copyright © 2016 Olaf Kroon. All rights reserved.
//
//  A class for each cell in the tableview. MGSwipeTableCell is a third party
//  library that enables easy addition of buttons to cells.

import UIKit
import MGSwipeTableCell

class BookWallTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var emailOfOwner: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
