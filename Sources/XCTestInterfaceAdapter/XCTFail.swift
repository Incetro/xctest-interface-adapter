//
//  XCTFail.swift
//  xctest-interface-adapter
//
//  Created by incetro on 01/01/2021.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

#if canImport(ObjectiveC)
import Foundation

// MARK: - XCTFail

/// This function generates a failure immediately and unconditionally.
///
/// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
/// context of the caller. Useful for defining assertion helpers that fail in indirect code
/// paths, where the `file` and `line` of the failure have not been realized.
///
/// - Parameter message: An optional description of the assertion, for inclusion in test
///   results.
public func XCTFail(_ message: String = "") {
    if
        let observationCenter = NSClassFromString("XCTestObservationCenter") as Any as? NSObjectProtocol,
        String(describing: observationCenter) != "<null>",
        let shared = observationCenter.perform(Selector(("sharedTestObservationCenter")))?.takeUnretainedValue(),
        let observers = shared.perform(Selector(("observers")))?.takeUnretainedValue() as? [AnyObject],
        let observer = observers.first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
        let currentTestCase = observer.perform(Selector(("currentTestCase")))?.takeUnretainedValue(),
        let XCTIssue = NSClassFromString("XCTIssue") as Any as? NSObjectProtocol,
        let alloc = XCTIssue.perform(NSSelectorFromString("alloc"))?.takeUnretainedValue(),
        let issue = alloc.perform(
            Selector(("initWithType:compactDescription:")),
            with: 0,
            with: message.isEmpty ? "failed" : message
        )?.takeUnretainedValue()
    {
        _ = currentTestCase.perform(Selector(("recordIssue:")), with: issue)
    }
}

/// This function generates a failure immediately and unconditionally
///
/// Dynamically calls `XCTFail` with the given file and line. Useful for defining assertion
/// helpers that have the source code context at hand and want to highlight the direct caller
/// of the helper
///
/// - Parameter message: An optional description of the assertion, for inclusion in test
///   results
public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {
    guard let failure = _XCTFailureHandler else { return }
    failure(nil, true, "\(file)", line, "\(message.isEmpty ? "failed" : message)", nil)
}

// MARK: - XCTFailureHandler

private typealias XCTFailureHandler = @convention(c) (AnyObject?, Bool, UnsafePointer<CChar>, UInt, String, String?) -> Void

// MARK: - Properties

private let XCTest = NSClassFromString("XCTest")
    .flatMap(Bundle.init(for:))
    .flatMap(\.executablePath)
    .flatMap { dlopen($0, RTLD_NOW) }

private let _XCTFailureHandler = XCTest
    .flatMap { dlsym($0, "_XCTFailureHandler") }
    .map { unsafeBitCast($0, to: XCTFailureHandler.self) }
#endif
