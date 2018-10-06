import Vapor
import FluentMySQL

final class User: Content {
    static let entity = "users"
    
    var id: UUID?
    var username: String
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    
    init(username: String, firstname: String, lastname: String, email: String, password: String) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.password = password
    }
}

extension User: MySQLUUIDModel {}
extension User: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
            builder.unique(on: \.email)
        }
    }
}
extension User: Parameter {}
