public struct Category: Codable {
    public var id: Int?
    public var guid: String?
    public var dataVersion: String?
    public var name: String?
    public var short: String?
}

extension Category: Equatable {
    public static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.guid == rhs.guid &&
        lhs.dataVersion == rhs.dataVersion
    }
}