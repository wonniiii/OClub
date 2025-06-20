//
//  CalendarRepository.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import Foundation
import FirebaseFirestore

protocol ScheduleRepositoryProtocol {
    func fetchSchedules(clubID: String) async throws -> [Schedule]
    func listenSchedules(clubID: String,
                         onUpdate: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration
    func addSchedule(_ schedule: Schedule) async throws
    func addParticipant(userID: String, to scheduleID: String, in clubID: String) async throws
    func removeParticipant(userID: String, from scheduleID: String, in clubID: String) async throws
    func deleteSchedule(clubID: String, scheduleID: String) async throws
}

final class ScheduleRepository: ScheduleRepositoryProtocol {
    private let database = Firestore.firestore()

    func fetchSchedules(clubID: String) async throws -> [Schedule] {
        let snapshot = try await database
            .collection("Clubs")
            .document(clubID)
            .collection("events")
            .order(by: "startTime")
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            do {
                var schedule = try doc.data(as: Schedule.self)
                schedule.id = doc.documentID
                schedule.clubID = clubID
                return schedule
            } catch {
                print("Decoding error for doc \(doc.documentID): \(error)")
                return nil
            }
        }
    }

    func listenSchedules(clubID: String,
                         onUpdate: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration {
        return database.collection("Clubs")
            .document(clubID)
            .collection("events")
            .order(by: "startTime")
            .addSnapshotListener { snap, err in
                if let err = err {
                    onUpdate(.failure(err))
                    return
                }
                let list: [Schedule] = snap?.documents.compactMap { doc in
                    var schedule = try? doc.data(as: Schedule.self)
                    schedule?.id = doc.documentID
                    schedule?.clubID = clubID
                    return schedule
                } ?? []
                onUpdate(.success(list))
            }
    }

    func addSchedule(_ schedule: Schedule) async throws {
        let ref = database.collection("Clubs")
            .document(schedule.clubID)
            .collection("events")
            .document()
        var toSave = schedule
        toSave.id = ref.documentID

        try await ref.setData([
            "name": toSave.name,
            "date": Timestamp(date: toSave.date),
            "startTime": Timestamp(date: toSave.startTime),
            "endTime": Timestamp(date: toSave.endTime),
            "location": toSave.location,
            "participants": toSave.participants
        ])
    }

    func addParticipant(userID: String, to scheduleID: String, in clubID: String) async throws {
        let ref = database.collection("Clubs")
            .document(clubID)
            .collection("events")
            .document(scheduleID)
        try await ref.updateData([
            "participants": FieldValue.arrayUnion([userID])
        ])
    }

    func removeParticipant(userID: String, from scheduleID: String, in clubID: String) async throws {
        let ref = database.collection("Clubs")
            .document(clubID)
            .collection("events")
            .document(scheduleID)
        try await ref.updateData([
            "participants": FieldValue.arrayRemove([userID])
        ])
    }
    
    func deleteSchedule(clubID: String, scheduleID: String) async throws {
        try await database
            .collection("Clubs")
            .document(clubID)
            .collection("events")
            .document(scheduleID)
            .delete()
    }
}
