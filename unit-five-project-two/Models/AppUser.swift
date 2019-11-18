//
//  AppUser.swift
//  unit-five-project-two
//
//  Created by Levi Davis on 11/18/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AppUser {
    let email: String?
    let uid: String
    let userName: String?
    let dateCreated: Date?
    let photoURL: String?
    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.userName = user.displayName
        self.dateCreated = user.metadata.creationDate
        self.photoURL = user.photoURL?.absoluteString
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let userName = dict["userName"] as? String,
        let email = dict["email"] as? String,
        let photoURL = dict["photoURL"] as? String,
        let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else {return nil}
        
        self.userName = userName
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.uid = id
    }
    
    var fieldsDict: [String: Any] {
        return ["userName": self.userName ?? "", "email": self.email ?? ""]
    }
}
