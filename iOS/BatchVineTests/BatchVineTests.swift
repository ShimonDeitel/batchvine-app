import XCTest
@testable import BatchVine

@MainActor
final class BatchVineTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testSeedEmptyThenSeeds() {
        store.seed()
        XCTAssertEqual(store.entries.count, 3)
    }

    func testAddEntry() {
        store.entries = []
        store.add(name: "Test Item", base: "x", embellishments: "x", season: "x", notes: "x")
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "Test Item")
    }

    func testFreeLimitAboveSeed() {
        XCTAssertGreaterThan(Store.freeLimit, 3)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        store.isPro = false
        store.entries = (0..<Store.freeLimit).map { i in
            WreathEntry(name: "Item \(i)", base: "", embellishments: "", season: "", notes: "")
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        store.entries = (0..<Store.freeLimit).map { i in
            WreathEntry(name: "Item \(i)", base: "", embellishments: "", season: "", notes: "")
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteEntry() {
        store.entries = []
        store.add(name: "ToDelete", base: "x", embellishments: "x", season: "x", notes: "x")
        let entry = store.entries.first!
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        store.entries = []
        store.add(name: "Original", base: "x", embellishments: "x", season: "x", notes: "x")
        var entry = store.entries.first!
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }
}
