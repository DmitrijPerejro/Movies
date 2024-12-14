//
//  NewReviewViewController.swift
//  Movies
//
//  Created by Perejro on 13/12/2024.
//

import UIKit

final class NewCommentViewController: UIViewController {
    enum SubmitButtonState {
        case submit, submitting
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var submitCommentButton: UIButton!
    
    // MARK: - data
    var movie: Movie!
    weak var delegate: NewCommentViewControllerDelgate?
    
    var formIsInvalid: Bool {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let review = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        return [name, email, review].contains(where: { $0.isEmpty })
    }
    
    // MARK: - services
    private let commentsService = CommentService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        commentTextField.delegate = self
    }
    
    @IBAction func submitReviewAction() {
        if formIsInvalid {
            showValidationAlert()
            return
        }
        
        changeSubmitButtonState(.submitting)
        
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let review = commentTextField.text ?? ""
        let comment = CommentRequest(author: name, email: email, body: review)
        
        submitReview(comment)
        dismiss(animated: true)
        
    }
    
    @IBAction func cancelReviewAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func submitReview(_ comment: CommentRequest) {
        commentsService.add(
            comment,
            to: URL(string: "\(CommentService.baseURL)?postId=\(movie.id)")!,
            completion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let comment):
                    changeSubmitButtonState(.submit)
                    delegate?.onSubmit(comment: comment)
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
    
    private func changeSubmitButtonState(_ state: SubmitButtonState) {
        switch state {
        case .submit:
            submitCommentButton.setTitle("Submit", for: .normal)
        case .submitting:
            submitCommentButton.setTitle("Submitting...", for: .normal)
        }
    }
    
    private func showValidationAlert() {
        let alert = UIAlertController(title: "Validation Error", message: "Please fill all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(alert, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate, UITextViewDelegate
extension NewCommentViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            commentTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
