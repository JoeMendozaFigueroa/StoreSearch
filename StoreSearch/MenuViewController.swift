//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 10/3/21.
//

import UIKit

class MenuViewController: UITableViewController {

    weak var delegate: MenuViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TABLE VIEW DELEGATES
    //This method is for when a user selects the cell to send an email
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendEmail(self)
        }
    }

}
protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendEmail(_ controller: MenuViewController)
}
