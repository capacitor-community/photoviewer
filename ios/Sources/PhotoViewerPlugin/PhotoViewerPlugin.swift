import Foundation
import Capacitor

extension NSNotification.Name {
    static var photoviewerExit: Notification.Name {return .init(rawValue: "photoviewerExit")}
}
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PhotoViewerPlugin)
public class PhotoViewerPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "PhotoViewerPlugin"
    public let jsName = "PhotoViewer"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "show", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "saveImageFromHttpToInternal", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getInternalImagePaths", returnType: CAPPluginReturnPromise)
    ]
    private var implementation: PhotoViewer?
    var exitObserver: Any?
    var config: PhotoViewerConfig?

    override public func load() {
        let mConfig = photoviewerConfig()
        self.config = mConfig
        self.addObserversToNotificationCenter()
        self.implementation = PhotoViewer(config: mConfig)
    }
    deinit {
        NotificationCenter.default.removeObserver(exitObserver as Any)
    }

    // MARK: echo

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        if let retValue: String = implementation?.echo(value) {
            call.resolve([
                "value": retValue
            ])
        }
    }

    // MARK: show

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    @objc func show(_ call: CAPPluginCall) {
        guard let imageList = call.options["images"] as? [[String: String]] else {
            let error: String = "Must provide an image list"
            print(error)
            call.reject("Show : \(error)")
            return
        }
        if imageList.count == 0 {
            let error: String = "Must provide a non-empty image list"
            print(error)
            call.reject("Show : \(error)")
            return

        }
        let mode: String = call.getString("mode") ?? "one"
        let startFrom: Int = call.getInt("startFrom") ?? 0
        let options: JSObject = call.getObject("options") ?? [:]
        var mOptions: [String: Any] = [:]
        let keys = options.keys
        if keys.count > 0 {
            if keys.contains("spancount") {
                mOptions["spancout"] = options["spancout"] as? Int
            }
            if keys.contains("share") {
                mOptions["share"] = options["share"] as? Bool
            }
            if keys.contains("title") {
                mOptions["title"] = options["title"] as? String
            }

        }

        // Display
        DispatchQueue.main.async { [weak self] in
            if imageList.count <= 1
                && (mode == "gallery" || mode == "slider") {
                var msg = "Show : imageList must be greater that one "
                msg += "for Mode \(mode)"
                call.reject(msg)
                return
            }
            if mode == "gallery" {
                guard (self?.implementation?.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil,
                      let collectionController = self?.implementation?
                        .collectionController else {
                    call.reject("Show : Unable to show the CollectionViewController")
                    return
                }
                collectionController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(collectionController,
                                                      animated: true, completion: {
                                                        call.resolve(["result": true])
                                                      })
            } else if mode == "one" {
                guard (self?.implementation?.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil,
                      let oneImageController = self?.implementation?
                        .oneImageController else {
                    call.reject("Show : Unable to show the OneImageViewController")
                    return
                }
                oneImageController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(oneImageController,
                                                      animated: true, completion: {
                                                        call.resolve(["result": true])
                                                      })

            } else if mode == "slider" {
                guard (self?.implementation?.show(imageList, mode: mode,
                                                  startFrom: startFrom,
                                                  options: options)) != nil,
                      let sliderController = self?.implementation?
                        .sliderController else {
                    call.reject("Show : Unable to show the SliderViewController")
                    return
                }
                sliderController.modalPresentationStyle = .fullScreen
                self?.bridge?.viewController?.present(sliderController, animated: true, completion: {
                    call.resolve(["result": true])
                })

            } else {
                call.reject("Show : Mode \(mode) not implemented")
            }
            return

        }

    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length

    @objc func saveImageFromHttpToInternal(_ call: CAPPluginCall) {
        guard let imageUrl = call.options["url"] as? String else {
            let error: String = "Must provide an image url"
            print(error)
            call.reject("SaveImageFromHttpToInternal : \(error)")
            return
        }
        guard let fileName = call.options["filename"] as? String else {
            let error: String = "Must provide an image filename"
            print(error)
            call.reject("SaveImageFromHttpToInternal : \(error)")
            return
        }
        DispatchQueue.global(qos: .background).async {
            do {
                try self.implementation?
                    .saveImageFromHttpToInternal(call, url: imageUrl,
                                                 fileName: fileName)
            } catch PhotoViewerError.failed(let message) {

                DispatchQueue.main.async {
                    call.reject("SaveImageFromHttpToInternal : \(message)")
                    return
                }
            } catch let error {
                DispatchQueue.main.async {
                    let msg = "SaveImageFromHttpToInternal : " +
                        "\(error.localizedDescription)"
                    call.reject("\(msg)")
                    return
                }
            }
        }
    }
    @objc func getInternalImagePaths(_ call: CAPPluginCall) {
        do {
            if let pathList: [String] = try self.implementation?
                .getInternalImagePaths() {
                call.resolve(["pathList": pathList])
                return
            } else {
                call.reject("GetInternalImagePaths : no image path list")
                return
            }
        } catch PhotoViewerError.failed(let message) {
            call.reject("GetInternalImagePaths : \(message)")
            return
        } catch let error {
            let msg = "GetInternalImagePaths : " +
                "\(error.localizedDescription)"
            call.reject("\(msg)")
            return
        }

    }
    @objc func addObserversToNotificationCenter() {
        // add Observers
        exitObserver = NotificationCenter
            .default.addObserver(forName: .photoviewerExit, object: nil,
                                 queue: nil,
                                 using: photoViewerExit)
    }

    // MARK: - photoViewerExit

    @objc func photoViewerExit(notification: Notification) {
        guard let info = notification.userInfo as? [String: Any] else { return }
        DispatchQueue.main.async {
            self.notifyListeners("jeepCapPhotoViewerExit", data: info, retainUntilConsumed: true)
            return
        }
    }

    private func photoviewerConfig() -> PhotoViewerConfig {
        var config = PhotoViewerConfig()
        let configPlugin = getConfig()
        if let iosImageLocation = configPlugin.getString("iosImageLocation") {
            config.iosImageLocation = iosImageLocation
        }
        return config
    }

}
