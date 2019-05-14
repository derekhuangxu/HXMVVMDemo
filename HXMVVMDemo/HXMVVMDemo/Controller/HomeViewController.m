//
//  HomeViewController.m
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import "HomeViewController.h"
#import "MarshalCell.h"
#import "MarshalViewModel.h"
#import "MarshalService.h"

static NSString * const kMarshalCellIdentifier = @"MarshalCell";

@interface HomeViewController () <
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <MarshalViewModel *>*viewModels;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setNavbar];
	[self getData];
}

#pragma mark - UITableView Delegate/Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MarshalCell *cell = [[MarshalCell alloc] initWithStyle: UITableViewCellStyleSubtitle
										   reuseIdentifier: kMarshalCellIdentifier];
	cell.viewModel = self.viewModels[indexPath.row];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.viewModels.count;
}

#pragma mark - Pravite Tools

- (void)setNavbar{

	self.navigationItem.title = @"MVVM";
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.barTintColor = [self rgbWithR:50 G:199 B:242];
	[self.navigationController.navigationBar setLargeTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
																		  NSForegroundColorAttributeName,
																		  [UIFont systemFontOfSize:40.0f]
																		  ,NSFontAttributeName,nil]];
}

- (void)getData {
	[[MarshalService shareInstance]fetchDataCompletion:^(NSArray<MarshalModel *> * _Nonnull data) {
		self.viewModels = [self viewModelsWithDatas:[data mutableCopy]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
		});
	} failure:^(NSError * _Nonnull error) {
		NSLog(@"Failed to fetch courses:%@", error);
	}];
}

- (UIColor *)rgbWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
	return [UIColor colorWithRed:r/250 green:g/250 blue:b/250 alpha:1];
}

- (NSMutableArray *)viewModelsWithDatas:(NSArray *)datas {
	if (!_viewModels) {
		_viewModels = [NSMutableArray array];
		for (int i = 0; i < datas.count; i++) {
			MarshalModel *model = datas[i];
			MarshalViewModel *viewModel = [[MarshalViewModel alloc]initWithModel:model];
			[_viewModels addObject:viewModel];
		}
	}
	return _viewModels;
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
		[self.view addSubview:_tableView];
		_tableView.backgroundColor = [UIColor whiteColor];
		_tableView.estimatedRowHeight = 80.f;
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView registerClass:[MarshalCell class] forCellReuseIdentifier:kMarshalCellIdentifier];
	}
	return _tableView;
}

@end
