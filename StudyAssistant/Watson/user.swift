//
//  user.swift
//  StudyAssistant
//
//  Created by enrique on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import Foundation
import JSQMessagesViewController

enum User: String {
    case me = "053496-4509-288"
    case watson = "053496-4509-289"
    
    static func getName(_ user: User) -> String {
        switch user {
        case .me: return "Me"
        case .watson: return "Watson"
        }
    }
    
    static func getAvatar(_ id: String) -> JSQMessagesAvatarImage? {
        let user = User(rawValue: id)!
        switch user {
        case .me: return nil
        case .watson: return avatarWatson
        }
    }
}

private let avatarWatson = JSQMessagesAvatarImageFactory.avatarImage(
    with: #imageLiteral(resourceName: "watson_avatar"),
    diameter: 24
)
