//
//  MarshalCell.m
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import "MarshalCell.h"

@implementation MarshalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.textLabel.font = [UIFont systemFontOfSize:24.f];
		self.textLabel.numberOfLines = 0;
		self.detailTextLabel.textColor = [UIColor blackColor];
		self.detailTextLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
	}
	return self;
}

- (void)setViewModel:(MarshalViewModel *)viewModel {
	_viewModel = viewModel;
	self.textLabel.text = viewModel.name;
	self.detailTextLabel.text = viewModel.detailTextString;
	self.accessoryType = viewModel.cellType;
}

@end
