//
//  ContentView.swift
//  Moonshot
//
//  Created by Andres on 2021-06-30.
//

import SwiftUI


struct ContentView: View {
    //True if showing dates, false if showing crew
    @State private var infoToggle = true
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: . leading) {
                        Text(mission.displayname)
                            .font(.headline)
                        if infoToggle == true {
                            Text(mission.formattedLaunchDate)
                        } else {
                            HStack {
                                ForEach(mission.crew, id: \.role) {
                                    let person = "\($0.name)."
                                    Text(person.capitalizingFirstLetter())
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                Button(action: {
                    self.infoToggle.toggle()
                }, label: {
                    Text(self.infoToggle ? "Show Crew" : "Show Date")
                }
                )
            )
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
