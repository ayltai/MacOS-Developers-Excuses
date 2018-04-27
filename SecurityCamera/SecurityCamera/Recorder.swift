import AVFoundation

final class Recorder: NSObject {
    enum RecorderError: Error {
        case AUDIO_DEVICE_ERROR
        case VIDEO_DEVICE_ERROR
        case OUTPUT_FILE_ERROR
    }
    
    private let session: AVCaptureSession         = AVCaptureSession()
    private let output : AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
    init(audio: AVCaptureDevice?, video: AVCaptureDevice?, preset: AVCaptureSession.Preset? = .high) throws {
        super.init()
        
        self.session.sessionPreset = preset!
        
        if !self.addInput(device: audio) {
            self.onError(Recorder.RecorderError.AUDIO_DEVICE_ERROR)
        }
        
        if !self.addInput(device: video) {
            throw Recorder.RecorderError.VIDEO_DEVICE_ERROR
        }
        
        if !self.addOutput(output: self.output) {
            throw Recorder.RecorderError.OUTPUT_FILE_ERROR
        }
    }
    
    var isRecording: Bool {
        return self.output.isRecording
    }
    
    var isPaused: Bool {
        return self.output.isRecordingPaused
    }
    
    func start(saveTo: String) {
        if !self.isRecording {
            self.session.startRunning()
            self.output.startRecording(to: URL(fileURLWithPath: saveTo), recordingDelegate: self)
        }
    }
    
    func pause() {
        if self.isRecording && !self.isPaused {
            self.output.pauseRecording()
        }
    }
    
    func resume() {
        if self.isPaused {
            self.output.resumeRecording()
        }
    }
    
    func stop() {
        if self.isRecording {
            self.output.stopRecording()
            self.session.stopRunning()
        }
        
        while self.isRecording {
            sleep(1)
        }
    }
    
    func onStart() {
        print("Recording started")
    }
    
    func onPause() {
        print("Recording paused")
    }
    
    func onResume() {
        print("Recording resumed")
    }
    
    func onFinish() {
        print("Recording finished")
    }
    
    func onError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    private func addInput(device: AVCaptureDevice?) -> Bool {
        if let device = device {
            do {
                let input: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                    
                    return true
                }
            } catch let error {
                self.onError(error)
            }
        }
        
        return false
    }
    
    private func addOutput(output: AVCaptureFileOutput) -> Bool {
        if self.session.canAddOutput(output) {
            self.session.addOutput(output)
            
            return true
        }
        
        return false
    }
}

extension Recorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        self.onStart()
    }
    
    func fileOutput(_ captureOutput: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let FINISHED_RECORDING_ERROR_CODE = -11806
        
        if let error = error, error._code != FINISHED_RECORDING_ERROR_CODE {
            self.onError(error)
        } else {
            self.onFinish()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didPauseRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        self.onPause()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didResumeRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        self.onResume()
    }
    
    func fileOutputShouldProvideSampleAccurateRecordingStart(_ output: AVCaptureFileOutput) -> Bool {
        return true
    }
}
