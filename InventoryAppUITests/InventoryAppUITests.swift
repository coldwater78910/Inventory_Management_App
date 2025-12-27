import XCTest

final class InventoryAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let inventoryTabButton = app.tabBars.buttons["Inventory"]
        let shoppingListTabButton = app.tabBars.buttons["Shopping List"]
        
        XCTAssert(inventoryTabButton.exists)
        XCTAssert(shoppingListTabButton.exists)
    }
    
    func testAddIngredientButtonExists() throws {
        let app = XCUIApplication()
        app.launch()
        
        let addButton = app.buttons["plus.circle.fill"]
        XCTAssert(addButton.exists)
    }

}
