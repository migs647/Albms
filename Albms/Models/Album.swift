//
//  Album.swift
//  Albms
//
//  Created by Cody Garvin on 5/7/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import CoreData

public extension CodingUserInfoKey {
    // An easy way to grab the current context since we can not pass it in. hacky.
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

struct Feed: Codable {
    let feed: FeedData
}

struct FeedData: Codable {
    let title: String
    let id: String
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results: [Album]
}

struct Genre: Codable {
    let genreId: String
    let name: String
    let url: String
}

class Album: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case artistName
        case id
        case releaseDate
        case name
        case kind
        case copyright
        case artistId
        case contentAdvisoryRating
        case artistUrl = "artistUrl"
        case artistThumbUrl = "artworkUrl100"
        case genre = "genres"
        case url
    }
    
    @NSManaged var artistName: String?
    @NSManaged var id: String?
    @NSManaged var releaseDate: String?
    @NSManaged var name: String?
    @NSManaged var kind: String?
    @NSManaged var copyright: String?
    @NSManaged var artistId: String?
    @NSManaged var contentAdvisoryRating: String?
    @NSManaged var artistUrl: String?
    @NSManaged var artistThumbUrl: String?
    @NSManaged var genre: String?
    @NSManaged var url: String?
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Album", in: managedObjectContext) else {
                fatalError("Failed to decode Album")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        kind = try container.decodeIfPresent(String.self, forKey: .kind)
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        artistId = try container.decodeIfPresent(String.self, forKey: .artistId)
        contentAdvisoryRating = try container.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        artistUrl = try container.decodeIfPresent(String.self, forKey: .artistUrl)
        artistThumbUrl = try container.decodeIfPresent(String.self, forKey: .artistThumbUrl)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        if let tempGenres = try container.decodeIfPresent([Genre].self, forKey: .genre) {
            genre = tempGenres.first?.name
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(id, forKey: .id)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(name, forKey: .name)
        try container.encode(kind, forKey: .kind)
        try container.encode(copyright, forKey: .copyright)
        try container.encode(artistId, forKey: .artistId)
        try container.encode(contentAdvisoryRating, forKey: .contentAdvisoryRating)
        try container.encode(artistUrl, forKey: .artistUrl)
        try container.encode(artistThumbUrl, forKey: .artistThumbUrl)
        try container.encode(url, forKey: .url)
    }
}
