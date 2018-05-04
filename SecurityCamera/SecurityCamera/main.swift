import AVFoundation
import Foundation

let maxDuration: Double = 10 * 60
let saveTo     : String

if CommandLine.arguments.count > 1 {
    saveTo = CommandLine.arguments[1]
} else {
    saveTo = "~/Movies/SecurityCamera-"
}

do {
    let recorder: Recorder = try Recorder(
        audio : AVCaptureDevice.default(for: AVMediaType.audio),
        video : AVCaptureDevice.default(for: AVMediaType.video),
        preset: AVCaptureSession.Preset.high
    )
    
    repeat {
        var done:  Bool = false
        let start: Date = Date()
        
        recorder.start(saveTo: saveTo + String(Date().timeIntervalSince1970) + ".mov")

        repeat {
            sleep(1)
            
            if Date().timeIntervalSince(start) >= maxDuration {
                done = true
            }
        } while !done
        
        print("Recording finished")

        recorder.stop()
    } while true
} catch let error {
    print("Error: \(error.localizedDescription)")
}
