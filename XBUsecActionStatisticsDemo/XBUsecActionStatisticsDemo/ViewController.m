//
//  ViewController.m
//  XBUsecActionStatisticsDemo
//
//  Created by ios on 16/5/31.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "ViewController.h"
#import "nxbUserActionTool.h"

#import "Common.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    firstView.backgroundColor=XBRandomColor;
    firstView.tag=0;
    [firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)]];
    UIView *SecondView=[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, 120, 120)];
    SecondView.backgroundColor=XBRandomColor;
     [SecondView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)]];
    SecondView.tag=1;
    [self.view addSubview:firstView];
    [self.view addSubview:SecondView];
}
-(void)viewTap:(UITapGestureRecognizer *)gesture{
    if (gesture.view.tag==0) {
        //用户点击第一个，保存用户信息到本地数据库
        NSLog(@"用户点击了第一个view");
        [[nxbUserActionTool sharedUserActionTool].dataBaseQ inDatabase:^(FMDatabase *db) {
            [db executeUpdate:InsertUserAction(@"CurrentTime",[[nxbUserActionTool sharedUserActionTool] userId],[[nxbUserActionTool sharedUserActionTool]isanonymous], 3, 0, 4, 4,(long)0, 0, (long)0, @"deviceName")];
        }];
    }else if (gesture.view.tag==1){
        //用户点击第二个，保存用户信息到本地数据库
             NSLog(@"用户点击了第二个view");
        [[nxbUserActionTool sharedUserActionTool].dataBaseQ inDatabase:^(FMDatabase *db) {
            [db executeUpdate:InsertUserAction(@"CurrentTime",[[nxbUserActionTool sharedUserActionTool] userId],[[nxbUserActionTool sharedUserActionTool]isanonymous], 3, 0, 4, 4,(long)0, 0, (long)0, @"deviceName")];
        }];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    //发送统计数据给后台
    [[nxbUserActionTool sharedUserActionTool] SelectAllInfo];
}

@end
