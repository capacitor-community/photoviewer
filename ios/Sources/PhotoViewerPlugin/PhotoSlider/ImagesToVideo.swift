//
//  ImagesToVideo.swift
//  CapacitorCommunityPhotoviewer
//
//  Created by  Quéau Jean Pierre on 20/03/2021.
//

import UIKit

import SDWebImage
import AVFoundation
import Photos

// swiftlint:disable file_length
// swiftlint:disable type_body_length
class ImagesToVideo {

    private var _numImages: Int = 0
    private var _imageList: [[String: String]] = []
    private var _options: [String: Any] = [:]
    private var _mode: String = "Landscape"
    private var _imageTime: Double = 3
    private var _uiImages: [UIImage] = []
    private var _imageSize: [[String: CGFloat]] = []
    private var _videoName: String = "myMovie"
    private var _videoMode: String = "landscape"
    private var _videoRatio: Double = 16 / 9
    private var _asset: AVAsset?
    private var _isVideoCreated: Bool = false

    // MARK: - Set-up imageList

    var imageList: [[String: String]] {
        get {
            return self._imageList
        }
        set {
            self._imageList = newValue
            self._numImages = self._imageList.count
        }
    }

    // MARK: - Set-up options

    var options: [String: Any] {
        get {
            return self._options
        }
        set {
            self._options = newValue
            if self._options.keys.contains("name") {
                if let vName = self._options["name"] as? String {
                    self._videoName = vName
                }
            } else {
                self._videoName = "myMovie"
            }
            if self._options.keys.contains("mode") {
                if let vMode = self._options["mode"] as? String {
                    self._videoMode = vMode
                }
            } else {
                self._videoMode = "landscape"
            }
            if self._options.keys.contains("ratio") {
                if let vRatio = self._options["ratio"] as? String {
                    if self._videoMode == "landscape" {
                        self._videoRatio = vRatio == "4/3" ? 4/3 : 16/9
                    } else {
                        self._videoRatio = vRatio == "4/3" ? 3/4 : 9/16
                    }
                }
            } else {
                self._videoRatio = self._videoMode == "landscape"
                    ? 16/9 : 9/16
            }
            if self._options.keys.contains("imagetime") {
                if let imageTime = self._options["imagetime"] as? Double {
                    self._imageTime = imageTime
                }
            } else {
                self._imageTime = 3
            }

        }
    }

    // MARK: - calculateMovieSize

    func calculateMovieSize() -> CGSize {
        var minWidth: CGFloat = 20000
        var minHeight: CGFloat = 20000
        for mSize in self._imageSize {
            if _videoMode == "landscape" {
                if let width = mSize["width"] {
                    minWidth = min(width, minWidth)
                    minHeight = minWidth * CGFloat(_videoRatio)
                }
            } else {
                if let height = mSize["height"] {
                    minHeight = min(height, minHeight)
                    minWidth = minHeight * CGFloat(_videoRatio)
                }
            }
        }
        return CGSize(width: minWidth, height: minHeight)

    }

    // MARK: - createFilm

    func createFilm() {
        // read the image
        for img in self._imageList {
            if let url = img["url"] {
                getUIImage(imageUrl: url)
            }
        }
        // calculate video size
        let movieSize: CGSize = calculateMovieSize()

        // create movie
        let videoURL: NSURL = NSURL(fileURLWithPath: NSHomeDirectory() +
                                        "/Documents/" + self._videoName + ".MP4")
        createMovie(videoURL: videoURL, movieSize: movieSize)
        return
    }

