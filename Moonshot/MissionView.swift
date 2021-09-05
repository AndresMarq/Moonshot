//
//  MissionView.swift
//  Moonshot
//
//  Created by Andres on 2021-07-04.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let astronauts: [CrewMember]
    let mission: Mission
    
    let frameHeight: CGFloat = 300
    
    var body: some View {
        GeometryReader { viewGeo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeo in
                        HStack {
                            Spacer()
                            Image(self.mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: viewGeo.size.width * 0.7)
                                .padding(.top)
                                .offset(x: 0, y: getOffsetForMissionPatch(for: imageGeo))
                                .scaleEffect(getScaleOfMissionPatch(for: imageGeo))
                                .accessibility(label: Text("Logo of \(self.mission.displayname)"))
                            Spacer()
                        }
                    }
                    .frame(height: self.frameHeight, alignment: .center)
                    
                    Text("Launch Date: \(self.mission.formattedLaunchDate)")
                        .bold()
                        .padding()
                    
                    Spacer()
                    Text(self.mission.description)
                        
                        
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) { CrewMember in
                        NavigationLink(destination: AstronautView(astronaut: CrewMember.astronaut)) {
                            HStack {
                                Image(CrewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                    .accessibility(hidden: true)
                            
                                VStack(alignment: .leading) {
                                    Text(CrewMember.astronaut.name)
                                        .font(.headline)
                                    Text(CrewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayname), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        self.astronauts = matches
    }
    
    func getOffsetForMissionPatch(for geometry: GeometryProxy) -> CGFloat {
        let scale = getScaleOfMissionPatch(for: geometry)
        return self.frameHeight * (1 - scale)
    }

    func getScaleOfMissionPatch(for geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        let halfHeight = self.frameHeight / 2

        // This value was found by just printing the minY of .global at the start
        let startingOffset: CGFloat = 91

        let minimumSizeAtOffset = startingOffset - halfHeight
        let scale = 0.8 + 0.2 * (offset - minimumSizeAtOffset) / halfHeight

        return scale
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
