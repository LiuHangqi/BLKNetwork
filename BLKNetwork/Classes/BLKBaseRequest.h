//
//  BLKBaseRequest.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLKRequest;


@protocol AFMultipartFormData;

typedef NS_ENUM(NSUInteger, BLKRequestMethod) {
    
    BLKRequestMethodGET = 0,
    BLKRequestMethodPOST,
    BLKRequestMethodHEAD,
    BLKRequestMethodPUT,
    BLKRequestMethodDELETE,
    BLKRequestMethodPATCH
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

typedef void (^BLKConstructingBlock)(id<AFMultipartFormData> formData);
//typedef void (^BLKURLSessionTaskProgressBlock)(NSProgress *progress);

@class BLKBaseRequest;

typedef void (^BLKRequestCompletionBlock)(__kindof BLKRequest *request);


@interface BLKBaseRequest : NSObject

#pragma mark - Request and Response Information

@property (nonatomic, strong) NSURLSessionTask *requestTask;
@property (nonatomic, strong) NSURLRequest  *originalRequest;
@property (nonatomic, strong) NSURLRequest *currentRequest;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, assign) NSInteger responseStatusCode;
@property (nonatomic, strong) NSDictionary *responseHeaders;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) id responseJSONObject;
@property (nonatomic, getter=isCancelled) BOOL cancelled;
@property (nonatomic, getter=isExecuting) BOOL executiong;

#pragma mark - RequestConfiguration

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, copy) BLKRequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy) BLKRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, copy) BLKConstructingBlock constructingBodyBlock;

@property (nonatomic, assign) BLKRequestPriority requestPriority;

- (void)setCompletionBlockWithSuccess:(BLKRequestCompletionBlock)success
                              failure:(BLKRequestCompletionBlock)failure;

- (void)clearCompletionBlock;

#pragma mark - Request Action

- (void)start;

- (void)stop;

- (void)startWithCompletionBlockWithSuccess:(BLKRequestCompletionBlock)success
                                    failure:(BLKRequestCompletionBlock)failure;

#pragma mark - Subclass Override

- (void)requestSuccessPreprocessor;

- (void)requestSuccessFilter;

- (void)requestFaildPreprocessor;

- (void)requestFaildFilter;

- (NSString*)baseUrl;

- (NSString*)requestUrl;

- (BLKRequestMethod)requestMethod;

- (NSDictionary*)requestHeaderFieldValueDictionary;

- (NSURLRequest *)buildCustomRequest;

- (id)requestParameters;

- (NSInteger)requestTimeoutInterval;

- (BLKRequestSerializerType)requestSerializer;

- (BLKResponseSerializerType)responseSerializer;

- (BLKRequestPriority)requestPriority;

@end
