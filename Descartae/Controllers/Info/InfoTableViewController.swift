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

    @IBOutlet weak var wasteTypesLabel: UILabel! {
        didSet {
            wasteTypesLabel.text = localized("waste_types_label_title")
        }
    }

    @IBOutlet weak var aboutLabel: UILabel! {
        didSet {
            aboutLabel.text = localized("about_label_title")
        }
    }

    @IBOutlet weak var feedbackLabel: UILabel! {
        didSet {
            feedbackLabel.text = localized("feedback_label_title")
        }
    }

    @IBOutlet weak var rateOnAppStoreLabel: UILabel! {
        didSet {
            rateOnAppStoreLabel.text = localized("rate_label_title")
        }
    }

    @IBOutlet weak var facebookShareLabel: UILabel! {
        didSet {
            facebookShareLabel.text = localized("facebook_share_label_title")
        }
    }

    let aboutPage = "https://descartae.com/sobre"
    let shareURL = "https://descartae.com/"

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        }

        navigationItem.title = localized("info_title")
        navigationItem.backBarButtonItem?.title = localized("back")
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
            reportAnIssue.inputType = .generaFeedback
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
