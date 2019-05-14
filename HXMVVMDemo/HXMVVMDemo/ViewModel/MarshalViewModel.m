//
//  MarshalViewModel.m
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import "MarshalViewModel.h"
@interface MarshalViewModel ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailTextString;
@property (nonatomic, assign) UITableViewCellAccessoryType cellType;

@end

@implementation MarshalViewModel

//依赖注入
- (instancetype)initWithModel:(MarshalModel *)model ; {
	if (self = [super init]) {
		self.name = model.name;
		if (model.lessonCount > 35) {
			self.detailTextString = @"多于30门课程";
			self.cellType = UITableViewCellAccessoryDetailDisclosureButton;
		} else {
			self.detailTextString = [NSString stringWithFormat:@"课程数量:%ld", (long)model.lessonCount];
			self.cellType = UITableViewCellAccessoryNone;
		}
	}
	return self;
}

@end
