//
//  CheckPushStatusUseCase.swift
//  Domain
//
//  Created by ukseung.dev on 1/2/25.
//

public protocol CheckPushStatusUseCaseProtocol {
    func execute() async -> Bool
}

public final class CheckPushStatusUseCase: CheckPushStatusUseCaseProtocol {
    private let notificationRepository: NotificationRepositoryProtocol
    
    public init(notificationRepository: NotificationRepositoryProtocol) {
        self.notificationRepository = notificationRepository
    }
    
    public func execute() async -> Bool {
        let status = await notificationRepository.getPushStatus()
        return status == .authorized
    }
}
