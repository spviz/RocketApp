//
//  MockURLProtocol.swift
//  RocketAppTests
//
//  Created by Podgainy Sergei on 12.02.2023.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    static var mockURLs = [URL: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url, let (error, data, _) = MockURLProtocol.mockURLs[url] else { return }

        if let dataStrong = data {
            self.client?.urlProtocol(self, didLoad: dataStrong)
        }

        if let errorStrong = error {
            self.client?.urlProtocol(self, didFailWithError: errorStrong)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {

    }
}
