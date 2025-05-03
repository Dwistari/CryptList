//
//  CoreDataManager.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData") // Name must match your .xcdatamodeld file
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Saving error: \(error)")
        }
    }
    
    func registerUser(name: String, email: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        
        // Check if email already exists
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@", email)
        
        if let users = try? context.fetch(request), !users.isEmpty {
            return false // Email already exists
        }
        
        let user = User(context: context)
        user.name = name
        user.email = email
        user.password = password
        
        CoreDataManager.shared.saveContext()
        return true
    }
    
    func loginUser(email: String, password: String) -> User? {
        let context = CoreDataManager.shared.context
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        if let users = try? context.fetch(request), let user = users.first {
            return user
        }
        return nil
    }
    
    func getCurrentUser() -> User? {
        guard let email = UserDefaults.standard.string(forKey: "loggedInUserEmail") else { return nil }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch current user:", error)
            return nil
        }
    }
    
    func fetchFavorites() -> [Coin] {
        if let user = getCurrentUser(){
            let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
            request.predicate = NSPredicate(format: "user == %@", user)
            do {
                let favorites = try context.fetch(request)
                
                let favoriteCoins: [Coin] = favorites.map { favorite in
                    Coin(id: favorite.id ?? "", symbol: "", name: favorite.name ?? "", image: favorite.image, currentPrice: favorite.price)
                }
                return favoriteCoins
            } catch {
                print("Failed to fetch favorites: \(error)")
                return []
            }
        }
        return []
    }
    
    func saveFavorite(isFavorite: Bool, coin: Coin?) {
        guard let favCoin = coin else{return}
        if isFavorite {
            do {
                let favorite = Favorite(context: context)
                favorite.id = favCoin.id
                favorite.name = favCoin.name
                favorite.image = favCoin.image
                favorite.price = favCoin.currentPrice
                favorite.user = getCurrentUser()
                try context.save()
                print("success to save favorite.")
            } catch {
                print("Failed to save favorite:", error)
            }
        } else {
            if let user = getCurrentUser(){
                let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@ AND user.email == %@", favCoin.id, user.email ?? "")
                do {
                    let results = try context.fetch(fetchRequest)
                    for object in results {
                        context.delete(object)
                    }
                    do {
                        try context.save()
                        print("Favorite removed successfully.")
                    } catch {
                        print("Failed to save context after removal:", error)
                    }
                } catch {
                    print("Failed to remove favorite:", error)
                }
            }
        }
    }
}
