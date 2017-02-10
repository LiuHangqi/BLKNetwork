//
//  BLKNetworkPrivate.h
//  Pods
//
//  Created by liu on 2017/1/16.
//
//

#import <Foundation/Foundation.h>
#import "BLKBaseRequest.h"

@interface BLKBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@end
