//
//  Entrainement_re_seau_et_APITests.swift
//  Entrainement réseau et APITests
//
//  Created by Fabien Dietrich on 14/05/2020.
//  Copyright © 2020 Fabien Dietrich. All rights reserved.
//

import XCTest
@testable import Entrainement_re_seau_et_API

class Entrainement_re_seau_et_APITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testDownloadWebData() {

        // On crée l'expectation en lui donnant une simple description.
        let expectation = XCTestExpectation(description: "Télécharge le site openclassrooms.com")

        // On prépare une requête
        let url = URL(string: "https://openclassrooms.com")!
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { (data, _, _) in

            // On vérifie qu'il y a bien des données qui ont été chargées, c'est ici que le test a lieu.
            XCTAssertNotNil(data)

            // On déclare que l'expectation est terminée, on peut clore le test.
            expectation.fulfill()
        }

        // On lance la requête.
        dataTask.resume()

        // On attend que l'expectation soit terminée, avec une durée maximum de 10 secondes.
        wait(for: [expectation], timeout: 10.0)
    }
}
