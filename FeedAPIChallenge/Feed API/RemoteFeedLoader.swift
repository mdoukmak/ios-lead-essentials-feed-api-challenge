//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

private protocol FeedDecoder {
	func decode(_ data: Data) -> [FeedImage]?
}

internal struct RemoteFeedImage: Decodable {
	let id: UUID
	let description: String?
	let location: String?
	let url: URL

	enum CodingKeys: String, CodingKey {
		case id = "image_id"
		case description = "image_desc"
		case location = "image_loc"
		case url = "image_url"
	}
}

extension FeedImage {
	internal static func image(from remoteImage: RemoteFeedImage) -> FeedImage? {
		return FeedImage(id: remoteImage.id, description: remoteImage.description, location: remoteImage.location, url: remoteImage.url)
	}
}

internal final class JSONFeedDecoder: FeedDecoder {
	public func decode(_ data: Data) -> [FeedImage]? {
		var images = [FeedImage]()

		let decoder = JSONDecoder()
		let decodedImages = try? decoder.decode([RemoteFeedImage].self, from: data)
		guard let remoteImages = decodedImages else { return nil }
		images = remoteImages.compactMap {
			FeedImage.image(from: $0)
		}
		return images
	}
}

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient
	private let decoder: FeedDecoder

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
		self.decoder = JSONFeedDecoder()
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .failure:
				completion(.failure(RemoteFeedLoader.Error.connectivity))
			case .success(let (data, response)):
				guard (response.statusCode == 200) else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
					return
				}
				guard let _ = self.decoder.decode(data) else {
					completion(.failure(RemoteFeedLoader.Error.invalidData))
					return
				}
			}
		}
	}
}
