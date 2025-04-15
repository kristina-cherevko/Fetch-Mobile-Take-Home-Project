//
//  FetchHomeProjectTests.swift
//  FetchHomeProjectTests
//
//  Created by Kristina Cherevko on 4/14/25.
//

import XCTest
@testable import FetchHomeProject

final class RecipesServiceTests: XCTestCase {
    var service: RecipesService!
    
    override func setUp() {
       super.setUp()
       service = RecipesService()
   }

    func testFetchRecipes_successfullyParsesData() async throws {
        let response = try await service.fetchRecipes()
        XCTAssertFalse(response.recipes.isEmpty, "Expected recipes from live endpoint")
    }

    func testFetchRecipes_fromEmptyEndpoint() async throws {
        let endpoint = RecipesEndpoint.emptyRecipes
        let result = try await service.fetchRecipes(from: endpoint)
        XCTAssertTrue(result.recipes.isEmpty, "Expected empty recipe list")
    }
    
    func testFetchRecipes_fromMalformedEndpoint() async throws {
        let endpoint = RecipesEndpoint.malformedRecipes
        do {
            
            let _ = try await service.fetchRecipes(from: endpoint)
        } catch {
            if case NetworkError.malformedData = error {
                // Success
            } else {
                XCTFail("Expected NetworkError.malformedData error, got \(error)")
            }
        }
       
    }

}
