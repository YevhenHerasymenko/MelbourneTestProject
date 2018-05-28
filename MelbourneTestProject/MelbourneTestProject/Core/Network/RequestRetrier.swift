//
//  RequestRetrier.swift
//  MelbourneTestProject
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import Alamofire
import MelbourneTestProjectCore

class RequestRetrier: Alamofire.RequestRetrier {
    
    func should(_ manager: Alamofire.SessionManager,
                retry request: Alamofire.Request,
                with error: Error,
                completion: @escaping Alamofire.RequestRetryCompletion) {
        guard request.retryCount < 3 else {
            completion(false, 0)
            return
        }
        if error is NetworkError {
            completion(false, 0)
            return
        }
        completion(true, 0)
    }
    
}
