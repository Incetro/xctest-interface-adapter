//
//  XCTIsTesting.swift
//  xctest-interface-adapter
//
//  Created by incetro on 07/07/2022.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import Foundation

public let _XCTIsTesting: Bool = {
  ProcessInfo.processInfo.environment.keys.contains("XCTestSessionIdentifier")
    || ProcessInfo.processInfo.arguments.first
      .flatMap(URL.init(fileURLWithPath:))
      .map { $0.lastPathComponent == "xctest" || $0.pathExtension == "xctest" }
      ?? false
}()
