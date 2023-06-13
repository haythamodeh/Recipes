//
//  ContentView.swift
//  Recipes
//
//  Created by Haytham Odeh on 6/12/23.
//

import SwiftUI

struct ContentView: View {
    @State var meals: [Meal] = []

    var body: some View {
        NavigationView {
            List(meals) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    Text(meal.meal)
                }
            }
            .navigationTitle("Deserts")
            .onAppear {
                Api().getMeals { meals in
                    self.meals = meals
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MealDetailView: View {
    @State var meal: Meal

    var body: some View {
        VStack{
            Text(meal.id)
        }
        .onAppear {
            Api().getMealById(id: meal.id) { updatedMeal in
                meal = updatedMeal
            }
        }

    }
}

