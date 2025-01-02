//
//  NetworkProvider.swift
//  Data
//
//  Created by ukseung.dev on 12/27/24.
//

import Moya

final class NetworkProvider {
    static let shared = MoyaProvider<ProfileAPI>()
}
