//
//  MarshalCell.h
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import <UIKit/UIKit.h>
#import "MarshalViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarshalCell : UITableViewCell

@property (nonatomic, strong) MarshalViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
