//
//  ContentView.swift
//  Moonshot
//
//  Created by Zaheer Moola on 2021/07/05.
//

import SwiftUI

// Challenge for this project:
struct SubtitleView: View {
    let mission: Mission
    let shouldDisplayCrew: Bool

    var body: some View {
        Group {
            if !shouldDisplayCrew {
                Text(mission.formattedLaunchDate)
                    .font(.body)
            } else {
                ForEach(matchingAstronauts) {
                    Text($0.name)
                }
            }
        }
    }

    private var matchingAstronauts: [Astronaut] {
        let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
        var matches = [Astronaut]()
        for crew in mission.crew {
            if let matchingAstronaut = astronauts.first(where: { $0.id == crew.name}) {
                matches.append(matchingAstronaut)
            }
        }
        return matches
    }
}

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var crewToggle = false

    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission,
                                                        astronauts: astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        SubtitleView(mission: mission,
                                     shouldDisplayCrew: crewToggle)
                    }
                }
            }
            .navigationBarItems(leading:
                                    Button("Toggle info") {
                                        crewToggle.toggle()
                                    }
            )
            .navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
