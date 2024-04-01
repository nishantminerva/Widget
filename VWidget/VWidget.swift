//
//  VWidget.swift
//  VWidget
//
//  Created by Nishant Minerva on 01/04/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var i = 0
        
        let namearray = ["Nishant", "Vivek", "Parthvi"]
        let currentDate = Date()
        for hourOffset in 0 ..< 200 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset+1, to: currentDate)!
            if i < 2 {
                i += 1
            } else {
                i = 0
            }
            let entry = SimpleEntry(date: entryDate, emoji: "\(namearray[i])")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct VWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct VWidget: Widget {
    let kind: String = "VWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                VWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                VWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    VWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
