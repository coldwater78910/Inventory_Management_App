import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @State private var showAddIngredient = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Inventory Tab
            NavigationStack {
                List {
                    if viewModel.ingredients.isEmpty {
                        VStack(alignment: .center, spacing: 12) {
                            Image(systemName: "box.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No Ingredients")
                                .font(.headline)
                            Text("Add ingredients to track your inventory")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach($viewModel.ingredients) { $ingredient in
                            NavigationLink(destination: IngredientDetailView(ingredient: $ingredient)) {
                                IngredientRowView(ingredient: ingredient)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteIngredient(viewModel.ingredients[index].id)
                            }
                        }
                    }
                }
                .navigationTitle("Inventory")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showAddIngredient = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                        }
                    }
                }
            }
            .tabItem {
                Label("Inventory", systemImage: "list.bullet")
            }
            .tag(0)
            
            // Shopping List Tab
            NavigationStack {
                List {
                    if viewModel.shoppingList.isEmpty {
                        VStack(alignment: .center, spacing: 12) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("Shopping List Empty")
                                .font(.headline)
                            Text("Items will appear here when running low")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                    } else {
                        Section(header: Text("\(viewModel.shoppingList.count) item\(viewModel.shoppingList.count == 1 ? "" : "s")")) {
                            ForEach(viewModel.shoppingList) { ingredient in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(ingredient.name)
                                            .font(.headline)
                                        Text("\(String(format: "%.1f", ingredient.quantity)) \(ingredient.unit)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(action: { viewModel.removeFromShoppingList(ingredient.id) }) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        
                        Section {
                            Button(action: { viewModel.clearShoppingList() }) {
                                Text("Clear Shopping List")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Shopping List")
            }
            .tabItem {
                Label("Shopping List", systemImage: "cart")
            }
            .tag(1)
        }
        .sheet(isPresented: $showAddIngredient) {
            AddIngredientView(isPresented: $showAddIngredient)
                .environmentObject(viewModel)
        }
    }
}

struct IngredientRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(ingredient.name)
                        .font(.headline)
                    Text("\(String(format: "%.1f", ingredient.quantity)) / \(String(format: "%.1f", ingredient.lowStockThreshold)) \(ingredient.unit)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                if ingredient.isLowStock {
                    Label("Low", systemImage: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    
                    Rectangle()
                        .fill(ingredient.isLowStock ? Color.orange : Color.green)
                        .frame(width: geometry.size.width * CGFloat(ingredient.quantity / ingredient.lowStockThreshold))
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
}

struct IngredientDetailView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @Binding var ingredient: Ingredient
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Information")) {
                TextField("Name", text: $ingredient.name)
                TextField("Unit (e.g., cups, grams)", text: $ingredient.unit)
            }
            
            Section(header: Text("Quantity")) {
                HStack {
                    Text("Current: \(String(format: "%.1f", ingredient.quantity)) \(ingredient.unit)")
                    Spacer()
                    Stepper(value: $ingredient.quantity, step: 0.1) {
                        Text("")
                    }
                }
            }
            
            Section(header: Text("Low Stock Alert")) {
                HStack {
                    Text("Threshold: \(String(format: "%.1f", ingredient.lowStockThreshold)) \(ingredient.unit)")
                    Spacer()
                    Stepper(value: $ingredient.lowStockThreshold, step: 0.1) {
                        Text("")
                    }
                }
            }
        }
        .navigationTitle("Edit Ingredient")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: ingredient) { newValue in
            viewModel.updateIngredient(newValue)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(InventoryViewModel())
}
