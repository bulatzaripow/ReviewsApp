//
//  PhotoCell.swift
//  Test
//
//  Created by Bulat Zaripov on 29.06.2025.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    // MARK: - Private Properties

    private let imageView = UIImageView()
    private var currentURL: String?
    private var currentTask: URLSessionDataTask?
    

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func configure(with url: String) {
        currentURL = url
        imageView.image = nil
        
        currentTask?.cancel()

        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            guard let self = self, self.currentURL == url else { return }
            self.imageView.image = image
        }
    }

    // MARK: - Private Methods

    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }
}

