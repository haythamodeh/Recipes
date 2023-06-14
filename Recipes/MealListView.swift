//
//  MealList.swift
//  Recipes
//
//  Created by Haytham Odeh on 6/13/23.
//

import SwiftUI

struct MealListView: View {
    @State var meals: [Meal] = []

    var body: some View {
        List(meals) { meal in
            NavigationLink(destination: MealDetailView(meal: meal)) {
                HStack {
                    AsyncImage(url: URL(string: meal.mealThumb)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(20)

                    Text(meal.meal)
                }
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

struct MealList_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
