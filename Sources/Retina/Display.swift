import CoreGraphics

enum DisplayError: Error {
    case unableToGetDisplayMode
}

struct Display {
    /// The display id for the main display.
    var id: CGDirectDisplayID
    var displayMode: CGDisplayMode

    private var validRefreshRates: Set<Double> = [120.0]
    private var validWidths: Set<Int> = [1512, 1800]
    private var validHeights: Set<Int> = [982, 1169]

    /// List all available modes.
    var modes: [CGDisplayMode] {
        var result: [CGDisplayMode] = []
        let settingsDict = [kCGDisplayShowDuplicateLowResolutionModes: kCFBooleanTrue] as! CFDictionary
        let modes = CGDisplayCopyAllDisplayModes(id, settingsDict).unsafelyUnwrapped

        for offset in 0..<CFArrayGetCount(modes) {
            result.append(
                unsafeBitCast(CFArrayGetValueAtIndex(modes, offset),
                              to: CGDisplayMode.self)
            )
        }

        return result
    }

    init(id: CGDirectDisplayID = CGMainDisplayID()) throws {
        self.id = id
        self.displayMode = try Self.displayMode(for: id)
    }

    /// Create a collection out of all valid display modes and
    /// put them in a collection of `Resolution` structs.
    /// - Returns: A collection of resolutions.
    func resolutions() throws -> [Resolution] {
        let currentResolution = Resolution(displayMode, current: true)
        var resolutions = [Resolution]()
        for mode in modes where isValid(mode) {
            var resolution = Resolution(mode)
            if currentResolution.ioDisplayModeID == resolution.ioDisplayModeID {
                resolution.setCurrent()
            }
            resolutions.append(resolution)
        }

        return resolutions
    }

    // MARK: Private methods

    /// Validate a resolution to verify that it fulfills the validation criteria.
    /// The current implementation checks that the resolution uses 120 refresh rate and is a part of either `Default` or `More Space` system resolutions.
    /// - Parameter displayMode: The display mode that should be validate.
    /// - Returns: True if all the criterias are met.
    private func isValid(_ displayMode: CGDisplayMode) -> Bool {
        validRefreshRates.contains(displayMode.refreshRate) &&
        validWidths.contains(displayMode.width) &&
        validHeights.contains(displayMode.height)
    }

    /// Copy the display mode based on id.
    /// - Parameter id: A core graphics display id, generally obtained
    ///                 by calling `CGMainDisplayID`.
    /// - Returns: A display mode if a match is found based on the `id`.
    private static func displayMode(for id: CGDirectDisplayID) throws -> CGDisplayMode {
        if let displayMode = CGDisplayCopyDisplayMode(id) {
            return displayMode
        } else {
            throw DisplayError.unableToGetDisplayMode
        }
    }

    // MARK: Static methods

    /// Activate a new mode for a display.
    /// - Parameters:
    ///   - mode: The mode that should be activate.
    ///   - display: The display that should use the new mode.
    static func activate(_ mode: CGDisplayMode, for display: CGDirectDisplayID) {
        let config = UnsafeMutablePointer<CGDisplayConfigRef?>.allocate(capacity: 1)
        CGBeginDisplayConfiguration(config)
        CGConfigureDisplayWithDisplayMode(config.pointee, display, mode, nil)
        CGCompleteDisplayConfiguration(config.pointee, CGConfigureOption.permanently)
        config.deallocate()
    }
}
