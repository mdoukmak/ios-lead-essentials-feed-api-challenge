//
//  FeedImage+RemoteFeedImageTranslation.swift
//  FeedAPIChallenge
//
//  Created by Muhammad Doukmak on 8/24/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

extension FeedImage {
	internal static func image(from remoteImage: RemoteFeedImage) -> FeedImage {
		return FeedImage(id: remoteImage.id, description: remoteImage.description, location: remoteImage.location, url: remoteImage.url)
	}
}
