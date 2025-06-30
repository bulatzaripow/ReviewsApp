import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    let ratingRenderer = RatingRenderer()
    
    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Полное имя пользователя
    let fullName: NSAttributedString
    /// Ссылка на аватар
    let avatarURL: String?
    /// Рейтинг
    let rating: Int
    /// Фотографии товара
    let photoURLs: [String]
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.nameLabel.attributedText = fullName
        
        cell.ratingImageView.image = ratingRenderer.ratingImage(rating)
        
        if cell.photoURLs != photoURLs {
            cell.photoURLs = photoURLs
            cell.photoCollectionView.reloadData()
        }
        
        if let avatarURL = avatarURL {
            ImageLoader.shared.loadImage(from: avatarURL) { [weak cell] image in
                cell?.avatarImageView.image = image ?? UIImage(named: "l5w5aIHioYc")
            }
        } else {
            cell.avatarImageView.image = UIImage(named: "l5w5aIHioYc")
        }
        
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let avatarImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let ratingImageView = UIImageView()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()
    fileprivate let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var photoURLs: [String] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        contentView.addSubview(photoCollectionView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        avatarImageView.frame = layout.avatarImageFrame
        nameLabel.frame = layout.nameLabelFrame
        ratingImageView.frame = layout.ratingImageViewFrame
        photoCollectionView.frame = layout.photoCollectionFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }
    
    @objc private func didTapShowMore() {
        guard let config else { return }
        config.onTapShowMore(config.id)
    }

}

// MARK: - UICollection

extension ReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: photoURLs[indexPath.item])
        return cell
    }
}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupAvatarImageView()
        setupNameLabel()
        setupRatingImageView()
        setupPhotoCollectionView()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setupAvatarImageView() {
        contentView.addSubview(avatarImageView)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = Layout.avatarCornerRadius
        avatarImageView.clipsToBounds = true
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
    }
    
    func setupRatingImageView() {
        contentView.addSubview(ratingImageView)
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }
    
    func setupPhotoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 66)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        photoCollectionView.collectionViewLayout = layout
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        contentView.addSubview(photoCollectionView)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы
    
    private(set) var avatarImageFrame = CGRect.zero
    private(set) var nameLabelFrame = CGRect.zero
    private(set) var ratingImageViewFrame = CGRect.zero
    private(set) var photoCollectionFrame: CGRect = .zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right
        
        let avatarSize = Self.avatarSize
        let avatarOrigin = CGPoint(x: insets.left, y: insets.top)
        avatarImageFrame = CGRect(origin: avatarOrigin, size: avatarSize)

        var maxY = insets.top
        var showShowMoreButton = false
        
        let textBlockX = insets.left + avatarSize.width + avatarToUsernameSpacing
        let textBlockWidth = width - avatarSize.width - avatarToUsernameSpacing
        
        if !config.fullName.isEmpty() {
            nameLabelFrame = CGRect(
                origin: CGPoint(x: textBlockX, y: maxY),
                size: config.fullName.boundingRect(width: textBlockWidth).size
            )
            maxY = nameLabelFrame.maxY + usernameToRatingSpacing
        }
        
        let ratingImage = RatingRenderer().ratingImage(config.rating)
        let ratingImageSize = ratingImage.size
        ratingImageViewFrame = CGRect(
            origin: CGPoint(x: textBlockX, y: maxY),
            size: ratingImageSize
        )
        maxY = ratingImageViewFrame.maxY + ratingToTextSpacing
        
        if !config.photoURLs.isEmpty {
            let size = CGSize(width: Self.photoSize.width + photosSpacing,
                              height: Self.photoSize.height)
            photoCollectionFrame = CGRect(
                origin: CGPoint(x: textBlockX, y: maxY),
                size: CGSize(width: textBlockWidth, height: Self.photoSize.height)
            )
            maxY += size.height + photosToTextSpacing
        }

        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: textBlockWidth).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: textBlockX, y: maxY),
                size: config.reviewText.boundingRect(width: textBlockWidth, height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: textBlockX, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        createdLabelFrame = CGRect(
            origin: CGPoint(x: textBlockX, y: maxY),
            size: config.created.boundingRect(width: textBlockWidth).size
        )

        return max(createdLabelFrame.maxY + insets.bottom, insets.top + avatarSize.height + insets.bottom)
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
