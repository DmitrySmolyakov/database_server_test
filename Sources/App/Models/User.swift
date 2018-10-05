import Vapor
import FluentMySQL

final class User: Content {
    static let entity = "clients01"
    
    var username: String?
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

extension User: Model {
    typealias Database = MySQLDatabase
    
    static var idKey: WritableKeyPath<User, String?> {
        return \.username
    }
}

extension User: Migration {}
extension User: Parameter {}
