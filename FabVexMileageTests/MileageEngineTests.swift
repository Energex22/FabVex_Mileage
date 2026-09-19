import XCTest
@testable import FabVexMileage
final class MileageEngineTests:XCTestCase{func testNoiseIsRejected(){let a=TrackPoint(timestamp:.now,lat:38,lon:-90,accuracy:5,speed:0,course:0);let b=TrackPoint(timestamp:.now.addingTimeInterval(10),lat:38.00001,lon:-90.00001,accuracy:5,speed:0,course:0);let r=MileageEngine.calculate([a,b]);XCTAssertEqual(r.filtered,0,accuracy:0.001)} }
