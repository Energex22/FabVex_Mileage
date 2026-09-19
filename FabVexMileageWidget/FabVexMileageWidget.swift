import WidgetKit
import SwiftUI

struct Provider: TimelineProvider { func placeholder(in context: Context)->SimpleEntry{.init(date:.now)}; func getSnapshot(in context:Context,completion:@escaping(SimpleEntry)->Void){completion(.init(date:.now))}; func getTimeline(in context:Context,completion:@escaping( (Timeline<SimpleEntry>)->Void)){completion(Timeline(entries:[.init(date:.now)],policy:.after(.now.addingTimeInterval(900))))} }
struct SimpleEntry:TimelineEntry{let date:Date}
struct WidgetView:View{var entry:SimpleEntry;var body:some View{VStack{Text("FabVex Mileage").font(.headline);Link("START WORK",destination:URL(string:"fabvexmileage://start")!).font(.caption.bold());Link("END WORK",destination:URL(string:"fabvexmileage://end")!).font(.caption.bold())}.padding()}}
@main struct FabVexMileageWidget:Widget{var body:some WidgetConfiguration{StaticConfiguration(kind:"FabVexMileageWidget",provider:Provider()){WidgetView(entry:$0)}.configurationDisplayName("FabVex Mileage").description("Start or end a work session quickly.").supportedFamilies([.systemSmall,.systemMedium])}}
