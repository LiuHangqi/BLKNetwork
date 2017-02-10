//
//  BLKBaseRequest.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "BLKBaseRequest.h"
#import "BLKNetworkAgent.h"

@implementation BLKBaseRequest

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    
    return self.response.statusCode;
}

- (NSURLRequest *)currentRequest {
    
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    
    return self.requestTask.originalRequest;
}

- (NSDictionary *)responseHeaders {
    
    return self.response.allHeaderFields;
}

- (BOOL)isCancelled {
    
    if (!self.requestTask) {
        
        return NO;
    }
    
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    
    if (!self.requestTask) {
        
        return NO;
    }
    
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(BLKRequestCompletionBlock)success failure:(BLKRequestCompletionBlock)failure {
    
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

#pragma mark - Request Action;

- (void)start {
    
    [[BLKNetworkAgent sharedAgent] addRequest:self];
}

- (void)stop {
    
    [[BLKNetworkAgent sharedAgent] cancelRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(BLKRequestCompletionBlock)success failure:(BLKRequestCompletionBlock)failure {
    
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

#pragma mark - Subclass Override

- (void)requestSuccessPreprocessor {
}

- (void)requestSuccessFilter {
}

- (void)requestFaildPreprocessor {
}

- (void)requestFaildFilter {
}

- (NSString *)requestUrl {
    
    return @"";
}

- (NSString *)baseUrl {
    
    return @"";
}

- (NSInteger)requestTimeoutInterval {
    
    return 60;
}

- (id)requestParameters {
    
    return nil;
}

- (BLKRequestMethod)requestMethod {
    
    return BLKRequestMethodGET;
}

- (BLKRequestSerializerType)requestSerializer {
    
    return BLKRequestSerializerTypeHTTP;
}

- (BLKResponseSerializerType)responseSerializer {
    
    return BLKResponseSerializerTypeJSON;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    
    return nil;
}

- (NSURLRequest *)buildCustomRequest {
    
    return nil;
}

#pragma mark - NSObject
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestParameters];
}

@end
