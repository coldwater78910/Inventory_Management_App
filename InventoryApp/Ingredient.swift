import Foundation

struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: Double
    var unit: String
    var lowStockThreshold: Double
    var addedToShoppingList: Bool = false
    
    var isLowStock: Bool {
        quantity <= lowStockThreshold
    }
}
