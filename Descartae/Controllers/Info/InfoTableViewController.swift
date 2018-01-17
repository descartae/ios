//
//  InfoTableViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 16/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices
import FBSDKCoreKit
import FBSDKShareKit

class InfoTableViewController: UITableViewController {

    // MARK: Properties

    let aboutPage = "https://descartae.com/sobre"
    let shareURL = "https://descartae.com/"

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let indexPathOfSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathOfSelectedRow, animated: true)
        }
    }

    // MARK: Actions

    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func goToAboutPage() {
        guard let url = URL(string: aboutPage) else {
            return
        }

        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .popover
        safari.preferredControlTintColor = tableView.tintColor

        present(safari, animated: true, completion: nil)
    }

    func showReviewController() {
        SKStoreReviewController.requestReview()
    }

    func shareToFacebook() {
        guard let url = URL(string: shareURL) else {
            return
        }

        let content = FBSDKShareLinkContent()
        content.contentURL = url

        FBSDKShareDialog.show(from: self, with: content, delegate: self)
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reportAnIssueNav = segue.destination as? ReportAnIssueNavigationController,
                let reportAnIssue = reportAnIssueNav.childViewControllers[0] as? ReportAnIssueTableViewController {
            reportAnIssue.isGeneralAppFeedback = true
        }
    }

}

extension InfoTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            goToAboutPage()
        case 3:
            tableView.deselectRow(at: indexPath, animated: true)
            showReviewController()
        case 4:
            tableView.deselectRow(at: indexPath, animated: true)
            shareToFacebook()
        default:
            break
        }
    }

}

extension InfoTableViewController: FBSDKSharingDelegate {

    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        // Nothing for now
    }

    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        // Nothing for now
    }

    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        // Nothing for now
    }

}
