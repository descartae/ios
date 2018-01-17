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

    // MARK: Properties

    @IBOutlet weak var sendFeedbackButton: UIBarButtonItem!

    var textView: UITextView?
    var facility: DisposalFacility!
    var isGeneralAppFeedback = false

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if isGeneralAppFeedback {
            navigationItem.title = "Solta o verbo"
        }
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
            let emptyFeedback = UIAlertController(title: "Oops!", message: "O campo de texto está vazio.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            emptyFeedback.addAction(okAction)

            present(emptyFeedback, animated: true, completion: nil)

            return
        }

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        let barButtonLoading = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButtonLoading

        if isGeneralAppFeedback {
            sendGeneralFeedback(feedbackText)
        } else {
            sendFacilityFeedback(feedbackText)
        }
    }

    func sendGeneralFeedback(_ feedbackText: String) {
        let feedbackMutation = AddFeedbackMutation(feedback: feedbackText)
        GraphQL.client.perform(mutation: feedbackMutation) { (result, error) in
            guard let success = result?.data?.addFeedback.success, error == nil && success else {
                let emptyFeedback = UIAlertController(title: "Oops!", message: "Não foi possível enviar seu feedback, tente novamente mais tarde.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tudo bem", style: .default, handler: nil)

                emptyFeedback.addAction(okAction)

                self.present(emptyFeedback, animated: true, completion: nil)

                return
            }

            self.textView?.text = ""
            self.navigationItem.rightBarButtonItem = self.sendFeedbackButton

            let successFeedback = UIAlertController(title: "Obrigado por nos contar!", message: "Ah, não esquece de nos avaliar na App Store <3", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })

            successFeedback.addAction(okAction)

            self.present(successFeedback, animated: true, completion: nil)
        }
    }

    func sendFacilityFeedback(_ feedbackText: String) {
        let feedbackMutation = AddFeedbackMutation(facilityId: facility.id, feedback: feedbackText)
        GraphQL.client.perform(mutation: feedbackMutation) { (result, error) in
            guard let success = result?.data?.addFeedback.success, error == nil && success else {
                let emptyFeedback = UIAlertController(title: "Oops!", message: "Não foi possível enviar seu feedback, tente novamente mais tarde.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tudo bem", style: .default, handler: nil)

                emptyFeedback.addAction(okAction)

                self.present(emptyFeedback, animated: true, completion: nil)

                return
            }

            self.textView?.text = ""
            self.navigationItem.rightBarButtonItem = self.sendFeedbackButton

            let successFeedback = UIAlertController(title: "Obrigado por nos ajudar a melhorar!", message: "Nossos voluntários irão analisar e endereçar sua reclamação.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
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

        if isGeneralAppFeedback {
            let disclaimer = cell.viewWithTag(200) as? UILabel
            disclaimer?.text = "O que está achando do Descartaê?\nNos conta aí!"
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
