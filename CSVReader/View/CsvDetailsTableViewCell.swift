//
//  CsvDetailsTableViewCell.swift
//  CSVReader
//
//  Created by Siya Dagwar on 31/03/22.
//

import UIKit

class CsvDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLable: UILabel!
    @IBOutlet weak var issueCountLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    
    var issueCellModel: Issue? {
        didSet {
            fullNameLable.text = issueCellModel?.fullName
            issueCountLable.text = "Issue Count: \(issueCellModel?.issueCount ?? "")"
            dateLable.text = issueCellModel?.dateOfBirth
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameLable.text = nil
        issueCountLable.text = nil
        dateLable.text = nil
    }

}
