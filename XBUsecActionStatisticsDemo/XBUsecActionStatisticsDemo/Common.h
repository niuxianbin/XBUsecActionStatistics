//
//  Common.h
//  newbaichuanzhongyun
//
//  Created by ios on 16/3/10.
//  Copyright © 2016年 ios. All rights reserved.
//
//LOG日志配置-精确日志位置
#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
#define NSLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif
/**用户行为数据库字段 */
#define InsertUserAction(dateCreate,userId,anonymous,actionType,label,dataSource,pageId,tgtId,parentPageId,parentTgtId,DeviceName) [NSString stringWithFormat:@"INSERT INTO t_UserAction (dateCreate ,userId,anonymous,actionType,label,dataSource,pageId,tgtId,parentPageId,parentTgtId,device)VALUES('%@','%@',%d,%d,%d,%d,%d,%ld,%d,%ld,'%@')",dateCreate,userId,anonymous,actionType,label,dataSource,pageId,tgtId,parentPageId,parentTgtId,DeviceName]
/** RGB颜色 */
#define XBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/**  随机色 */
#define XBRandomColor XBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))