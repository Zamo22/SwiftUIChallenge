//
//  ActivityDetailsView.swift
//  Consolidation4
//
//  Created by Zaheer Moola on 2021/07/11.
//

import SwiftUI

struct ActivityDetailsView: View {
    @State var activity: ActivityItem
    @ObservedObject var allActivites: Activities

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 50) {
                
                VStack(alignment: .leading) {
                    Text("Details:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(activity.details)
                        .font(.body)
                }

                VStack(alignment: .center) {
                    Text("Times completed:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(activity.completedCount)")
                        .font(.body)
                }

                Button("Completed this again!") {
                    appendCompletedCount()
                }
                Spacer()
            }
            .padding()

            .navigationBarTitle(activity.title)
        }
    }

    func appendCompletedCount() {
        activity.completedCount += 1
        if let activityIndex = allActivites.items.firstIndex(where: {$0.id == activity.id}) {
            allActivites.items[activityIndex] = activity
        }
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockItem = ActivityItem(title: "Jogging", details: "I need to go jogging more often I guess", completedCount: 1)
        ActivityDetailsView(activity: mockItem, allActivites: Activities())
    }
}