    // MARK: - createMovie

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    func createMovie(videoURL: NSURL, movieSize: CGSize) {
        var ret: [String: Any] = [:]
        removeFileAtURLIfExists(url: videoURL)
        let imagesPerSecond: TimeInterval = self._imageTime
        guard let videoWriter = try?
                AVAssetWriter(outputURL: videoURL as URL,
                              fileType: AVFileType.mp4) else {
            ret["result"] = false
            ret["message"] = "AVAssetWriter error"
            NotificationCenter.default.post(name: .movieCompleted,
                                            object: nil,
                                            userInfo: ret)
            return
        }
        let outputSettings = [AVVideoCodecKey: AVVideoCodecType.h264,
                              AVVideoWidthKey: NSNumber(
                                value: Float(movieSize.width)),
                              AVVideoHeightKey: NSNumber(
                                value: Float(movieSize.height))]
            as [String: Any]
        guard videoWriter.canApply(outputSettings: outputSettings,
                                   forMediaType: AVMediaType.video) else {
            ret["result"] = false
            ret["message"] = "Videowriter : Can't apply the Output " +
                "settings..."
            NotificationCenter.default.post(name: .movieCompleted,
                                            object: nil,
                                            userInfo: ret)
            return

        }
        let videoWriterInput = AVAssetWriterInput(
            mediaType: AVMediaType.video,
            outputSettings: outputSettings)
        let kCV1 =
            NSNumber(value: kCVPixelFormatType_32ARGB)
        let kCV2 = NSNumber(value: Float(movieSize.width))
        let kCV3 = NSNumber(value: Float(movieSize.height))
        var sPixelBufferAttrDict: [String: NSNumber] = [:]
        sPixelBufferAttrDict[kCVPixelBufferPixelFormatTypeKey as String] = kCV1
        sPixelBufferAttrDict[kCVPixelBufferWidthKey as String] = kCV2
        sPixelBufferAttrDict[kCVPixelBufferHeightKey as String] = kCV3

        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoWriterInput,
            sourcePixelBufferAttributes: sPixelBufferAttrDict)
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        }

        if videoWriter.startWriting() {
            let zeroTime =
                CMTimeMake(value: Int64(imagesPerSecond),
                           timescale: Int32(1))
            videoWriter.startSession(atSourceTime: zeroTime)
            guard let bufPool = pixelBufferAdaptor.pixelBufferPool else {
                ret["result"] = false
                ret["message"] = "Videowriter : pixelBufferAdaptor " +
                    ".pixelBufferPool is null "
                NotificationCenter.default.post(name: .movieCompleted,
                                                object: nil,
                                                userInfo: ret)
                return

            }
            //            assert(pixelBufferAdaptor.pixelBufferPool != nil)
            let mediaQueue = DispatchQueue(label: "mediaInputQueue")
            videoWriterInput
                .requestMediaDataWhenReady(on: mediaQueue,
                                           using: { () in
                                            let fps: Int32 = 1
                                            let framePerSecond: Int64 = Int64(imagesPerSecond)
                                            let frameDuration =
                                                CMTimeMake(value: Int64(imagesPerSecond),
                                                           timescale: fps)
                                            var frameCount: Int64 = 0
                                            var appendSucceeded = true
                                            while !self._uiImages.isEmpty {
                                                if videoWriterInput.isReadyForMoreMediaData {
                                                    let nextPhoto = self._uiImages.remove(at: 0)
                                                    let lastFrameTime =
                                                        CMTimeMake(value: frameCount * framePerSecond,
                                                                   timescale: fps)
                                                    let presentationTime = frameCount == 0
                                                        ? lastFrameTime
                                                        : CMTimeAdd(lastFrameTime, frameDuration)
                                                    var pixelBuffer: CVPixelBuffer?
                                                    let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(
                                                        kCFAllocatorDefault,
                                                        bufPool, &pixelBuffer)
                                                    if let pixelBuffer = pixelBuffer, status == 0 {
                                                        let managedPixelBuffer = pixelBuffer
                                                        CVPixelBufferLockBaseAddress(
                                                            managedPixelBuffer,
                                                            CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
                                                        let data =
                                                            CVPixelBufferGetBaseAddress(managedPixelBuffer)
                                                        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                                                        let context = CGContext(
                                                            data: data, width: Int(movieSize.width),
                                                            height: Int(movieSize.height),
                                                            bitsPerComponent: 8,
                                                            bytesPerRow: CVPixelBufferGetBytesPerRow(
                                                                managedPixelBuffer), space: rgbColorSpace,
                                                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst
                                                                .rawValue)
                                                        guard let ctx = context else {
                                                            ret["result"] = false
                                                            ret["message"] = "Videowriter : context is null "
                                                            NotificationCenter.default.post(
                                                                name: .movieCompleted,
                                                                object: nil, userInfo: ret)
                                                            return
                                                        }
                                                        ctx.clear(CGRect(
                                                                    x: 0, y: 0,
                                                                    width: CGFloat(movieSize.width),
                                                                    height: CGFloat(movieSize.height)))
                                                        let horizontalRatio = CGFloat(movieSize.width) /
                                                            nextPhoto.size.width
                                                        let verticalRatio = CGFloat(movieSize.height) /
                                                            nextPhoto.size.height

                                                        // let aspectRatio = max(horizontalRatio,
                                                        //                  verticalRatio) // ScaleAspectFill

                                                        // ScaleAspectFit
                                                        let aspectRatio = min(horizontalRatio, verticalRatio)
                                                        let newSize: CGSize = CGSize(
                                                            width: nextPhoto.size.width * aspectRatio,
                                                            height: nextPhoto.size.height * aspectRatio)
                                                        let posX = newSize.width < movieSize.width
                                                            ? (movieSize.width - newSize.width) / 2 : 0
                                                        let posY = newSize.height < movieSize.height
                                                            ? (movieSize.height - newSize.height) / 2 : 0
                                                        guard let nPhotoCGImage = nextPhoto.cgImage else {
                                                            ret["result"] = false
                                                            ret["message"] = "Videowriter : nextPhoto" +
                                                                ".cgImage  is null "
                                                            NotificationCenter.default.post(
                                                                name: .movieCompleted,
                                                                object: nil, userInfo: ret)
                                                            return
                                                        }

                                                        ctx.draw(nPhotoCGImage, in: CGRect(
                                                                    x: posX, y: posY, width: newSize.width,
                                                                    height: newSize.height))
                                                        CVPixelBufferUnlockBaseAddress(
                                                            managedPixelBuffer, CVPixelBufferLockFlags(
                                                                rawValue: CVOptionFlags(0)))
                                                        appendSucceeded = pixelBufferAdaptor
                                                            .append(pixelBuffer, withPresentationTime:
                                                                        presentationTime)
                                                    } else {
                                                        print("Failed to allocate pixel buffer")
                                                        appendSucceeded = false
                                                    }
                                                    frameCount += 1
                                                }
                                                if !appendSucceeded {
                                                    break
                                                }
                                            }
                                            videoWriterInput.markAsFinished()
                                            videoWriter.finishWriting { [self] () in

                                                if videoWriter.status == .completed {
                                                    self._asset = AVAsset(url: videoURL as URL)
                                                    // self.exportVideoWithAnimation()

                                                    getPermissionIfNecessary { granted in
                                                        guard granted else { return }

                                                        // Save video to photo Gallery
                                                        self.saveToPhotoGallery(videoURL:
                                                                                    videoURL as URL)
                                                    }
                                                    ret["result"] = true
                                                } else {
                                                    ret["result"] = false
                                                    ret["message"] = "Videowriter: Movie " +
                                                        "creation failed"
                                                }
                                                NotificationCenter.default
                                                    .post(name: .movieCompleted, object: nil, userInfo: ret)
                                                return
                                            }
                                           })
        }
    }
    // swiftlint:enable function_body_length
    // swiftlint:enable cyclomatic_complexity

    // MARK: - saveToPhotoGallery

    func saveToPhotoGallery(videoURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest
                .creationRequestForAssetFromVideo(atFileURL: videoURL)
        }, completionHandler: { (success, error) in
            if success {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors =
                    [NSSortDescriptor(key: "creationDate", ascending: false)]
                _ = PHAsset.fetchAssets(with: .video,
                                        options: fetchOptions).firstObject
                // Remove video from NSHomeDirectory
                self.removeFileAtURLIfExists(url: videoURL as NSURL)

            } else {
                if let err = error {
                    print(err.localizedDescription)
                }
            }
        })
    }

    // MARK: - removeFileAtURLIfExists

    func removeFileAtURLIfExists(url: NSURL) {
        if let filePath = url.path {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                do {
                    try fileManager.removeItem(atPath: filePath)
                } catch let error as NSError {
                    print("Couldn't remove existing movie file: \(error)")
                }
            }
        }
    }

    // MARK: - getUIImage

    func getUIImage(imageUrl: String) {
        if imageUrl.prefix(4) == "http" || imageUrl.contains("base64") {

            SDWebImageManager.shared.loadImage(
                with: URL(string: imageUrl),
                options: .continueInBackground, // or .highPriority
                progress: nil,
                completed: { [weak self] (image, _, error, _, _, _) in
                    guard let sself = self else { return }

                    if let err = error {
                        // Do something with the error
                        print("*** Error \(err.localizedDescription)")
                        return
                    }

                    guard let loadedImage = image else {
                        // No image handle this error
                        print("*** Error No Image returned")
                        return
                    }
                    // Do something with image
                    sself._uiImages.append(loadedImage)
                    let imgWidth: CGFloat = loadedImage.size.width * loadedImage.scale
                    let imgHeight: CGFloat = loadedImage.size.height *
                        loadedImage.scale
                    let imgSize: [String: CGFloat] = ["width": imgWidth,
                                                      "height": imgHeight]
                    sself._imageSize.append(imgSize)
                }
            )
        }
        if imageUrl.prefix(38) ==
            "file:///var/mobile/Media/DCIM/100APPLE" ||
            imageUrl.prefix(38) ==
            "capacitor://localhost/_capacitor_file_" {
            let image: UIImage = UIImage()
            if let img = image.getImage(path: imageUrl,
                                        placeHolder: "livephoto.slash") {
                self._uiImages.append(img)
                let imgWidth: CGFloat = img.size.width * img.scale
                let imgHeight: CGFloat = img.size.height * img.scale
                let imgSize: [String: CGFloat] = ["width": imgWidth,
                                                  "height": imgHeight]
                self._imageSize.append(imgSize)
            }

        }

    }

    // MARK: - getPermissionIfNecessary

    func getPermissionIfNecessary(completionHandler:
                                    @escaping (Bool) -> Void) {
        // 1
        guard PHPhotoLibrary
                .authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        // 2
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
