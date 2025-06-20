//
//  UpdateClubIntroUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/25/25.
//

protocol UpdateClubIntroUseCaseProtocol {
    func execute(
        clubId: String,
        introduction: String,
        image: UIImage?,
        existingImageURL: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
}

final class UpdateClubIntroUseCase: UpdateClubIntroUseCaseProtocol {
    func execute(
        clubId: String,
        introduction: String,
        image: UIImage?,
        existingImageURL: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        repository.updateClubDescriptionAndImage(
            clubId: clubId,
            introduction: introduction,
            image: image,
            existingImageURL: existingImageURL,
            completion: completion 
        )
    }

    private let repository: ClubRepositoryProtocol

    init(repository: ClubRepositoryProtocol) {
        self.repository = repository
    }
}
