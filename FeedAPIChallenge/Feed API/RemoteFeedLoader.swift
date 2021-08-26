//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard self != nil else { return }
			switch result {
			case .failure:
				completion(.failure(Error.connectivity))
			case .success(let (data, response)):
				guard (response.statusCode == 200) else {
					completion(.failure(Error.invalidData))
					return
				}
				guard let items = JSONFeedDecoder.decode(data) else {
					completion(.failure(Error.invalidData))
					return
				}
				completion(.success(items))
			}
		}
	}
}
