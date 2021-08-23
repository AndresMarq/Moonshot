//
//  AstronautView.swift
//  Moonshot
//
//  Created by Andres on 2021-07-05.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    
    var missionNames: [String]
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(hidden: true)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Text("Missions Flown")
                        .bold()
                    
                    ForEach(self.missionNames, id: \.self) { mission in
                        HStack {
                            Text("\(mission)")
                        }
                        .frame(width: geometry.size.width)
        
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        
        var matches = [String]()
        
        for mission in missions {
            for _ in mission.crew {
                if mission.crew.first(where: {$0.name == astronaut.id}) != nil {
                    matches.append(mission.displayname)
                    break
                }
            }
        }
        
        self.missionNames = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
