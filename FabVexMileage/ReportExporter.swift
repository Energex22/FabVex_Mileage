import Foundation
import UIKit

struct ReportExporter {
 static func csv(sessions:[WorkSession], expenses:[Expense]) -> Data {
   var out="Date,Source,Start,End,Mileage,Raw GPS,Reconstructed,Adjustment,Expected Pay,Actual Pay,Status,Confidence\n"
   let df=ISO8601DateFormatter()
   for s in sessions { out += "\(df.string(from:s.start)),\(s.source.csv),\(df.string(from:s.start)),\(s.end.map(df.string(from:)) ?? ""),\(s.finalMiles),\(s.rawMiles),\(s.reconstructedMiles),\(s.userAdjustment),\(s.expectedPay ?? 0),\(s.actualPay ?? 0),\(s.status),\(s.confidence)\n" }
   out += "\nExpenses\nDate,Category,Amount,Note\n"
   for e in expenses { out += "\(df.string(from:e.date)),\(e.category.csv),\(e.amount),\(e.note.csv)\n" }
   return Data(out.utf8)
 }
 static func pdf(sessions:[WorkSession], expenses:[Expense]) -> Data {
   let format=UIGraphicsPDFRendererFormat(); let r=UIGraphicsPDFRenderer(bounds:CGRect(x:0,y:0,width:612,height:792),format:format)
   return r.pdfData { ctx in
     ctx.beginPage(); var y:CGFloat=40
     func line(_ t:String,_ size:CGFloat=12){ NSString(string:t).draw(at:CGPoint(x:40,y:y),withAttributes:[.font:UIFont.systemFont(ofSize:size)]); y += size+8; if y>750 {ctx.beginPage(); y=40} }
     line("FabVex Mileage Report",24); line("Generated \(Date().formatted())"); line("Sessions: \(sessions.count)"); line("Mileage: \(sessions.reduce(0){$0+$1.finalMiles}, specifier: \"%.1f\") mi"); line("Income: $\(sessions.compactMap{$0.actualPay}.reduce(0,+))"); line("Expenses: $\(expenses.reduce(0){$0+$1.amount})"); y += 12
     for s in sessions { line("• \(s.start.formatted(date:.abbreviated,time:.shortened)) | \(s.source) | \(String(format:"%.1f",s.finalMiles)) mi | \(s.status)") }
   }
 }
}
private extension String { var csv:String { "\"" + replacingOccurrences(of:"\"",with:"\"\"") + "\"" } }
