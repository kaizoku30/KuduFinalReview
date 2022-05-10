import Foundation
import Alamofire
import SystemConfiguration

typealias SuccessCompletionBlock<T> = ( _ response: T ) -> Void
typealias FailureCompletionBlock = ( _ error: String ) -> Void
typealias ErrorFailureCompletionBlock = ( _ status: ResponseStatus ) -> Void

/// API request method used for all requests
struct Api {
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    static var session: Session?
    
    static func requestNew<T: Codable>(endpoint: Endpoint, successHandler: @escaping SuccessCompletionBlock<T>, failureHandler: @escaping ErrorFailureCompletionBlock) {
        if isConnectedToNetwork() {
            guard let url = URL(string: endpoint.path) else {
                failureHandler(.init(msg: "Error in request url"))
                return
            }
            let credentials = URLCredential()

            print("NEW REQUEST STARTED AT: \(Date())")
            
            let customRefreshRetrier: RequestRetrier & RequestAdapter = CustomRequestRetrier(endpoint: endpoint)
            let interceptor = Interceptor(adapter: customRefreshRetrier, retrier: customRefreshRetrier)
            AF.request(url,
                       method: endpoint.method,
                       parameters: endpoint.parameters,
                       encoding: endpoint.encoding,
                       headers: endpoint.header,
                       interceptor: interceptor)
                .validate(contentType: ["application/json"])
                .authenticate(with: credentials)
                .responseJSON { (response) in
                    if endpoint.method == .get && response.request?.url != nil {
                        debugPrint("Request GET URL with Parameters : \((response.request?.url)!)")
                    }
                    print("""
                          NEW REQUEST: \n\n Now: \(Date()) \n
                          Url: \(endpoint.path) \n Parameters: \(endpoint.parameters) \n Value: \n \
                          (String(describing: response.value)) \n Header: \(String(describing: endpoint.header)) \n
                          Validation Error: \(String(describing: response.error?.localizedDescription)) \n\n
                          """)
                    
                    switch response.result {
                    
                    case .failure(let error):
                        
                        let errorMessage = error.localizedDescription
                        failureHandler(.init(msg: errorMessage))
                        return
                        
                    case .success:
                        handleSuccessNew(response: response, successHandler: successHandler, failureHandler: failureHandler)
                    }
                }
        } else {
            failureHandler(.init(code: 100, msg: "No Internet Connection"))
        }
    }
    
    /// Parses response to the generic requested type
    static private func handleSuccessNew<T: Codable>(response: DataResponse<Any, AFError>, successHandler: @escaping SuccessCompletionBlock<T>, failureHandler: @escaping ErrorFailureCompletionBlock) {
        if let value = response.data {
            do {
                let emptyDataResponse = try JSONDecoder().decode(EmptyDataResponse.self, from: value)
                
               // let decodableObject = try JSONDecoder().decode(T.self, from: value)
             //   successHandler(decodableObject)
                
                // MARK: HANDLE DELETION/BLOCKED ACROSS APP AFTER CODES ARE PROVIDED FROM BACKEND
                // emptyDataResponse.statusCode == Constants.StatusCode.BLOCKED || emptyDataResponse.statusCode == Constants.StatusCode.DELETED ||
                if emptyDataResponse.type == "SESSION_EXPIRED" || emptyDataResponse.type == "INVALID_TOKEN" {
                   // NotificationCenter.postNotificationForObservers(.resetLoginState)
                    handleUserDeletedOrBlocked(msg: emptyDataResponse.message ?? "LS.Errors.somethingWentWrong")
                } else {
                    let decodableObject = try JSONDecoder().decode(T.self, from: value)
                    successHandler(decodableObject)
                }

            } catch let errorCaught {
               
                failureHandler(.init(msg: errorCaught.localizedDescription, errorObject: errorCaught as? DecodingError))
            }
        } else {
            failureHandler(.init(msg: "Unable to get body data"))
        }
    }
    
    static func handleUserDeletedOrBlocked(msg: String) {
        debugPrint("Handle Delete Response Here :\(msg)")
    }
    
    static func downloadFile(with url: URL, progressBlock: ((_ progress: CGFloat) -> Void)?, completion: ((_ url: URL?, _ error: Error?) -> Void)?) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask, options: .removePreviousFile)
        AF.download(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                // progress closure
                print("download", progress)
                progressBlock?(CGFloat(progress.fractionCompleted))
            }).response(completionHandler: { (defaultDownloadResponse) in
                // here you able to access the DefaultDownloadResponse
                // result closure
                completion?(defaultDownloadResponse.fileURL, defaultDownloadResponse.error)
//                print("url is ",defaultDownloadResponse.fileURL)
            })
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
