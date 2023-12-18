//
//  DetailsCostumCellTableViewCell.swift
//  Palphone Analysis
//
//  Created by palphone ios on 12/18/23.
//

import UIKit

class DetailsCostumCellTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var accountId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
