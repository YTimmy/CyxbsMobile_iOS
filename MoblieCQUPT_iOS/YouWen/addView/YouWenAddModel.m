//
//  YouWenAddModel.m
//  MoblieCQUPT_iOS
//
//  Created by xiaogou134 on 2018/4/14.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "YouWenAddModel.h"
#import "MyInfoModel.h"
#import "NetWork.h"
#define URL @"https://wx.idsbllp.cn/springtest/cyxbsMobile/index.php/QA/Question/add"
#define IMGURL @"https://wx.idsbllp.cn/springtest/cyxbsMobile/index.php/QA/Question/uploadPicture"

@interface YouWenAddModel()
@property (copy, nonatomic) NSDictionary *inf;
@property (copy, nonatomic) NSArray *imageArry;
@end
@implementation YouWenAddModel

-(instancetype)initWithInformation:(NSDictionary *)inf andImage:(NSArray *)imgs{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dic = @{@"stuNum":[userDefaults objectForKey:@"stuNum"],@"idNum":[userDefaults objectForKey:@"idNum"]}.mutableCopy;
        [dic addEntriesFromDictionary:inf];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         NSDateFormatter *beforeFormatter = [[NSDateFormatter alloc] init];
        beforeFormatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
        NSDate *date = [beforeFormatter dateFromString:(NSString *)dic[@"disappear_time"]];
        dic[@"disappear_time"] = [formatter stringFromDate:date];
        _inf = [[NSDictionary alloc] initWithDictionary:dic.copy];
        _imageArry = imgs.copy;
    }
    return self;
}
-(void)postTheNewInformation{
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:URL method:HttpRequestPost parameters:_inf prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *qusId = responseObject[@"data"][@"id"];
        if (_imageArry.count){
            [self postTheImageWithId:qusId];
        }
        else{
            [self.delegate missionComplete];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)postTheImageWithId:(NSString *)qusId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = @{@"stuNum":[userDefaults objectForKey:@"stuNum"],@"idNum":[userDefaults objectForKey:@"idNum"]}.mutableCopy;
    
    dic[@"question_id"] = qusId;
    NSMutableArray<MOHImageParamModel*> *imgs = [NSMutableArray array];
    for (int i = 1; i <= _imageArry.count; i++) {
        MOHImageParamModel *model = [[MOHImageParamModel alloc] init];
        model.paramName = [NSString stringWithFormat:@"photo%d", i];;
        model.uploadImage = _imageArry[i - 1];
        [imgs addObject:model];
    }
    [NetWork uploadImageWithUrl:IMGURL imageParams:@[imgs[0]] otherParams:dic imageQualityRate:1 successBlock:^(id returnValue) {
        [self.delegate missionComplete];
    } failureBlock:^{
        NSLog(@"I have fail");
    }];
}
@end