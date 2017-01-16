//
//  BLKNetworkAgent.h
//  Pods
//
//  Created by liu on 2017/1/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BLKBaseRequest;

@interface BLKNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedAgent;

- (void)addRequest:(BLKBaseRequest *)request;

- (void)cancelRequest:(BLKBaseRequest *)request;

- (void)cancelAllRequest;

NS_ASSUME_NONNULL_END

@end
