//
//  RecipeRecipeTests.swift
//  RecipeRecipeTests
//
//  Created by Oliver Hu on 1/16/25.
//

import XCTest
@testable import RecipeRecipe

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        sut.session = session
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    // MARK: - Image Download and Cache Tests
    
    func testDownloadImage_WhenSuccessful_ShouldCacheImage() async {
        // Given
        let imageURL = "https://test.com/image.jpg"
        let testImage = UIImage(systemName: "star.fill")!
        let testImageData = testImage.pngData()!
        var networkCallCount = 0
        
        MockURLProtocol.requestHandler = { request in
            networkCallCount += 1
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, testImageData)
        }
        
        // When - First download
        let firstImage = await sut.downloadImage(from: imageURL)
        
        // Then
        XCTAssertNotNil(firstImage)
        XCTAssertEqual(networkCallCount, 1)
        
        // When - Second download (should use cache)
        let secondImage = await sut.downloadImage(from: imageURL)
        
        // Then
        XCTAssertNotNil(secondImage)
        XCTAssertEqual(networkCallCount, 1, "Should not make second network call")
        
        // Verify both images are identical
        let firstImageData = firstImage?.pngData()
        let secondImageData = secondImage?.pngData()
        XCTAssertEqual(firstImageData, secondImageData)
    }
    
    func testDownloadImage_WhenCacheCleared_ShouldDownloadAgain() async {
        // Given
        let imageURL = "https://test.com/image.jpg"
        let testImage = UIImage(systemName: "star.fill")!
        let testImageData = testImage.pngData()!
        var networkCallCount = 0
        
        MockURLProtocol.requestHandler = { request in
            networkCallCount += 1
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, testImageData)
        }
        
        // When - First download
        let firstImage = await sut.downloadImage(from: imageURL)
        XCTAssertNotNil(firstImage)
        XCTAssertEqual(networkCallCount, 1)
        
        // Clear cache
        sut.cache.removeAllObjects()
        
        // When - Second download
        let secondImage = await sut.downloadImage(from: imageURL)
        
        // Then
        XCTAssertNotNil(secondImage)
        XCTAssertEqual(networkCallCount, 2, "Should make new network call after cache cleared")
    }
    
    func testDownloadImage_WithInvalidURL_ShouldReturnNil() async {
        // Given
        let invalidURL = ""
        
        // When
        let image = await sut.downloadImage(from: invalidURL)
        
        // Then
        XCTAssertNil(image)
    }
    
    func testDownloadImage_WithInvalidData_ShouldReturnNil() async {
        // Given
        let imageURL = "https://test.com/image.jpg"
        let invalidImageData = "not an image".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidImageData)
        }
        
        // When
        let image = await sut.downloadImage(from: imageURL)
        
        // Then
        XCTAssertNil(image)
    }
}
