//
//  BLKRequestQueue.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "BLKRequestQueue.h"
#import "AFNetworking.h"

@interface BLKRequestQueue ()

@property (nonatomic, strong) NSMutableDictionary *requestQueue;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) NSMutableDictionary *requestSuccessBlockRecorders;
@property (nonatomic, strong) NSMutableDictionary *requestFailureBlockRecorders;

@end

@implementation BLKRequestQueue {
    
    NSIndexSet *_allStatusCodes;
}

- (instancetype)initWithConfig:(BLKRequestQueueConfig *)config {
    
    self = [self init];
    self.config = config;
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    }
    
    return self;
}

- (void)startRequest:(BLKRequest *)request success:(BLKRequestCompletionBlock)success failure:(BLKRequestCompletionBlock)failure {
    
    NSError *error = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&error];
    if (error) {
        
        [self requestDidFailWithRequest:request error:error];
        return;
    }
    switch ([request requestPriority]) {
        case BLKRequestPriorityDefault:
            request.requestTask.priority = NSURLSessionTaskPriorityDefault;
            break;
        case BLKRequestPriorityLow:
            request.requestTask.priority = NSURLSessionTaskPriorityLow;
            break;
        case BLKRequestPriorityHigh:
            request.requestTask.priority = NSURLSessionTaskPriorityHigh;
            break;
        default:
            request.requestTask.priority = NSURLSessionTaskPriorityDefault;
            break;
    }
    
    [self addRequest:request successBlock:success failureBlock:failure];
    [request.requestTask resume];
}

- (void)cancelRequest:(BLKRequest *)request {
    
    [request.requestTask cancel];
    [self removeRequest:request];
}

- (void)cancelAllRequest {
    
    for (BLKRequest *request in self.requestQueue.allValues) {
        
        [self cancelRequest:request];
    }
}

- (void)addRequest:(BLKRequest *)request successBlock:(BLKRequestCompletionBlock)complete failureBlock:(BLKRequestCompletionBlock)faild {
    
    [self addRequestToQueue:request];
    [self addSuccessBlockToRecorders:complete forRequest:request];
    [self addFailureBlockToRecorders:faild forRequest:request];
}

- (void)removeRequest:(BLKRequest *)request {
    
    [self removeRequestFromQueue:request];
    [self removeSuccessBlockRecorderForRequest:request];
    [self removeFailureBlockRecorderForRequest:request];
}

- (void)addRequestToQueue:(BLKRequest *)request {
    
    if (request.requestTask == nil) {
        
        return;
    }
    
    @synchronized (self) {
        
        self.requestQueue[@(request.requestTask.taskIdentifier)] = request;
        NSLog(@"Add request:%@",NSStringFromClass([request class]));
    };
}

- (void)removeRequestFromQueue:(BLKRequest *)request {
    
    @synchronized (self) {
        
        [self.requestQueue removeObjectForKey:@(request.requestTask.taskIdentifier)];
        NSLog(@"Request queue size = %zd",self.requestQueue.count);
    };
}

- (void)addSuccessBlockToRecorders:(BLKRequestCompletionBlock)complete forRequest:(BLKRequest *)request{
    
    if (complete) {
        
        @synchronized (self) {
            
            self.requestSuccessBlockRecorders[@(request.requestTask.taskIdentifier)] = complete;
        };
    }
    
}

- (void)removeSuccessBlockRecorderForRequest:(BLKRequest *)request {
    
    @synchronized (self) {
        
        self.requestSuccessBlockRecorders[@(request.requestTask.taskIdentifier)] = nil;
    };
}

- (void)addFailureBlockToRecorders:(BLKRequestCompletionBlock)faild forRequest:(BLKRequest *)request {
    
    if (faild) {
        
        @synchronized (self) {
            
            self.requestFailureBlockRecorders[@(request.requestTask.taskIdentifier)] = faild;
        }
    }
}

- (void)removeFailureBlockRecorderForRequest:(BLKRequest *)request {
    
    @synchronized (self) {
        
        self.requestFailureBlockRecorders[@(request.requestTask.taskIdentifier)] = nil;
    };
}

