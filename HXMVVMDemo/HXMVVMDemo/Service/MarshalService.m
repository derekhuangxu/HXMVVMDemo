//
//  MarshalService.m
//  HXMVVMDemo
//
//  Created by huangxu on 2019/5/14.
//

#import "MarshalService.h"

@implementation MarshalService

+ (MarshalService *)shareInstance
{
	static dispatch_once_t onceToken;
	static MarshalService *singleton = nil;
	dispatch_once(&onceToken, ^{
		singleton = [[MarshalService alloc] init];
	});
	return singleton;
}

- (void)fetchDataCompletion:(void(^)(NSArray <MarshalModel *>*data))completion failure:(void(^)(NSError* error))failure {
	
	//获取数据操作
	NSString *urlString = @"https://api.letsbuildthatapp.com/jsondecodable/courses";
	NSMutableArray *datas = [NSMutableArray array];
	NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:urlString]
																completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
																	if (error) {
																		failure(error);
																		return ;
																	}
																	NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
																	for (int i = 0; i < array.count; i++) {
																		NSDictionary *dataDic = array[i];
																		MarshalModel *model = [[MarshalModel alloc]init];
																		model.name = [dataDic objectForKey:@"name"];
																		model.lessonCount = [[dataDic objectForKey:@"number_of_lessons"]integerValue];
																		[datas addObject:model];
																	}
																	completion([datas copy]);
																}];
	[dataTask resume];
}

@end
