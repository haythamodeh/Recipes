//
//  Meal.swift
//  Recipes
//
//  Created by Haytham Odeh on 6/12/23.
//

import Foundation

struct Meals: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Identifiable {
    let id: String
    let meal: String
    let mealThumb: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case meal = "strMeal"
        case mealThumb = "strMealThumb"
    }
}

class Api {
    func getMeals(completion: @escaping ([Meal]) -> ()) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            let meals = try! JSONDecoder().decode(Meals.self, from: data!)

            DispatchQueue.main.async {
                completion(meals.meals.sorted { $0.meal < $1.meal } )
            }
        }
        .resume()
    }
    
    func getMealById( id: String, completion: @escaping (Meal) -> ()) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            let meal = try! JSONDecoder().decode(Meals.self, from: data!)

            DispatchQueue.main.async {
                completion(meal.meals.first!)
            }
        }
        .resume()
    }
}
