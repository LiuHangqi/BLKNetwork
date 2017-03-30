//
//  BLKNetworkAgent.m
//  Pods
//
//  Created by liu on 2017/1/16.
//
//

#import "BLKNetworkAgent.h"
#import "BLKNetworkConfig.h"
#import <pthread/pthread.h>
#import "BLKBaseRequest.h"
//#import "BLKNetworkPrivate.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@implementation BLKNetworkAgent {
    AFHTTPSessionManager *_manager;
    BLKNetworkConfig *_config;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    NSMutableDictionary<NSNumber *, BLKBaseRequest *> *_requestsRecord;
    
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

+ (instancetype)sharedAgent {
    
    static id sharedAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgent = [[self alloc] init];
    });
    
    return sharedAgent;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _config = [BLKNetworkConfig sharedConfig];
        _manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:_config.sessionConfiguration];
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.blkee.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        
        _manager.securityPolicy = _config.securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
        _manager.completionQueue = _processingQueue;
    }
    
    return self;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    
    if (!_jsonResponseSerializer) {
        
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
    }
    
    return _jsonResponseSerializer;
}

#pragma mark - 

- (NSString *)buildRequestUrl:(BLKBaseRequest *)request {
    
    NSParameterAssert(request != nil);
    
    NSString *detailUrl = [request requestUrl];
    NSURL *temp = [NSURL URLWithString:detailUrl];
    
    if (temp && temp.host && temp.scheme) {
        
        return detailUrl;
    }
    
    if (_config.urlFilter) {
        
        detailUrl = [_config.urlFilter filterUrl:detailUrl withRequest:request];
    }
    
    NSString *baseUrl = [request baseUrl];
    NSURL *url = [NSURL URLWithString:baseUrl];
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        
        url = [url URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:detailUrl relativeToURL:url].absoluteString;
}

- (id)buildRequestParamters:(BLKBaseRequest *)request {

    if (_config.parameterFilter) {

        return [_config.parameterFilter filterParameter:request.requestParameters withRequest:request];
    }
    return request.requestParameters;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(BLKBaseRequest *)request {
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializer == BLKRequestSerializerTypeHTTP) {
        
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializer == BLKRequestSerializerTypeJSON) {
        
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionay = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionay != nil) {
        
        for (NSString *httpHeaderField in headerFieldValueDictionay.allKeys) {
            
            NSString *value = headerFieldValueDictionay[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    return requestSerializer;
}

- (NSURLSessionTask *)sessionTaskForRequest:(__kindof BLKBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    
    BLKRequestMethod method = [request requestMethod];
    NSString *url = [self buildRequestUrl:request];

    id param = [self buildRequestParamters:request];
    BLKConstructingBlock construtingBlock = [request constructingBodyBlock];

    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    switch (method) {
        case BLKRequestMethodGET:
        {
            if (construtingBlock) {
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param constructionBodyWithBlock:construtingBlock error:error];
            }else {
                return [self dataTaskWithHttpMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            }
        }
        case BLKRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructionBodyWithBlock:construtingBlock error:error];
        case BLKRequestMethodHEAD:
            return [self dataTaskWithHttpMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case BLKRequestMethodPUT:
            return [self dataTaskWithHttpMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case BLKRequestMethodDELETE:
            return [self dataTaskWithHttpMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case BLKRequestMethodPATCH:
            return [self dataTaskWithHttpMethod:@"PATCH" requestSerializer:requestSerializer URLString:url parameters:param error:error];
    }
}

- (void)addRequest:(__kindof BLKBaseRequest *)request {
    
    NSParameterAssert(request != nil);
    NSError * __autoreleasing requestSerializationError = nil;
    
    NSURLRequest *customRequest = [request buildCustomRequest];
    if (customRequest) {
        
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [_manager dataTaskWithRequest:customRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            [self handleRequestResult:dataTask responseObject:responseObject error:error];
        }];
        request.requestTask = dataTask;
    }else {
        
        request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    }
    
    if (requestSerializationError) {
        
        [self requestDidFaildWithRequest:request error:requestSerializationError];
        return;
    }
    
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    
    if ([request.requestTask respondsToSelector:@selector(priority)]) {
        
        switch ([request requestPriority]) {
            case BLKRequestPriorityHigh:
                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
                break;
            case BLKRequestPriorityLow:
                request.requestTask.priority = NSURLSessionTaskPriorityLow;
                break;
            case BLKRequestPriorityDefault:
                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
                break;
        }
    }
    
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (void)cancelRequest:(__kindof BLKBaseRequest *)request {
    
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequest {
    
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        
        NSArray *copyKeys = [allKeys copy];
        for (NSNumber *key in copyKeys) {
            
            Lock();
            BLKBaseRequest *request = _requestsRecord[key];
            Unlock();
            [request stop];
        }
    }
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    
    Lock();
    BLKBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if (!request) {
        
        return;
    }
    
    NSError *__autoreleasing serializationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        
        request.responseData = responseObject;
        request.responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        switch (request.responseSerializer) {
            case BLKResponseSerializerTypeHTTP:
                
                break;
            case BLKResponseSerializerTypeJSON:
                request.responseObject = [[self jsonResponseSerializer]responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
            break;
        }
    }
    
    if (error) {
        
        succeed = NO;
        requestError = error; 
    } else if (serializationError) {
        
        succeed = NO;
        requestError = serializationError;
    }else {
        
        succeed = YES;
        requestError = nil;
    }
    
    if (succeed) {
        
        [self requestDidSuccessWithRequest:request];
    }else {
        
        [self requestDidFaildWithRequest:request error:requestError];
    }
}

- (void)requestDidSuccessWithRequest:(__kindof BLKBaseRequest *)request {
   
   if (_config.requestSuccessFilter) {
        
        BOOL successed = [_config.requestSuccessFilter filterSuccessWithRequest:request];
        if (!successed) {
            
            [self requestDidFaildWithRequest:request error:request.error];
            return;
        }
    }
    
    @autoreleasepool {
        
        [request requestSuccessPreprocessor];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [request requestSuccessFilter];
        if (request.successCompletionBlock) {
            
            request.successCompletionBlock(request);
        }
    });
}

- (void)requestDidFaildWithRequest:(__kindof BLKBaseRequest *)request error:(NSError *)error {
    
    request.error = error;
    @autoreleasepool {
        
        [request requestFaildPreprocessor];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [request requestFaildFilter];
        if (request.failureCompletionBlock) {
            
            request.failureCompletionBlock(request);
        }
    }); 
}

#pragma mark -
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)urlString
                                      parameters:(id)parameters
                       constructionBodyWithBlock:(BLKConstructingBlock)block
                                           error:(NSError *_Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *request = nil;
    
    if (block) {
        
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:parameters constructingBodyWithBlock:block error:error];
    }else {
        
        request = [requestSerializer requestWithMethod:method URLString:urlString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHttpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)urlString
                                      parameters:(id)parameters
                                           error:(NSError *_Nullable __autoreleasing *)error {
    
    return [self dataTaskWithHTTPMethod:method requestSerializer:requestSerializer URLString:urlString parameters:parameters constructionBodyWithBlock:nil error:error];
}

#pragma mark - 
- (void)addRequestToRecord:(__kindof BLKBaseRequest *)request {
    
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(__kindof BLKBaseRequest *)request {
    
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = nil;
    Unlock();
}

@end
