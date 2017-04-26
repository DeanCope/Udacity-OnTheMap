//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/12/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import Foundation

// MARK: - UdacityClient: NSObject

class ParseClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    var students = [StudentInformation]()
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func reset() {
        students = [StudentInformation]()
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: ParseClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        
        request.addValue(ParseClient.HeaderValues.AppId, forHTTPHeaderField: ParseClient.HeaderKeys.AppId)
        request.addValue(ParseClient.HeaderValues.APIKey, forHTTPHeaderField: ParseClient.HeaderKeys.APIKey)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: ParseClientError) {
                completionHandlerForGET(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(.connectionFailed(method: "GET", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(.noStatusCode(method: "GET"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(.badStatusCode(code: String(statusCode), url: method))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(.noDataReturned)
                return
            }
                        
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: ParseClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        
        request.addValue(ParseClient.HeaderValues.AppId, forHTTPHeaderField: ParseClient.HeaderKeys.AppId)
        request.addValue(ParseClient.HeaderValues.APIKey, forHTTPHeaderField: ParseClient.HeaderKeys.APIKey)
        request.addValue(ParseClient.HeaderValues.Json, forHTTPHeaderField: ParseClient.HeaderKeys.Accept)
        request.addValue(ParseClient.HeaderValues.Json, forHTTPHeaderField: ParseClient.HeaderKeys.ContentType)
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: ParseClientError) {
                completionHandlerForPOST(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(.connectionFailed(method: "POST", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(.noStatusCode(method: "POST"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(.badStatusCode(code: String(statusCode), url: method))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(.noDataReturned)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: ParseClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "PUT"
        
        request.addValue(ParseClient.HeaderValues.AppId, forHTTPHeaderField: ParseClient.HeaderKeys.AppId)
        request.addValue(ParseClient.HeaderValues.APIKey, forHTTPHeaderField: ParseClient.HeaderKeys.APIKey)
        request.addValue(ParseClient.HeaderValues.Json, forHTTPHeaderField: ParseClient.HeaderKeys.Accept)
        request.addValue(ParseClient.HeaderValues.Json, forHTTPHeaderField: ParseClient.HeaderKeys.ContentType)
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: ParseClientError) {
                completionHandlerForPUT(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(.connectionFailed(method: "PUT", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(.noStatusCode(method: "PUT"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(.badStatusCode(code: String(statusCode), url: method))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(.noDataReturned)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: DELETE
    
    func taskForDELETEMethod(_ method: String, headerValues: [String:String], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: ParseClientError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters([String:AnyObject](), withPathExtension: method))
        
        /* Set the header values */
        request.httpMethod = "DELETE"
        for (field, value) in headerValues {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: ParseClientError) {
                completionHandlerForDELETE(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(.connectionFailed(method: "DELETE", errorString: error!.localizedDescription))
                return
            }
            
            /* GUARD: Did we get a status code? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError(.noStatusCode(method: "DELETE"))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard statusCode >= 200 && statusCode <= 299 else {
                sendError(.badStatusCode(code: String(statusCode), url: method))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(.noDataReturned)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
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
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: ParseClientError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, .parseFailed(detail: String(describing: data)))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a PARSE URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

