/// Модель отзыва.
struct Review: Decodable {
    /// Имя пользователя
    let firstName: String
    /// Фамилия пользователя
    let lastName: String
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case text
        case created
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
