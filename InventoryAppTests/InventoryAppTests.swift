import XCTest
@testable import InventoryApp

final class InventoryAppTests: XCTestCase {
    
    var viewModel: InventoryViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = InventoryViewModel()
        viewModel.ingredients = []
        viewModel.shoppingList = []
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddIngredient() {
        let ingredient = Ingredient(name: "Flour", quantity: 5, unit: "cups", lowStockThreshold: 1)
        viewModel.addIngredient(ingredient)
        
        XCTAssertEqual(viewModel.ingredients.count, 1)
        XCTAssertEqual(viewModel.ingredients[0].name, "Flour")
    }
    
    func testDeleteIngredient() {
        let ingredient = Ingredient(name: "Sugar", quantity: 2, unit: "cups", lowStockThreshold: 0.5)
        viewModel.addIngredient(ingredient)
        XCTAssertEqual(viewModel.ingredients.count, 1)
        
        viewModel.deleteIngredient(ingredient.id)
        XCTAssertEqual(viewModel.ingredients.count, 0)
    }
    
    func testLowStockDetection() {
        let ingredient = Ingredient(name: "Milk", quantity: 0.3, unit: "cups", lowStockThreshold: 1.0)
        XCTAssertTrue(ingredient.isLowStock)
        
        let fullIngredient = Ingredient(name: "Milk", quantity: 2.0, unit: "cups", lowStockThreshold: 1.0)
        XCTAssertFalse(fullIngredient.isLowStock)
    }
    
    func testAddToShoppingList() {
        let ingredient = Ingredient(name: "Eggs", quantity: 1, unit: "dozen", lowStockThreshold: 0.5)
        viewModel.addToShoppingList(ingredient)
        
        XCTAssertEqual(viewModel.shoppingList.count, 1)
        XCTAssertEqual(viewModel.shoppingList[0].name, "Eggs")
    }
    
    func testRemoveFromShoppingList() {
        let ingredient = Ingredient(name: "Butter", quantity: 0.2, unit: "lbs", lowStockThreshold: 0.5)
        viewModel.addToShoppingList(ingredient)
        XCTAssertEqual(viewModel.shoppingList.count, 1)
        
        viewModel.removeFromShoppingList(ingredient.id)
        XCTAssertEqual(viewModel.shoppingList.count, 0)
    }
}
