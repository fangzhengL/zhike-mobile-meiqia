//
//  ZKMeqiaBasicChatManager.m
//  toeflios
//
//  Created by wansong.mbp.work on 07/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "ZKMeqiaBasicChatManager.h"
#import "UIViewController+Utility.h"
#import <Masonry.h>

#import "MQChatViewManager.h"
#import "MQChatDeviceUtil.h"
#import <MeiQiaSDK/MeiqiaSDK.h>

@interface ZKMeqiaBasicChatManager()
@end

@implementation ZKMeqiaBasicChatManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initMeqiaWithKey:(NSString*)appKey
                  callback:(RCTResponseSenderBlock)callback){
  dispatch_async(dispatch_get_main_queue(), ^{
    [MQManager initWithAppkey:appKey completion:^(NSString *clientId, NSError *error) {
      if (!error) {
        NSLog(@"美洽 SDK：初始化成功");
        if (callback) {
          callback(@[[NSNull null]]);
        }
      } else {
        NSLog(@"error:%@",error);
        if (callback) {
          callback(@[error.localizedDescription ?: @"unknown"]);
        }
      }
    }];
  });
}

RCT_EXPORT_METHOD(showChatView:(NSString*)clientId
                  assignToGroup:(NSString*)groupId
                  userInfo:(NSDictionary*)userInfo
                  callback:(RCTResponseSenderBlock)callback){
  dispatch_async(dispatch_get_main_queue(), ^{
    if (callback) {
      if (clientId) {
        callback(@[[NSNull null]]);
      } else {
        callback(@[@"no client id"]);
      }
    }
    UIViewController *topViewController = [UIViewController currentViewController];
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    if (userInfo) {
      [chatViewManager setClientInfo:@{@"name":userInfo[@"nickname"] ?: @"", @"tel":userInfo[@"phone"] ?: @""} override:YES];
    }
    if (clientId) {
      [chatViewManager setLoginCustomizedId:clientId ?: @""];
    }
    [chatViewManager setScheduledGroupId:groupId];
    
      NSDate * date = [NSDate date];
      NSTimeInterval sec = [date timeIntervalSinceNow];
      NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];

    
          //设置时间输出格式：
      NSDateFormatter * df = [[NSDateFormatter alloc] init ];
      [df setDateFormat:@"yyyy年MM月dd日"];
      NSString * na = [df stringFromDate:currentDate];
      
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      BOOL hasRan = [defaults boolForKey:na];

      if (!userInfo) {
          
      }else if(!hasRan){
          [defaults setBool:YES forKey:na];
          UIWindow *win = [UIApplication sharedApplication].keyWindow;
          UIView *view = [[UIView alloc] init];
          view.frame = [UIScreen mainScreen].bounds;
          view.backgroundColor = [UIColor blackColor];
          view.alpha = 0.5;
          UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast"]];
          [imgV sizeToFit];
          [win addSubview:view];
          [win addSubview:imgV];
          [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerX.equalTo(view);
              make.centerY.equalTo(view).offset(-50);
          }];
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [view removeFromSuperview];
              [imgV removeFromSuperview];
          });
      }

    
    
    [chatViewManager setRecordMode:MQRecordModeDuckOther];
    [chatViewManager setPlayMode:MQPlayModeMixWithOther];
    
    [chatViewManager pushMQChatViewControllerInViewController:topViewController];
    if (userInfo[@"avatar"]) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:userInfo[@"avatar"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
        if (image) {
          [chatViewManager setoutgoingDefaultAvatarImage:image];
        }
      });
    }
  });
}

@end
