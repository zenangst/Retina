import CoreGraphics
import Foundation

struct Resolution: Hashable {
    var current: Bool

    let mode: CGDisplayMode
    let ioDisplayModeID: Int32
    let width: Int
    let height: Int
    let refreshRate: Double

    init(_ mode: CGDisplayMode, current: Bool = false) {
        self.current = current
        self.width = mode.width
        self.height = mode.height
        self.refreshRate = mode.refreshRate
        self.ioDisplayModeID = mode.ioDisplayModeID
        self.mode = mode
    }

    mutating func setCurrent() {
        self.current = true
    }
}
