//
//  AstronautView.swift
//  Moonshot
//
//  Created by Zaheer Moola on 2021/07/06.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let astronautMissions: [Mission]

    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        let missions: [Mission] = Bundle.main.decode("missions.json")

        var matches = [Mission]()
        for mission in missions {
            for crew in mission.crew {
                if crew.name == astronaut.id {
                    matches.append(mission)
                }
            }
        }
        self.astronautMissions = matches
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                        .accessibility(hidden: true)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)

                    Text("Missions:")
                        .font(.headline)
                        .padding()

                    ForEach(astronautMissions) {
                        Text($0.displayName)
                            .font(.body)
                            .padding()
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
