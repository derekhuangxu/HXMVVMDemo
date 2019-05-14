//
//  MarshalService.h
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "MarshalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarshalService : NSObject

+ (MarshalService *)shareInstance;

- (void)fetchDataCompletion:(void(^)(NSArray <MarshalModel *>*data))completion failure:(void(^)(NSError* error))failure;

@end

NS_ASSUME_NONNULL_END
