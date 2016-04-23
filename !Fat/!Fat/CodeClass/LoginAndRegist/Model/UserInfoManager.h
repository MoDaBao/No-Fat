//
//  UserInfoManager.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

+ (UserInfoManager *)shareInstance;

//  添加用户信息
- (void)setUserInfoWithDic:(NSDictionary *)dic;
//  移除所有用户信息
- (void)removeAllUserInfo;

//  保存用户的id
- (void)saveUserID:(NSNumber *)userID;
//  获取用户的id
- (NSString *)getUserID;
//  取消用户的ID
- (void)cancelUserID;

//  保存用户avatar头像
- (void)saveUserAvatar:(NSString *)avatar;
- (NSString *)gettUserAvatar;
- (void)cancelUserAvatar;

//  保存用户的gender
- (void)saveUserGender:(NSNumber *)gender;
- (NSString *)getUserGender;
- (void)cancelUserGender;

//  保存用户的mobile
- (void)saveUserMobile:(NSString *)mobile;
- (NSString *)getUserMobile;
- (void)canceelUserMobile;

//  保存用户的username
- (void)saveUserName:(NSString *)name;
- (NSString *)getUserName;
- (void)canceelUserName;

//  保存用户的height
- (void)saveUserHeight:(NSString *)height;
- (NSString *)getUserHeight;
- (void)cancelUserHeight;

//  保存用户的weight
- (void)saveUserWeight:(NSString *)weight;
- (NSString *)getUserWeight;
- (void)cancelUserWeight;

//  保存用户的sign个人简介
- (void)saveUserSign:(NSString *)sign;
- (NSString *)getUserSign;
- (void)cancelUserSign;

//  保存用户的createTime
- (void)saveUserCreateTime:(NSNumber *)createTime;
- (NSString *)getUserCreateTime;
- (void)cancelUserCreateTime;

//  保存用户的trainGoal训练目的
- (void)saveUserTrainGoal:(NSString *)trainGoal;
- (NSString *)getUserTrainGoal;
- (void)cancelUserTrainGoal;

//  训练基础
- (void)saveUserTrainBase:(NSString *)trainBase;
- (NSString *)getUserTrainBase;
- (void)cancelUserTrainBase;

//  训练频率
- (void)saveUserTrainFrequency:(NSString *)trainFrequency;
- (NSString *)getUserTrainFrequency;
- (void)cancelUserTrainFrequency;



@end
