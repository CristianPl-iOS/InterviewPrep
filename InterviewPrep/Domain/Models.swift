//
//  Models.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import Foundation

struct Todo: Identifiable, Equatable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

struct User: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let email: String
}

struct Dashboard: Sendable {
    let user: User
    let todos: [Todo]
}

