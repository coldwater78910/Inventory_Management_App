# Inventory Management App

A simple iOS application built with SwiftUI for tracking ingredient inventory and managing a shopping list with automatic notifications.

## Features

- **Ingredient Inventory Tracking**: Add and manage your ingredients with quantities and units
- **Low Stock Alerts**: Set thresholds for automatic alerts when ingredients are running low
- **Shopping List Management**: Automatically add items to your shopping list when they fall below the threshold
- **Push Notifications**: Receive notifications when items are added to your shopping list with current item count
- **Data Persistence**: All ingredients and shopping list data is automatically saved

## Requirements

- iOS 14.0+
- Xcode 15.4 or later
- Swift 5.0+

## Building and Running

1. Open `InventoryApp.xcodeproj` in Xcode
2. Select your target device or simulator (iPhone 15 or later recommended)
3. Press `Cmd+R` to build and run the app
4. Grant notification permissions when prompted

## Usage

### Adding an Ingredient

1. Tap the **Inventory** tab
2. Tap the **+** button in the top right
3. Enter the ingredient name, unit, current quantity, and low stock threshold
4. Tap **Add**

### Monitoring Inventory

- The inventory list shows all ingredients with a progress bar indicating current quantity vs. threshold
- Items marked with an orange warning icon are running low
- Tap any ingredient to edit its details

### Shopping List

- Items automatically appear on the **Shopping List** tab when they fall below the threshold
- You'll receive a notification showing how many items are now on the list
- Tap the checkmark to remove items from the shopping list
- Use **Clear Shopping List** to remove all items at once

## Project Structure

- `InventoryAppApp.swift` - App entry point
- `ContentView.swift` - Main UI with tabs for inventory and shopping list
- `AddIngredientView.swift` - Form for adding new ingredients
- `ShoppingListView.swift` - Shopping list display
- `Ingredient.swift` - Data model for ingredients
- `InventoryViewModel.swift` - Business logic and data persistence
- `NotificationManager.swift` - Handles local push notifications

## Data Storage

All data is stored locally on device using `UserDefaults`. No cloud synchronization or server connection is required.
