//
//  Entrainement_re_seau_et_APITests.swift
//  Entrainement réseau et APITests
//
//  Created by Fabien Dietrich on 14/05/2020.
//  Copyright © 2020 Fabien Dietrich. All rights reserved.
//

import XCTest
@testable import Entrainement_réseau_et_API

class QuoteServicetestCase : XCTestCase {
   func testGetQuoteShouldPostFailedCallbackIfError() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostFailedCallbackNoData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData.quoteCorrectData, response: FakeResponseData.responseKO, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData.quoteIncorrectData, response: FakeResponseData.responseOK, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: FakeResponseData.quoteCorrectData, response: FakeResponseData.responseOK, error: nil),
            imageSession: URLSessionFake(data: FakeResponseData.imageData, response: FakeResponseData.responseOK, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            let text =  "Accept the things to which fate binds you, and love the people with whom fate brings you together, but do so with all your heart.  "
            let author = "Marcus Aurelius "
            let imageData = "image".data(using: .utf8)
            
            XCTAssertTrue(success)
            XCTAssertNotNil(quote)
            
            XCTAssertEqual(text, quote!.text)
            XCTAssertEqual(author, quote!.author)
            XCTAssertEqual(imageData, quote!.imageData)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    
    func testGetQuoteShouldPostFailedNotificationIfIncorrectResponseWhileRetrievingPicture() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseKO,
                error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostFailedNotificationIfErrorWhileRetrievingPicture() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    func testGetQuoteShouldPostFailedNotificationIfNoPictureData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
}
