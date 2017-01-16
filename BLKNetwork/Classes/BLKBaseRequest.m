//
//  BLKBaseRequest.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "BLKBaseRequest.h"

@implementation BLKBaseRequest

- (NSHTTPURLResponse *)response {
    
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    
    return self.response.statusCode;
}

- (BLKRequestMethod)requestMethod {
    
    return BLKRequestMethodPOST;
}

- (NSString *)baseUrl {
    
    return @"";
}

- (NSString *)requestUrl {
    
    return @"";
}

- (NSInteger)requestTimeoutInterval {
    
    return 60;
}

- (NSDictionary *)parameters {
    
    return nil;
}

- (NSDictionary *)httpHeaders {
    
    return nil;
}

- (BLKRequestSerializerType)requestSerializer {
    
    return BLKRequestSerializerTypeJSON;
}

- (BLKResponseSerializerType)responseSerializer {
    
    return BLKResponseSerializerTypeJSON;
}

- (BLKRequestPriority)requestPriority {
    
    return BLKRequestPriorityDefault;
}

- (NSURLRequest *)currentRequest {
    
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    
    return self.requestTask.originalRequest;
}

- (BLKConstructingBlock)constructionBlock {
    
    return nil;
}

- (void)requestCompleteFilter {}

- (void)requestFaildFilter {}

@end
