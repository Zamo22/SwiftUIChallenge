//
//  MissionView.swift
//  Moonshot
//
//  Created by Zaheer Moola on 2021/07/06.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }

    let mission: Mission
    let astronauts: [CrewMember]

    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission

        var matches = [CrewMember]()
        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member) from records")
            }
        }

        self.astronauts = matches
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeometry in
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top)
                            .frame(width: imageGeometry.size.width, height: imageGeometry.size.height)
                            .scaleEffect(1 - self.scaleFactor(geometry: geo, imageGeometry: imageGeometry))
                            .offset(x: 0, y: self.scaleFactor(geometry: geo, imageGeometry: imageGeometry) * imageGeometry.size.height / 2)
                            .accessibility(hidden: true)
                    }
                    .frame(height: geo.size.width * 0.75)

                    Text(mission.formattedLaunchDate)

                    Text(mission.description)
                        .padding()

                    ForEach(astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(crewMember.role == "Commander"
                                                                ? Color.red : .black,
                                                             lineWidth: crewMember.role == "Commander" ? 2 : 1))

                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer(minLength: 25)
                }
            }

        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }

    func scaleFactor(geometry: GeometryProxy, imageGeometry: GeometryProxy) -> CGFloat {
            let imagePosition = imageGeometry.frame(in: .global).minY
            let safeAreaHeight = geometry.safeAreaInsets.top

            return (safeAreaHeight - imagePosition) / 500

            // if zoom needs to be capped
            //return -min(0.5, (imagePosition - safeAreaHeight) / 500)
        }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
