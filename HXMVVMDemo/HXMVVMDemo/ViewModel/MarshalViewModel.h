//
//  MarshalViewModel.h
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "MarshalModel.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MarshalViewModel : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *detailTextString;
@property (nonatomic, assign, readonly) UITableViewCellAccessoryType cellType;

- (instancetype)initWithModel:(MarshalModel *)model ;

@end

NS_ASSUME_NONNULL_END
