//
//  Mission.swift
//  Moonshot
//
//  Created by Andres on 2021-07-02.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct Crewrole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [Crewrole]
    let description: String
    
    var displayname: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        }
        else {
            return "N/A"
        }
    }
}
