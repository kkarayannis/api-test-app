import Foundation

struct Book: Codable {
    let subjects: [String]
    let title: String
    let covers: [Int]
    let subjectPeople: [String]?
    let subjectPlaces: [String]?
    let description: String?
    let subtitle: String?
    
    enum CodingKeys: String, CodingKey {
            case subjects
            case title
            case covers
            case subjectPeople
            case subjectPlaces
            case description
            case subtitle
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            
            subjects = try container.decode([String].self, forKey: .subjects)
            title = try container.decode(String.self, forKey: .title)
            covers = try container.decode([Int].self, forKey: .covers)
            subjectPeople = try container.decodeIfPresent([String].self, forKey: .subjectPeople)
            subjectPlaces = try container.decodeIfPresent([String].self, forKey: .subjectPlaces)
            subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
            
            // Description can be in 2 different formats
            if let description = try? container.decodeIfPresent(String.self, forKey: .description) {
                self.description = description
            } else {
                self.description = try? container.decodeIfPresent(Description.self, forKey: .description)?.value
            }
        }
    
    #if DEBUG
    init(subjects: [String], title: String, covers: [Int], subjectPeople: [String]?, subjectPlaces: [String]?, description: String?, subtitle: String?) {
        self.subjects = subjects
        self.title = title
        self.covers = covers
        self.subjectPeople = subjectPeople
        self.subjectPlaces = subjectPlaces
        self.description = description
        self.subtitle = subtitle
    }
    #endif
}

struct Description: Codable {
    let value: String
}
