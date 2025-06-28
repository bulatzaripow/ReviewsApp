import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()
    let reviewCountLabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = safeAreaInsets
        let reviewCountLabelHeight: CGFloat = 44.0
        let tableViewHeight = bounds.height - reviewCountLabelHeight - inset.top - inset.bottom

        tableView.frame = CGRect(
            x: inset.left,
            y: inset.top,
            width: bounds.width - inset.left - inset.right,
            height: tableViewHeight
        )

        reviewCountLabel.frame = CGRect(
            x: 0,
            y: inset.top + tableViewHeight,
            width: bounds.width,
            height: reviewCountLabelHeight
        )
    }
    
    func configure(count: Int) {
        let word = Pluralizer.pluralize(count, one: "отзыв", few: "отзыва", many: "отзывов")
        reviewCountLabel.text = "\(count) \(word)"
    }

}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
        setupReviewCountLabel()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
    }
    
    func setupReviewCountLabel() {
        reviewCountLabel.font = .reviewCount
        reviewCountLabel.textColor = .secondaryLabel
        reviewCountLabel.textAlignment = .center
        addSubview(reviewCountLabel)
    }

}
