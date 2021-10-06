import XCTest

final class XCTestInterfaceAdapterTests: XCTestCase {
    func testXCTFail() {
        MyXCTFail("This is expected to fail!")
    }
}
