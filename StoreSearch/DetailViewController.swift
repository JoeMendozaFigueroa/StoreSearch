//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 10/1/21.
//

import UIKit
import MessageUI //This is to import the MFMailComposeViewController framework to send an email

class DetailViewController: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var kindLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var priceButton: UIButton!
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var downloadTask: URLSessionDownloadTask?
    var dismissStyle = AnimationStyle.fade
    var isPopup = false
    
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    //This init method is for the transition
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPopup {
            popupView.layer.cornerRadius = 10 // This makes the edges of the pop-up view rounded with a radius of 10 Degrees

            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            
            //This reveals the GRADIENT VIEW
            view.backgroundColor = UIColor.clear
            let dimmingView = GradientView(frame: CGRect.zero)
            dimmingView.frame = view.bounds
            view.insertSubview(dimmingView, at: 0)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
            
            if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
                title = displayName
            }
            //POPOVER ACTION BUTTON
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPopover(_:)))
        }
        if searchResult != nil {
            updateUI()
        }
    }
    //This is called whenever the object instance is deallocated and its memory is reclaimed
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    // MARK: - ACTIONS
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    //This method takes you to the store once you select the price label
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //This method shows the menu icon and calls for the Popover View Controller
    @objc func showPopover(_ sender: UIBarButtonItem) {
        guard let popover = storyboard?.instantiateViewController(
                withIdentifier: "PopoverView") as? MenuViewController
        else {return}
        popover.modalPresentationStyle = .popover
        if let ppc = popover.popoverPresentationController {
            ppc.barButtonItem = sender
        }
        popover.delegate = self
        present(popover, animated: true, completion: nil)
    }
    
    //MARK: - HELPER METHODS
    //This method is for the naming of the "Name Label" from the URL search
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Localized kind: Unknown")
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
            priceText = NSLocalizedString("Free", comment: "Localized kind: Free")
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
        popupView.isHidden = false
    }
    
}
//This extension is of the Gesture Class, for when a user touches the screen
extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
extension DetailViewController: UIViewControllerTransitioningDelegate {
    //This method activates the bounce animation when view first appears
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    //This method overrides the bounce animation and initiates the slideOut animation when you exit the view
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return SlideOutAnimationController()
        }
    }
}
//This method dismisses the popover view controller and opens up for the useer to send an email (only in ipad mode)
extension DetailViewController: MenuViewControllerDelegate {
    func menuViewControllerSendEmail(_ : MenuViewController) {
        dismiss(animated: true) {
            if MFMailComposeViewController.canSendMail() {
                let controller = MFMailComposeViewController()
                controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
                controller.setToRecipients(["your@email-address-here.com"])
                self.present(controller, animated: true, completion: nil)
                controller.mailComposeDelegate = self
            }
        }
    }
}

//This method lets you know wether the email was sent or not
extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController (_ controller: MFMailComposeViewController,
                                didFinishWith result: MFMailComposeResult,
                                error: Error?) {
            dismiss(animated: true, completion: nil
            )
    }
}
