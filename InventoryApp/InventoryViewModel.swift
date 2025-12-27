import SwiftUI

class InventoryViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var shoppingList: [Ingredient] = []
    
    private let ingredientsKey = "ingredients"
    private let shoppingListKey = "shoppingList"
    
    init() {
        loadIngredients()
        loadShoppingList()
        NotificationManager.shared.requestNotificationPermission()
    }
    
    // MARK: - Ingredient Management
    func addIngredient(_ ingredient: Ingredient) {
        ingredients.append(ingredient)
        saveIngredients()
    }
    
    func updateIngredient(_ ingredient: Ingredient) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index] = ingredient
            checkLowStock()
            saveIngredients()
        }
    }
    
    func deleteIngredient(_ id: UUID) {
        ingredients.removeAll { $0.id == id }
        shoppingList.removeAll { $0.id == id }
        saveIngredients()
        saveShoppingList()
    }
    
    // MARK: - Shopping List Management
    func checkLowStock() {
        for (index, ingredient) in ingredients.enumerated() {
            if ingredient.isLowStock && !ingredient.addedToShoppingList {
                ingredients[index].addedToShoppingList = true
                addToShoppingList(ingredient)
            }
        }
    }
    
    func addToShoppingList(_ ingredient: Ingredient) {
        if !shoppingList.contains(where: { $0.id == ingredient.id }) {
            shoppingList.append(ingredient)
            saveShoppingList()
            
            let itemCount = shoppingList.count
            let message = "\(itemCount) item\(itemCount == 1 ? "" : "s") on shopping list"
            NotificationManager.shared.sendNotification(
                title: "Added to Shopping List",
                body: "\"\(ingredient.name)\" added to shopping list. \(message)"
            )
        }
    }
    
    func removeFromShoppingList(_ id: UUID) {
        shoppingList.removeAll { $0.id == id }
        if let index = ingredients.firstIndex(where: { $0.id == id }) {
            ingredients[index].addedToShoppingList = false
        }
        saveShoppingList()
        saveIngredients()
    }
    
    func clearShoppingList() {
        for id in shoppingList.map({ $0.id }) {
            removeFromShoppingList(id)
        }
    }
    
    // MARK: - Persistence
    private func saveIngredients() {
        if let encoded = try? JSONEncoder().encode(ingredients) {
            UserDefaults.standard.set(encoded, forKey: ingredientsKey)
        }
    }
    
    private func loadIngredients() {
        if let data = UserDefaults.standard.data(forKey: ingredientsKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            ingredients = decoded
        }
    }
    
    private func saveShoppingList() {
        if let encoded = try? JSONEncoder().encode(shoppingList) {
            UserDefaults.standard.set(encoded, forKey: shoppingListKey)
        }
    }
    
    private func loadShoppingList() {
        if let data = UserDefaults.standard.data(forKey: shoppingListKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            shoppingList = decoded
        }
    }
}
