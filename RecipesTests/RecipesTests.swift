//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Haytham Odeh on 6/12/23.
//

@testable import Recipes
import XCTest

final class RecipesTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFetchDessertMeals() {
        // create endpoint and expectation
        let endpointURL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let expectation = XCTestExpectation(description: "Fetch dessert meals")

        // Act
        let task = URLSession.shared.dataTask(with: endpointURL) { data, _, error in
            // Assert
            // Check if there's no error
            XCTAssertNil(error)

            if let data = data {
                // Check data is not empty
                XCTAssertGreaterThan(data.count, 0)

                expectation.fulfill()
            } else {
                XCTFail("No data received")
            }
        }
        task.resume()

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchDessertMealById() {
        let id = "52893"
        let endpointURL = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!

        let expectation = XCTestExpectation(description: "Fetch dessert meal by id")

        let task = URLSession.shared.dataTask(with: endpointURL) { data, _, error in
            XCTAssertNil(error)

            if let data = data {
                do {
                    //deserializes the JSON data and then accesses the "meals" array
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let meals = json["meals"] as? [[String: Any]],
                       meals.count == 1
                    {
                        expectation.fulfill()
                    } else {
                        XCTFail("Invalid JSON response or meals count is not 1")
                    }
                } catch {
                    XCTFail("Error deserializing JSON: \(error)")
                }
            } else {
                XCTFail("No data received")
            }
        }

        task.resume()

        wait(for: [expectation], timeout: 5.0)
    }
}
