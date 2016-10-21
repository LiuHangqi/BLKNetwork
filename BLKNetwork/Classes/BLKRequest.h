//
//  BLKRequest.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLKRequest;

typedef void (^BLKRequestCompletionBlock)(__kindof BLKRequest *request);

@protocol AFMultipartFormData;

typedef void (^BLKConstructingBlock)(id<AFMultipartFormData> formData);

typedef NS_ENUM(NSUInteger, BLKRequestMethod) {
    
    BLKRequestMethodGET = 0,
    BLKRequestMethodPOST,
    BLKRequestMethodDELETE,
    BLKRequestMethodPUT
};

typedef NS_ENUM(NSUInteger, BLKRequestSerializerType) {
    
    BLKRequestSerializerTypeHTTP = 0,
    BLKRequestSerializerTypeJSON
};

typedef NS_ENUM(NSUInteger, BLKResponseSerializerType) {
    
    BLKResponseSerializerTypeHTTP = 0,
    BLKResponseSerializerTypeJSON
};

typedef NS_ENUM(NSUInteger, BLKRequestPriority) {
    BLKRequestPriorityLow = -4L,
    BLKRequestPriorityDefault = 0,
    BLKRequestPriorityHigh = 4,
};

@protocol BLKRequestProtocol <NSObject>

- (NSString*)baseUrl;

- (NSString*)requestUrl;

- (BLKRequestMethod)requestMethod;

- (NSDictionary*)httpHeaders;

- (NSDictionary*)parameters;

- (NSInteger)requestTimeoutInterval;

- (BLKRequestSerializerType)requestSerializer;

- (BLKResponseSerializerType)responseSerializer;

- (BLKRequestPriority)requestPriority;

- (BLKConstructingBlock)constructionBlock;

@end

@interface BLKRequest : NSObject<BLKRequestProtocol>

@property (nonatomic, strong) NSURLSessionTask *requestTask;

@property (nonatomic, strong) NSURLRequest  *originalRequest;

@property (nonatomic, strong) NSURLRequest *currentRequest;

@property (nonatomic, strong) NSHTTPURLResponse *response;

@property (nonatomic, assign) NSInteger responseStatusCode;

@property (nonatomic, strong) NSData *responseData;

@property (nonatomic, strong) id responseObject;

@property (nonatomic, strong) NSError *responseError;


#pragma mark -

- (void)requestCompleteFilter;

- (void)requestFaildFilter;


@end
