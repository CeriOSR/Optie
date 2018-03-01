//
//  Models.swift
//  Optie
//
//  Created by Rey Cerio on 2017-11-11.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import Foundation
import Firebase

struct OptieUser {
    var uid: String?
    var email: String?
    var name: String?
    var fbId: String?
    var imageUrl: String?
    var latitude: Double?
    var longitude: Double?
    var gender: String?
    var city: String?
    var province: String?
    var address: String?
    var age: String?
}

struct SkillLevelModel {
    var skillLevel: Int?
    var skillQ1: Bool?
    var skillQ2: Bool?
    var skillQ3: Bool?
    var skillQ4: Bool?
    var skillQ5: Bool?
}

struct AvailabilityModel {
    var bio: String?
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

struct UsersDayList {
    var day: String?
    var users: [OptieUser]?
}

struct Message {
    var date: String?
    var message: String?
    var sender: String?
    var reciever: String?
    
    func chatPartnerId() -> String? {
        return sender == Auth.auth().currentUser?.uid ? reciever : sender
    }
}

struct SettingsValues {
    var skillValue: Int?
    var ageValue: Int?
    var distance: Double?
    var gender: String?
    var bio: String?
}

struct UsersListPerDay {
    var monday : [OptieUser]?
    var sunday : [OptieUser]?
    var saturday : [OptieUser]?
    var friday : [OptieUser]?
    var thursday : [OptieUser]?
    var wednesday : [OptieUser]?
    var tuesday : [OptieUser]?
}

struct DaysAndUsersDictionary {
    var mondayUsers : UsersDayList?
    var tuesdayUsers : UsersDayList?
    var wednesdayUsers : UsersDayList?
    var thursdayUsers : UsersDayList?
    var fridayUsers : UsersDayList?
    var saturdayUsers : UsersDayList?
    var sundayUsers : UsersDayList?
}

//struct ArrayOfUsersPerDay {
//    var monday : [OptieUser]?
//    var sunday : [OptieUser]?
//    var saturday : [OptieUser]?
//    var friday : [OptieUser]?
//    var thursday :[OptieUser]?
//    var wednesday : [OptieUser]?
//    var tuesday : [OptieUser]?
//}



















