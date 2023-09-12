import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: PostTableViewCell)
}

protocol MoreButtonProtocol: AnyObject {
    func moreButtonTapped(in cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    // MARK: - Properties
    var isExpanded = false
    
    weak var delegate: PostTableViewCellDelegate?
    weak var moreButtonDelegate: MoreButtonProtocol?
    
    // MARK: - Public Methods
    func configure(with viewModel: PostListItem) {
        titleLabel.text = viewModel.title
        changeLabel.text = viewModel.previewText
        LikeLabel.text = "❤️" + " " + "\(viewModel.likesCount)"
        timeLabel.text = Date.dateString(fromTimestamp: viewModel.timeshamp)
        updateButtonState()
    }
    
    // MARK: - Private Methods
    private func updateButtonState() {
        let maxSize = CGSize(width: changeLabel.bounds.width, height: .greatestFiniteMagnitude)
        let textSize = changeLabel.text?.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: changeLabel.font!], context: nil)
        
        if let textSize = textSize, textSize.height > changeLabel.font.lineHeight * 2 {
            myButton.isHidden = false
        } else {
            myButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.didTapButton(in: self)
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        moreButtonDelegate?.moreButtonTapped(in: self)
    }
}

