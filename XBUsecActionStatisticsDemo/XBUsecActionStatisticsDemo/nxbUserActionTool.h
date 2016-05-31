//
//  nxbUserActionTool.h
//  newbaichuanzhongyun
//
//  Created by ios on 16/3/11.
//  Copyright © 2016年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain.h>
#import <FMDB.h>

@interface nxbUserActionTool : NSObject
//线程安全的数据库
@property (nonatomic,strong)FMDatabaseQueue *dataBaseQ;
//单例
+ (instancetype)sharedUserActionTool;
//数据表
-(void)CreatDataBaseAndTable;
//UUID
- (NSString *)getDeviceId;
//存储硬件设备信息
+(void)ResaveDevice;
//返回用户的ID或者硬件的标识符（UUID）
-(NSString *)userId;
//是否是匿名浏览
-(int)isanonymous;
//查找数据库信息发送后台
-(void)SelectAllInfo;
@end