- (void)setupHttpHeaders:(NSDictionary *)httpHeaders {
    
    if (httpHeaders) {
        
        for (id httpHeaderField in httpHeaders.allKeys) {
            
            id value = httpHeaders[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                
                [self.sessionManager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                
                NSAssert(NO,@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
}

#pragma mark -

- (NSURLSessionTask *)sessionTaskForRequest:(BLKRequest *)request error:(NSError **)error {
    
    BLKRequestMethod method = [request requestMethod];
    NSString *url = [self urlForRequest:request];
    NSDictionary *parameters = [self parametersForRequest:request];
    BLKConstructingBlock constructingBlock = [request constructionBlock];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    [self setupHttpHeaders:[request httpHeaders]];
    switch (method) {
        case BLKRequestMethodGET:
            return [self dataTaskWithHttpMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:parameters error:error];
            break;
        case BLKRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:parameters constructingBodyWithBlock:constructingBlock error:error];
            break;
        case BLKRequestMethodPUT:
            return [self dataTaskWithHttpMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:parameters error:error];
            break;
        case BLKRequestMethodDELETE:
            return [self dataTaskWithHttpMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:parameters error:error];
            break;
    }
}

- (NSURLSessionDataTask *)dataTaskWithHttpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                           error:(NSError **)error {
    
    return [self dataTaskWithHTTPMethod:method requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError **)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          
                                          [self handleRequestResult:dataTask response:response responseObject:responseObject error:error];
                                      }];
    
    return dataTask;
}


- (AFHTTPRequestSerializer *)requestSerializerForRequest:(BLKRequest *)request{
    
    AFHTTPRequestSerializer *serializer = nil;
    if (request.requestSerializer == BLKRequestSerializerTypeHTTP) {
        
        serializer = [AFHTTPRequestSerializer serializer];
    }else if (request.requestSerializer == BLKRequestSerializerTypeJSON) {
        
        serializer = [AFJSONRequestSerializer serializer];
    }
    
    return serializer;
}

- (NSString *)urlForRequest:(BLKRequest *)request {
    
    NSString *baseUrl = [request baseUrl];
    NSString *requestUrl = [request requestUrl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",baseUrl,requestUrl];
    if (self.config && self.config.urlFilter) {
        
        url = [self.config.urlFilter filterUrl:url withRequest:request];
    }
    return url;
}

- (NSDictionary *)parametersForRequest:(BLKRequest *)request {
    
    NSDictionary *parameters = [request parameters];
    if (self.config && self.config.parameterFilter) {
        
        parameters = [self.config.parameterFilter filterParameter:parameters withRequest:request];
    }
    
    return parameters;
}

- (void)handleRequestResult:(NSURLSessionTask *)task response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    
    BLKRequest *request = nil;
    @synchronized (self) {
        
        request = self.requestQueue[@(task.taskIdentifier)];
    }
    if (!request) {
        
        return;
    }
    NSLog(@"Finish Request: %@",NSStringFromClass([request class]));
    
    NSError *serializationError = nil;
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        
        request.responseData = responseObject;
        
        switch (request.responseSerializer) {
            case BLKResponseSerializerTypeHTTP:
                
                break;
            case BLKResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
        }
    }
    
    if (error) {
        
        succeed = NO;
        requestError = error;
    }else if (serializationError) {
        
        succeed = NO;
        requestError = serializationError;
    }else {
        
        succeed = YES;
    }
    
    if (succeed) {
        
        [self requestDidSuccessWithRequest:request];
    }else {
        
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    [self removeRequest:request];

}

- (void)requestDidSuccessWithRequest:(BLKRequest *)request {
    
    if (self.config && self.config.requestSuccessFilter) {
        
        BOOL success = [self.config.requestSuccessFilter filterSuccessWithRequest:request];
        
        if (!success) {
            
            [self requestDidFailWithRequest:request error:nil];
            return;
        }
    }
    
    [request requestCompleteFilter];
    BLKRequestCompletionBlock success = self.requestSuccessBlockRecorders[@(request.requestTask.taskIdentifier)];
    if (success) {
        
        success(request);
    }
}

- (void)requestDidFailWithRequest:(BLKRequest *)request error:(NSError *)error {
    
    if (error) {
        
        request.responseError = error;
    }
    [request requestFaildFilter];
    BLKRequestCompletionBlock failure = self.requestFailureBlockRecorders[@(request.requestTask.taskIdentifier)];
    if (failure) {
        
        failure(request);
    }
}

#pragma mark -

- (NSMutableDictionary *)requestQueue {
    
    if (!_requestQueue) {
        
        _requestQueue = [[NSMutableDictionary alloc]init];
    }
    
    return _requestQueue;
}

- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
    }
    
    return _sessionManager;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    
    if (!_jsonResponseSerializer) {
        
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
    }
    
    return _jsonResponseSerializer;
}

- (NSMutableDictionary *)requestSuccessBlockRecorders {
    
    if (!_requestSuccessBlockRecorders) {
        
        _requestSuccessBlockRecorders = [[NSMutableDictionary alloc]init];
    }
    return _requestSuccessBlockRecorders;
}

- (NSMutableDictionary *)requestFailureBlockRecorders {
    
    if (!_requestFailureBlockRecorders) {
        
        _requestFailureBlockRecorders = [[NSMutableDictionary alloc]init];
    }
    
    return _requestFailureBlockRecorders;
}

@end