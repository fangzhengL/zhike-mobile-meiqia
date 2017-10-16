//
//  ZKMeqiaBasicChatManager.m
//  toeflios
//
//  Created by wansong.mbp.work on 07/01/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "ZKMeqiaBasicChatManager.h"
#import "UIViewController+Utility.h"

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
    //    [chatViewManager setPreSendMessages:@[@"message1"]];
    //   [chatViewManager setScheduledAgentId:@"f60d269236231a6fa5c1b0d4848c4569"];
    //[chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectNone];
    //    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
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
