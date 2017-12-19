//
//  Models.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-11.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import Foundation

struct FbUser {
    var fbId: String?
    var fbEmail: String?
    var fbName: String?
    var imageUrl: String?
}

struct OptieUser {
    var uid: String?
    var email: String?
    var name: String?
    var imageUrl: String?
    var location: String?
}

//struct manualLoginUserModel {
//    var uid: String?
//    var userEmail: String?
//    var userName: String?
//    var imageUrl: String?
//    var image: String?
//    var location: String?
//}

struct SkillLevelModel {
    var skillLevel: Int?
    var skillQ1: Bool?
    var skillQ2: Bool?
    var skillQ3: Bool?
    var skillQ4: Bool?
    var skillQ5: Bool?
}

struct AvailabilityModel {
    var userType: String?
    var haveCar: Bool?
    var monday: Bool?
    var tuesday: Bool?
    var wednesday: Bool?
    var thursday: Bool?
    var friday: Bool?
    var saturday: Bool?
    var sunday: Bool?
}
