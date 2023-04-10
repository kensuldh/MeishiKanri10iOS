import Foundation
import Combine
import Photos


final class PHAssetExtension{
    static let shared = PHAssetExtension()
    
    func getURL(ofPhotoWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
            
            if mPhasset.mediaType == .image {
                let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                    return true
                }
                mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                    completionHandler(contentEditingInput!.fullSizeImageURL)
                })
            } else if mPhasset.mediaType == .video {
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                options.version = .original
                PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
                    if let urlAsset = asset as? AVURLAsset {
                        let localVideoUrl = urlAsset.url
                        completionHandler(localVideoUrl)
                    } else {
                        completionHandler(nil)
                    }
                })
            }
            
        }
}
 extension PHAsset {
   enum Errors: Error {
       case urlNotAvailable
       case mediaNotSupported
   }
 }
