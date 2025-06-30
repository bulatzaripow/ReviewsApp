//
//  ImageLoader.swift
//  Test
//
//  Created by Bulat Zaripov on 29.06.2025.
//

import UIKit

final class ImageLoader {
    
    // MARK: - Singleton
    
    static let shared = ImageLoader()
    
    // MARK: - Private
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    // MARK: - Public

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self?.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
