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
    
    var downloadTask: URLSessionDownloadTask?
    
    //*/This method is the structure and look for the cell which holds the information about the items from the iTunes store*/
    override func awakeFromNib() {
        super.awakeFromNib()
        //*/This local constant changes the color of the cells, in the tableView, and changes it to the color of the SearchBar color in the Asset folder*/
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }

    //*/This method is for the selection of the cell*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //*/This method cancels any image that is still downloading*/
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        //print("This Works!!")
    }
    
    //MARK: - HELPER METHODS
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Localized kind: Unknown")
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        }
        //*/This loads an image into the "artworkImageView" object*/
        artworkImageView.image = UIImage(systemName: "square")
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }

}
