//
//  CommentsViewController.swift
 import UIKit
import DZNEmptyDataSet


class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var commentTextField:UITextField!
    var delegate: WriteCommentDelegate?
    
    var newsModel: NewsModel? {
        didSet{
            self.getComments()
        }
    }
    var comments: [CommentsModel] = []
    var comment = Comment.sendNormal
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeAppearance()
        self.prepareTableview()
    }
    
    func registerCells() {
        self.tableView.register(UINib(nibName: CommentsCell.identifier, bundle: nil), forCellReuseIdentifier: CommentsCell.identifier)
    }
    
    func customizeAppearance() {
        commentTextField.delegate = self
    }
    
    func prepareTableview() {
        self.registerCells()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    func getComments() {
        APIManager.sharedInstance.getComments(newsId: newsModel?.id ?? 0, success: { (result) in
            self.comments = result
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.reloadData()
        }) {(error) in
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.reloadData()
        }
    }
    
    func postComment() {
        self.view.endEditing(true)
        if let comment = commentTextField.text, !comment.isEmpty {
            APIManager.sharedInstance.postComment(newsId: newsModel?.id ?? 0, commentText: commentTextField.text ?? "", success: { (result) in
                self.comments.append(result)
                self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: 0)], with: .top)
                self.tableView.scrollToRow(at: IndexPath(row: self.comments.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
                self.tableView.reloadEmptyDataSet()
                self.delegate?.didCommentSent()
            }) { (error) in
                
            }
        }
        self.commentTextField.text = ""
    }
    
    func putEditedComment() {
        self.view.endEditing(true)
        if self.comments.isEmpty{
            self.postComment()
            return
        }
        
        if self.selectedIndex > (self.comments.count - 1) {
            self.comment = .sendNormal
            self.postComment()
            return
        }
        
        let editedCommentId = self.comments[self.selectedIndex].id ?? 0
        let editedCommentParentId = self.comments[self.selectedIndex].parent_id ?? 0
        
        if let comment = commentTextField.text, !comment.isEmpty {
            APIManager.sharedInstance.putComment(id: editedCommentId, parent_id: editedCommentParentId, newsId: newsModel?.id ?? 0, commentText: commentTextField.text ?? "", success: { (result) in
                self.comment = .sendNormal
                self.getComments()
                self.tableView.reloadEmptyDataSet()
                self.delegate?.didCommentSent()
            }) { (error) in
                
            }
        }
        self.commentTextField.text = ""
    }
    
    func deleteComment(){
        self.view.endEditing(true)
        if self.comments.isEmpty{
            Utility().topViewController()?.dismiss(animated: false, completion: nil)
            return
        }
        let editedCommentId = self.comments[self.selectedIndex].id ?? 0
        APIManager.sharedInstance.deleteComment(id: editedCommentId, success: { (result) in
            self.getComments()
            self.tableView.reloadEmptyDataSet()
            self.delegate?.didCommentSent()
            
        }) { (error) in
            
        }
    }
    
    @IBAction func tappedOnCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOnSendButton() {
        switch self.comment {
        case .sendNormal:
            self.postComment()
        case .sendEdited:
            self.putEditedComment()
        }
    }
    func appendComment() {
    }
}


extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.identifier) as? CommentsCell {
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(self.onBtnEditComment(sender:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(self.onBtnDeleteComment(sender:)), for: .touchUpInside)
            cell.setData(commentModel: comments[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Edit Delete comments
extension CommentsViewController {
    @objc func onBtnEditComment(sender:UIButton){
        self.comment = .sendEdited
        let commentToEdit = self.comments[sender.tag].comment_text ?? ""
        self.commentTextField.text = commentToEdit
        self.selectedIndex = sender.tag
        self.commentTextField.becomeFirstResponder()
    }
    @objc func onBtnDeleteComment(sender:UIButton){
        self.commentTextField.text = ""
        self.view.endEditing(true)
        self.selectedIndex = sender.tag
        AlertViewController.showAlert(title: "Delete comment", description: "Are you sure you want to delete this comment?", rightButtonText: "Delete", leftButtonText: "Cancel", delegate: self)
        
    }
    
    private func updateComment(){
        
    }
}

extension CommentsViewController: AlertViewDelegates {
    func didTapOnRightButton() {
        self.deleteComment()
    }
    func didTapOnLeftButton() {}
}

extension CommentsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "Comments will show up here, so you can easily view them here later"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Comments found"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension CommentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch self.comment {
        case .sendNormal:
            self.postComment()
        case .sendEdited:
            self.putEditedComment()
        }
        return true
    }
}




