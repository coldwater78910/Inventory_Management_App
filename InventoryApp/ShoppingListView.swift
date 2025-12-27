import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    
    var body: some View {
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
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(InventoryViewModel())
}
