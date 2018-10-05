import Vapor
import FluentMySQL

struct UserContent: Content {
    var username: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var password: String?
}

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let users = router.grouped("users")
        
        users.post(User.self, use: create)
        users.get(use: index)
        users.get(User.parameter, use: show)
        users.patch(UserContent.self, at: User.parameter, use: update)
        users.delete(User.parameter, use: delete)
    }
    
    func index(_ request: Request)throws -> Future<[User]> {
        return User.query(on: request).all()
    }
    
    func show(_ request: Request)throws -> Future<User> {
        return try request.parameters.next(User.self)
    }
    
    func create(_ request: Request, _ user: User)throws -> Future<User> {
        return user.create(on: request)
    }
    
    func update(_ request: Request, _ body: UserContent)throws -> Future<User> {
        let user = try request.parameters.next(User.self)
        return user.map(to: User.self, { user in
            user.username = body.username ?? user.username
            user.firstname = body.firstname ?? user.firstname
            user.lastname = body.lastname ?? user.lastname
            user.email = body.email ?? user.email
            user.password = body.password ?? user.password
            return user
        }).update(on: request)
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: .noContent)
    }
}