//
//  ReportAnIssueTableViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 10/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class ReportAnIssueNavigationController: UINavigationController {

    // MARK: Properties

    static let identifier = String(describing: ReportAnIssueNavigationController.self)

}

class ReportAnIssueTableViewController: UITableViewController {

    // MARK: Nested types

    enum InputType {
        case facilityFeedback, generaFeedback, regionWaitlist

        var title: String {
            switch self {
            case .facilityFeedback:
                return localized("facility_issue_title")
            case .generaFeedback:
                return localized("general_feedback_title")
            case .regionWaitlist:
                return localized("region_waitlist_title")
            }
        }

        var subtitle: String {
            switch self {
            case .facilityFeedback:
                return localized("facility_issue_subtitle")
            case .generaFeedback:
                return localized("general_feedback_subtitle")
            case .regionWaitlist:
                return localized("region_waitlist_subtitle")
            }
        }
    }

    // MARK: Properties

    @IBOutlet weak var sendFeedbackButton: UIBarButtonItem! {
        didSet {
            sendFeedbackButton.title = localized("send")
        }
    }

    @IBOutlet weak var cancelButton: UIBarButtonItem! {
        didSet {
            cancelButton.title = localized("cancel")
        }
    }

    var textView: UITextView?
    var facility: DisposalFacility!
    var inputType = InputType.facilityFeedback

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = inputType.title
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68.0
    }

    // MARK: Actions

    @objc func animateFocus() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.textView?.becomeFirstResponder()
        })
    }

    @IBAction func sendFeedback(_ sender: UIBarButtonItem) {
        view.endEditing(true)

        guard let feedbackText = textView?.text, !feedbackText.isEmpty else {
            animateFocus()
            let emptyFeedback = UIAlertController(title: localized("whoops"), message: localized("empty_feedback_alert_message"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: nil)

            emptyFeedback.addAction(okAction)

            present(emptyFeedback, animated: true, completion: nil)

            return
        }

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        let barButtonLoading = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonLoading

        switch inputType {
        case .facilityFeedback:
            sendFacilityFeedback(feedbackText)
        case .generaFeedback:
            sendGeneralFeedback(feedbackText)
        case .regionWaitlist:
            addToWaitlist(feedbackText)
        }
    }

    func sendGeneralFeedback(_ feedbackText: String) {
        let feedbackMutation = AddFeedbackMutation(feedback: feedbackText)
        GraphQL.client.perform(mutation: feedbackMutation) { _, _ in
            self.textView?.text = ""
            self.navigationItem.rightBarButtonItem = self.sendFeedbackButton

            let successFeedback = UIAlertController(title: localized("feedback_compliment_title"), message: localized("feedback_compliment_message_alert"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })

            successFeedback.addAction(okAction)

            self.present(successFeedback, animated: true, completion: nil)
        }
    }

    func sendFacilityFeedback(_ feedbackText: String) {
        let feedbackMutation = AddFeedbackMutation(facilityId: facility.id, feedback: feedbackText)
        GraphQL.client.perform(mutation: feedbackMutation) { _, _ in
            self.textView?.text = ""
            self.navigationItem.rightBarButtonItem = self.sendFeedbackButton

            let successFeedback = UIAlertController(title: localized("facility_feedback_compliment_title"), message: localized("facility_feedback_compliment_message_alert"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })

            successFeedback.addAction(okAction)

            self.present(successFeedback, animated: true, completion: nil)
        }
    }

    func addToWaitlist(_ email: String) {
        let genericError = {
            let emptyFeedback = UIAlertController(title: localized("whoops"), message: localized("region_waitlist_error_message"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: nil)

            emptyFeedback.addAction(okAction)

            self.present(emptyFeedback, animated: true, completion: nil)
        }

        let locationManager = LocationManager.shared
        guard let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude else {
            genericError()
            return
        }

        let feedbackMutation = AddToWaitlistMutation(email: email, latitude: latitude, longitude: longitude)
        GraphQL.client.perform(mutation: feedbackMutation) { _, _ in
            self.textView?.text = ""
            self.navigationItem.rightBarButtonItem = self.sendFeedbackButton

            let successFeedback = UIAlertController(title: localized("region_waitlist_success_title"), message: localized("region_waitlist_success_title"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })

            successFeedback.addAction(okAction)

            self.present(successFeedback, animated: true, completion: nil)
        }
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
    }

}

// MARK: UITableViewDataSource

extension ReportAnIssueTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "feedbackCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
        textView = cell.viewWithTag(100) as? UITextView
        let disclaimer = cell.viewWithTag(200) as? UILabel
        disclaimer?.text = inputType.subtitle

        if inputType == .regionWaitlist {
            textView?.autocapitalizationType = .none
            textView?.textContentType = .emailAddress
            textView?.keyboardType = .emailAddress
        }

        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ReportAnIssueTableViewController.animateFocus), userInfo: nil, repeats: false)

        return cell
    }

}

// MARK: UITextViewDelegate

extension ReportAnIssueTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)

        if let textStartPosition: UITextPosition = textView.selectedTextRange?.start {
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: textStartPosition)

            if textView.text.count - cursorPosition < 170 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
            } else if cursorPosition > 200 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)
            } else {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }

}
