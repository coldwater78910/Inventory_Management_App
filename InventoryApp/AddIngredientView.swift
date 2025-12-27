import SwiftUI

struct AddIngredientView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var quantity = 1.0
    @State private var unit = "cups"
    @State private var lowStockThreshold = 0.5
    
    let commonUnits = ["cups", "grams", "ml", "oz", "lbs", "tbsp", "tsp", "count"]
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && quantity > 0 && lowStockThreshold > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ingredient Details")) {
                    TextField("Name (e.g., Flour, Milk)", text: $name)
                }
                
                Section(header: Text("Unit")) {
                    Picker("Unit", selection: $unit) {
                        ForEach(commonUnits, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Quantity")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current Amount:")
                            Spacer()
                            Text(String(format: "%.1f", quantity))
                                .fontWeight(.semibold)
                        }
                        Slider(value: $quantity, in: 0.1...100, step: 0.1)
                    }
                }
                
                Section(header: Text("Low Stock Threshold")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Alert When Below:")
                            Spacer()
                            Text(String(format: "%.1f", lowStockThreshold))
                                .fontWeight(.semibold)
                        }
                        Slider(value: $lowStockThreshold, in: 0.1...100, step: 0.1)
                    }
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        let newIngredient = Ingredient(
                            name: name.trimmingCharacters(in: .whitespaces),
                            quantity: quantity,
                            unit: unit,
                            lowStockThreshold: lowStockThreshold
                        )
                        viewModel.addIngredient(newIngredient)
                        viewModel.checkLowStock()
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    AddIngredientView(isPresented: .constant(true))
        .environmentObject(InventoryViewModel())
}
