//
//  NavigationRouter.swift
//  O'Club
//
//  Created by 최효원 on 4/14/25.
//

import SwiftUI

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var userInfo: UserInfo?

    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
