//
//  nxbUserActionTool.m
//  newbaichuanzhongyun
//
//  Created by ios on 16/3/11.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "nxbUserActionTool.h"
#import <UIKit/UIKit.h>




@interface nxbUserActionTool ()
//参数模型
@property(nonatomic,assign)NSMutableArray *ParamStrArr;

@end

@implementation nxbUserActionTool
//网络访问工具单例
+ (instancetype)sharedUserActionTool {
    
    static nxbUserActionTool *_ActionToolManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _ActionToolManager=[[self alloc] init];

    });
    _ActionToolManager.ParamStrArr=[NSMutableArray array];
    return _ActionToolManager;
    
}
-(void)CreatDataBaseAndTable{
    //1.创建数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"UserAction.sqlite"];
    //创建数据库的队列(线程安全)
    FMDatabaseQueue *UserActiondataBaseQ = [FMDatabaseQueue databaseQueueWithPath:path];
    self.dataBaseQ = UserActiondataBaseQ;
    [UserActiondataBaseQ inDatabase:^(FMDatabase *db) {
    BOOL success = [db open];
    if (success) {
        //2.创建表(保留字段20个)
        NSString *str = @"CREATE TABLE IF NOT EXISTS t_UserAction(id INTEGER PRIMARY KEY AUTOINCREMENT, dateCreate TEXT NOT NULL, userId TEXT NOT NULL, anonymous integer NOT NULL, actionType integer NOT NULL, label integer NOT NULL, dataSource integer NOT NULL, pageId integer NOT NULL, tgtId integer NOT NULL, parentPageId integer NOT NULL, parentTgtId integer NOT NULL, device TEXT NOT NULL,Reserved0 integer,Reserved1 integer,Reserved2 integer,Reserved3 integer,Reserved4 integer,Reserved5 integer,Reserved6 integer,Reserved7 integer,Reserved8 integer,Reserved9 integer,Reserved10 integer,Reserved11 TEXT)";
        if ([db executeUpdate:str]) {
            NSLog(@"表创建成功!");
        }else{
            NSLog(@"创建表失败!");
        }
    }else{
        NSLog(@"数据库创建失败!");
    }
    }];

}
//返回用户的ID或者硬件的标识符（UUID）
-(NSString *)userId{
    //是否登录
    BOOL Islogin;
    if (Islogin) {
            return @"userID";
    }else{
        return [self getDeviceId];
    }
}
//是否是匿名浏览
-(int)isanonymous{
    //是否登录
    BOOL Islogin;
    if (Islogin) {
        return 0;
    }else{
        return 1;
    }
}
- (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
            NSLog(@"%@",currentDeviceUUIDStr);
    }
    NSLog(@"%@",currentDeviceUUIDStr);
    return currentDeviceUUIDStr;
}
//存储硬件设备信息
+(void)ResaveDevice{
     //DeviceInfo
}
//查找数据库信息发送后台
-(void)SelectAllInfo{
    NSString *strSql =  @"SELECT * FROM t_UserAction";
    NSMutableArray *arr=[NSMutableArray array];
     NSMutableArray *TempDataArrM=[NSMutableArray array];
    NSMutableArray *TempDataArrM1=[NSMutableArray array];
    NSMutableArray *ParamStr=[NSMutableArray array];
    //查询语句  执行的方法
    [self.dataBaseQ inDatabase:^(FMDatabase *db) {
        FMResultSet *set =[db executeQuery:strSql];
        while ([set next]) {
            //dateCreate
            NSString *dateCreate = [set stringForColumn:@"dateCreate"];
            //userId
            NSString *userId= [set stringForColumn:@"userId"];
            //dateCreate
            int anonymous = [set boolForColumn:@"anonymous"];
            //actionType
            int actionType = [set intForColumn:@"actionType"];
            //label
            int label = [set intForColumn:@"label"];
            //dataSource
           int dataSource = [set intForColumn:@"dataSource"];
            //pageId
            int pageId = [set intForColumn:@"pageId"];
            //tgtId
            long tgtId = [set longForColumn:@"tgtId"];
            //parentPageId
           int parentPageId = [set intForColumn:@"parentPageId"];
            //parentTgtId
            long parentTgtId = [set longForColumn:@"parentTgtId"];
            //device
            NSString *device = [set stringForColumn:@"device"];
            [TempDataArrM addObject:dateCreate];
            [TempDataArrM1 addObject:dateCreate];

           NSString *TempParamStr=[NSString stringWithFormat:@"{\"dateCreate\":\"%@\",\"userId\":\"%@\",\"anonymous\":%d,\"actionType\":%d,\"label\":%d,\"dataSource\":%d,\"pageId\":%d,\"tgtId\":%ld,\"parentPageId\":%d,\"parentTgtId\":%ld,\"device\":\"%@\",\"channel\":\"app_store\"}",dateCreate,userId,anonymous,actionType,label,dataSource,pageId,tgtId,parentPageId,parentTgtId,device];
            [arr addObject:TempParamStr];
            [ParamStr addObject:TempParamStr];
            // 发送一条记录给后台，后台提供接口，
           //发送成功后删除一条记
            [self DeleteTheRecord:dateCreate];
    
        }
    }];
}
//删除一条记录
-(void)DeleteTheRecord:(NSString *)dateCreate{
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete  from t_UserAction where dateCreate = '%@'",dateCreate];
    [self.dataBaseQ inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:deleteSql];
        if (res) {
            NSLog(@"发送完成，删除表中一条数据");
        }else{
            NSLog(@"发送失败，删除表中一条数据失败!");
        }
    }];
    
}
@end
