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
    let instructions: String?
    let ingredients: [String]?
    let measures: [String]?
    let ingredientsWithMeasures: [(ingredient: String, measure: String)]?

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case meal = "strMeal"
        case mealThumb = "strMealThumb"
        case instructions = "strInstructions"
    }

    enum IngredientsKeys: String, CodingKey {
        // mapping for json data
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
             strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
    }

    enum MeasuresKeys: String, CodingKey {
        // mapping for json data
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
             strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        meal = try container.decode(String.self, forKey: .meal)
        mealThumb = try container.decode(String.self, forKey: .mealThumb)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)

        // creates a container for decoding values from the JSON data using the IngredientsKeys enum as the coding keys
        let ingredientsContainer = try decoder.container(keyedBy: IngredientsKeys.self)
        // creates a container for decoding values from the JSON data using the MeasuresKeys enum as the coding keys
        let measuresContainer = try decoder.container(keyedBy: MeasuresKeys.self)

        // stores values into array for ingredients and measures and filters out the empty strings and values
        ingredients = try ingredientsContainer.decodeIngredients()?.filter { !$0.isEmpty }
        measures = try measuresContainer.decodeMeasures()?.filter { $0 != " " }

        // maps and zips ingrediesnts and measurements in array of tuples
        if let ingredients = ingredients, let measures = measures {
            ingredientsWithMeasures = zip(ingredients, measures).map { ($0, $1) }
        } else {
            ingredientsWithMeasures = nil
        }
    }
}

extension KeyedDecodingContainer where K: CodingKey {
    // decodes ingredients and filters out empty strings
    func decodeIngredients() throws -> [String]? {
        let ingredientKeys = allKeys.filter { $0.stringValue.starts(with: "strIngredient") }
        let sortedIngredientKeys = ingredientKeys.sorted { $0.stringValue < $1.stringValue }
        let ingredients = sortedIngredientKeys.compactMap { try? decodeIfPresent(String.self, forKey: $0) }
        return ingredients.isEmpty ? nil : ingredients.filter { !$0.isEmpty }
    }

    // decodes measures and filters out empty strings
    func decodeMeasures() throws -> [String]? {
        let measureKeys = allKeys.filter { $0.stringValue.starts(with: "strMeasure") }
        let sortedMeasureKeys = measureKeys.sorted { $0.stringValue < $1.stringValue }
        let measures = sortedMeasureKeys.compactMap { try? decodeIfPresent(String.self, forKey: $0) }
        return measures.isEmpty ? nil : measures.filter { !$0.isEmpty }
    }
}

class Api {
    // fetches meal by category desert
    func getMeals(completion: @escaping ([Meal]) -> ()) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = data else {
                completion([])
                return
            }

            do {
                let response = try JSONDecoder().decode(Meals.self, from: data)
                let filteredMeals = response.meals.compactMap { $0 }.filter { !$0.meal.isEmpty }
                completion(filteredMeals)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        .resume()
    }

    // fetches meal by id
    func getMealById(id: String, completion: @escaping (Meal?) -> ()) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let response = try JSONDecoder().decode(Meals.self, from: data)
                if let mealData = response.meals.first {
                    let meal = mealData
                    completion(meal)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        .resume()
    }
}
