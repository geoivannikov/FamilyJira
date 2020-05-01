//
//  FirebaseServiceMock.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 4/29/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Combine
@testable import FamilyJira

enum FirebaseServiceUseCase {
    case success
    case failureLogin(LoginError)
    case failureRegistration(RegistrationError)
    case failureRequest(RequestError)
    case failureUpdateProfile(UpdateProfileError)
    case failureCreateBoard(CreateBoardError)
    case failureLogOut
}

final class FirebaseServiceMock: FirebaseServiceProtocol {
    let isUserLoggedIn: Bool
    private let useCase: FirebaseServiceUseCase

    init(isUserLoggedIn: Bool = true, useCase: FirebaseServiceUseCase = .success) {
        self.isUserLoggedIn = isUserLoggedIn
        self.useCase = useCase
    }

    func signIn(with loginCredentials: LoginCredentials?) -> AnyPublisher<Void, LoginError> {
        switch useCase {
        case .success:
            return Result.success(())
                .publisher
                .eraseToAnyPublisher()
        case .failureLogin(let error):
            return Result.failure(error)
                .publisher
                .eraseToAnyPublisher()
        default:
            return Result.failure(LoginError.unknownError)
                .publisher
                .eraseToAnyPublisher()
        }
    }

    func signUp(with registrationCredentials: RegistrationCredentials?) -> AnyPublisher<Void, RegistrationError> {
        switch useCase {
        case .success:
            return Result.success(())
                .publisher
                .eraseToAnyPublisher()
        case .failureRegistration(let error):
            return Result.failure(error)
                .publisher
                .eraseToAnyPublisher()
        default:
            return Result.failure(RegistrationError.unknownError)
                .publisher
                .eraseToAnyPublisher()
        }
    }

    func signOut() throws {
        switch useCase {
        case .failureLogOut:
            throw LogOutError.unknownError
        default:
            ()
        }
    }

    func requestUser() -> AnyPublisher<UserDTO, RequestError> {
        switch useCase {
        case .success:
            return Result.success(UserDTO(id: "1",
                                          email: "email",
                                          username: "username",
                                          role: nil,
                                          photoUrl: nil,
                                          boardId: nil))
                .publisher
                .eraseToAnyPublisher()
        case .failureRequest(let error):
            return Result.failure(error)
                .publisher
                .eraseToAnyPublisher()
        default:
            return Result.failure(RequestError.unknownError)
                .publisher
                .eraseToAnyPublisher()
        }
    }

    func updateProfile(profileDTO: ProfileDTO) -> AnyPublisher<ProfileDTO, UpdateProfileError> {
        switch useCase {
        case .success:
            return Result.success(ProfileDTO(username: "username",
                                             role: "role",
                                             photoData: nil)!)
                .publisher
                .eraseToAnyPublisher()
        case .failureUpdateProfile(let error):
            return Result.failure(error)
                .publisher
                .eraseToAnyPublisher()
        default:
            return Result.failure(UpdateProfileError.unknownError)
                .publisher
                .eraseToAnyPublisher()
        }
    }

    func createBoard(boardInfo: BoardBasicInfoDTO) -> AnyPublisher<BoardBasicInfoDTO, CreateBoardError> {
        switch useCase {
        case .success:
            return Result.success(BoardBasicInfoDTO(name: "name", photoData: nil)!)
                .publisher
                .eraseToAnyPublisher()
        case .failureCreateBoard(let error):
            return Result.failure(error)
                .publisher
                .eraseToAnyPublisher()
        default:
            return Result.failure(CreateBoardError.unknownError)
                .publisher
                .eraseToAnyPublisher()
        }
    }
}
