import ApplicationServices
import ArgumentParser
import CoreGraphics

struct Retina {
    public static var modes: [CGDisplayMode] {
        var result: [CGDisplayMode] = []
        let settingsDict = [kCGDisplayShowDuplicateLowResolutionModes: kCFBooleanTrue] as! CFDictionary
        let modes = CGDisplayCopyAllDisplayModes(CGMainDisplayID(), settingsDict).unsafelyUnwrapped

        for offset in 0..<CFArrayGetCount(modes) {
            result.append(
                unsafeBitCast(CFArrayGetValueAtIndex(modes, offset), to: CGDisplayMode.self)
            )
        }

        return result
    }

    static func main() {
        let displayId = CGMainDisplayID()
        guard let currentMode = CGDisplayCopyDisplayMode(displayId) else { return }
        let currentResolution = Resolution(currentMode, current: true)
        var resolutions = [Resolution]()
        let validWidths: [Int] = [1512, 1800]
        let validHeights: [Int] = [982, 1169]
        for mode in modes where (mode.refreshRate >= 120.0 && validWidths.contains(mode.width) && validHeights.contains(mode.height)) {
            var resolution = Resolution(mode)
            if currentResolution.ioDisplayModeID == resolution.ioDisplayModeID {
                resolution.setCurrent()
            }
            resolutions.append(resolution)
        }

        guard let newResolution = resolutions.filter({ !$0.current }).first else { return }

        activate(newResolution.mode, for: displayId)
    }

    static func activate(_ mode: CGDisplayMode, for display: CGDirectDisplayID) {
        let config = UnsafeMutablePointer<CGDisplayConfigRef?>.allocate(capacity: 1)
        CGBeginDisplayConfiguration(config)
        CGConfigureDisplayWithDisplayMode(config.pointee, display, mode, nil)
        CGCompleteDisplayConfiguration(config.pointee, CGConfigureOption.permanently)
        config.deallocate()
    }
}

Retina.main()
