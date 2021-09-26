//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 9/25/21.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    
    //This method is the structure and look for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        //This local constant changes the color of the cells, in the tableView, and changes it to the color of the SearchBar color in the Asset folder
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - HELPER METHODS
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknonw"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        }
    }

}
