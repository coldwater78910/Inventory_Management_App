import SwiftUI

@main
struct InventoryAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(InventoryViewModel())
        }
    }
}
