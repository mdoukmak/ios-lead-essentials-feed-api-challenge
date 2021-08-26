//
//  RemoteFeedResponsePayload.swift
//  FeedAPIChallenge
//
//  Created by Muhammad Doukmak on 8/24/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct RemoteFeedResponsePayload: Decodable {
	let items: [RemoteFeedImage]
}
