//
//  ProfileImageResponse.swift
//  Domain
//
//  Created by ukseung.dev on 1/10/25.
//

public struct ProfileImageResponse: Decodable {
    public let preSignedUrl: String
    public let contentUrl: String
}
