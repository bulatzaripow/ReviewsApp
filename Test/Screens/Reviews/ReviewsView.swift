import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()
    let reviewCountLabel = UILabel()
    let refreshControl = UIRefreshControl()
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let spinnerHeaderView = UIView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSpinner()
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
    
    private func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        spinnerHeaderView.addSubview(spinner)
        spinnerHeaderView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 50)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: spinnerHeaderView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: spinnerHeaderView.centerYAnchor)
        ])
    }

    func showSpinnerHeader() {
        tableView.tableHeaderView = spinnerHeaderView
    }

    func hideSpinnerHeader() {
        tableView.tableHeaderView = nil
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
        tableView.refreshControl = refreshControl
    }
    
    func setupReviewCountLabel() {
        reviewCountLabel.font = .reviewCount
        reviewCountLabel.textColor = .secondaryLabel
        reviewCountLabel.textAlignment = .center
        addSubview(reviewCountLabel)
    }

}
