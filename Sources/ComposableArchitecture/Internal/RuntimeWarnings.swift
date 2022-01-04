#if DEBUG
  import os

  // NB: Xcode runtime warnings offer a much better experience than traditional assertions and
  //     breakpoints, but Apple provides no means of creating custom runtime warnings ourselves.
  //     To work around this, we hook into SwiftUI's runtime issue delivery mechanism, instead.
  //
  // Feedback filed: https://gist.github.com/stephencelis/a8d06383ed6ccde3e5ef5d1b3ad52bbc
  let rw = (
    dso: { () -> UnsafeMutableRawPointer in
      let count = _dyld_image_count()
      for i in 0..<count {
        if let name = _dyld_get_image_name(i) {
          let swiftString = String(cString: name)
          if swiftString.hasSuffix("SwiftUI") {
            if let pointer = UnsafeMutableRawPointer(bitPattern: _dyld_get_image_vmaddr_slide(i)) {
              return pointer
            }
          }
        }
      }
      return UnsafeMutableRawPointer(mutating: #dsohandle)
    }(),
    log: OSLog(subsystem: "com.apple.runtime-issues", category: "ComposableArchitecture")
  )
#endif
