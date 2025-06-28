//
//  Pluralizer.swift
//  Test
//
//  Created by Bulat Zaripov on 28.06.2025.
//

import Foundation

enum Pluralizer {
    /// Возвращает правильную форму слова
    /// Параметры:
    /// count - число
    /// one - 1 (напр. "отзыв")
    /// few - 2-4 (напр. "отзыва")
    /// many - более 4 (напр. "отзывов")
    static func pluralize(_ count: Int, one: String, few: String, many: String) -> String {
        let mod100 = count % 100
        if mod100 >= 11 && mod100 <= 19 {
            return many
        }
        
        let mod10 = count % 10
        switch mod10 {
        case 1:
            return one
        case 2, 3, 4:
            return few
        default:
            return many
        }
    }
}
