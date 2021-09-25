import StudentDTO
import XCTJSONKit

final class APIErrorReasonTests: XCTestCase {
    func testConsistentCoreReasonsRawValues() {
        for coreReason in CoreDTO.APIErrorReason.allCases {
            let sut = StudentDTO.APIErrorReason(rawValue: coreReason.rawValue)
            XCTAssertEqual(sut?.rawValue, coreReason.rawValue)
        }
    }
}
