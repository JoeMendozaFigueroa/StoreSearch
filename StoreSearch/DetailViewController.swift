//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 10/1/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceButton: UIButton!
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    var dismissStyle = AnimationStyle.fade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 25 // This makes the edges of the pop-up view rounded with a radius of 10 Degrees
        
        //This constant is for when a user touches outside of the Pop-Up View, it exits out of it
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        if searchResult != nil {
            updateUI()
        }
        
        //This reveals the GRADIENT VIEW
        view.backgroundColor = UIColor.clear
        let dimmingView = GradientView(frame: CGRect.zero)
        dimmingView.frame = view.bounds
        view.insertSubview(dimmingView, at: 0)

    }
    
    // MARK: - ACTIONS
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: - HELPER METHODS
    //This method is for the naming of the "Name Label" from the URL search
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknonw"
        } else {
            artistNameLabel.text = searchResult.artist
        }
        
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        //This syntax SHOWs PRICE of the item that was selected from the sarch cell
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        
        //GET IMAGE
        //*/ The "imageLarge/small" syntax is for which image quality, "big/small", you display.
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }
    
    //This is called whenever the object instance is deallocated and its memory is reclaimed
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    //This init method is called when the animation is needed
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }

}
//This extension is of the Gesture Class, for when a user touches the screen
extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
extension DetailViewController: UIViewControllerTransitioningDelegate {
    //This method activates the bounce animation Class
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    //This method overrides the bounce animation and initiates the slideOut animation
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return SlideOutAnimationController()
        }
    }
}
