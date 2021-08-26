//
//  JSONFeedDecoder.swift
//  FeedAPIChallenge
//
//  Created by Muhammad Doukmak on 8/24/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct JSONFeedDecoder {
	private init() {}

	static func decode(_ data: Data) -> [FeedImage]? {
		guard let remoteImages = try? JSONDecoder().decode(RemoteFeedResponsePayload.self, from: data).items else {
			return nil
		}
		return remoteImages.map {
			FeedImage.image(from: $0)
		}
	}
}

private extension FeedImage {
	static func image(from remoteImage: RemoteFeedImage) -> FeedImage {
		return FeedImage(id: remoteImage.id, description: remoteImage.description, location: remoteImage.location, url: remoteImage.url)
	}
}
