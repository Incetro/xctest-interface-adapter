//
//  Breakpoint.swift
//  xctest-interface-adapter
//
//  Created by incetro on 01/01/2021.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

#if canImport(Darwin)
import Darwin

/// Raises a debug breakpoint if a debugger is attached.
@inline(__always)
@usableFromInline
func breakpoint(_ message: @autoclosure () -> String = "") {
#if DEBUG
    var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var info: kinfo_proc = kinfo_proc()
    var info_size = MemoryLayout<kinfo_proc>.size
    let isDebuggerAttached = name.withUnsafeMutableBytes {
        $0
            .bindMemory(to: Int32.self)
            .baseAddress
            .map { sysctl($0, 4, &info, &info_size, nil, 0) != -1 && info.kp_proc.p_flag & P_TRACED != 0 }
        ?? false
    }
    if isDebuggerAttached {
        fputs(
          """
          \(message())
          Caught debug breakpoint. Type "continue" ("c") to resume execution.
          """,
          stderr
        )
        raise(SIGTRAP)
    }
#endif
}
#endif
