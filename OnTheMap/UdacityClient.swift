//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/6/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//


import Foundation

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {

    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    var currentUser: UdacityUser?
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: UdacityClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: UdacityClientError) {
                completionHandlerForGET(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(UdacityClientError.connectionFailed(method: "GET", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(UdacityClientError.noStatusCode(method: "GET"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(UdacityClientError.badStatusCode(code: String(statusCode)))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(UdacityClientError.noDataReturned)
                return
            }
            
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: UdacityClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue(UdacityClient.HeaderValues.Json, forHTTPHeaderField: UdacityClient.HeaderKeys.Accept)
        request.addValue(UdacityClient.HeaderValues.Json, forHTTPHeaderField: UdacityClient.HeaderKeys.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: UdacityClientError?) {
                completionHandlerForPOST(nil, error)
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(UdacityClientError.connectionFailed(method: "POST", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(UdacityClientError.noStatusCode(method: "POST"))
                return
            }
            
            /* GUARD: Did we get a 403 response? */
            guard statusCode != 403 else {
                sendError(.invalidIdOrPassword)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(UdacityClientError.badStatusCode(code: String(statusCode)))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(UdacityClientError.noDataReturned)
                return
            }
            
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(_ method: String, headerValues: [String:String], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: UdacityClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters([String:AnyObject](), withPathExtension: method))
        
        /* Set the header values */
        request.httpMethod = "DELETE"
        for (field, value) in headerValues {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: UdacityClientError) {
                completionHandlerForDELETE(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(UdacityClientError.connectionFailed(method: "DELETE", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(UdacityClientError.noStatusCode(method: "DELETE"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(UdacityClientError.badStatusCode(code: String(statusCode)))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(UdacityClientError.noDataReturned)
                return
            }
            
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error:  UdacityClientError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, .parseFailed(detail: String(describing: data)))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
