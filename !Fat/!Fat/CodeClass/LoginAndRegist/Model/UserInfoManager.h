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

//  保存用户的id
- (void)saveUserID:(NSNumber *)userID;
//  获取用户的id
- (NSString *)getUserID;
//  取消用户的ID
- (void)cancelUserID;

//  保存用户avatar
- (void)saveUserAvatar:(NSString *)avatar;
//  获取用户的avatar
- (NSString *)gettUserAvatar;
//  取消用户的avatar
- (void)cancelUserAvatar;

//  保存用户的gender
- (void)saveUserGender:(NSNumber *)gender;
//  获取用户的gender
- (NSString *)getUserGender;
//  取消用户的gender
- (void)cancelUserGender;

//  保存用户的mobile
- (void)saveUserMobile:(NSString *)mobile;
//  获取用户的mobile
- (NSString *)getUserMobile;
//  取消用户mobile
- (void)canceelUserMobile;

//  保存用户的username
- (void)saveUserName:(NSString *)name;
//  获取用户的username
- (NSString *)getUserName;
//  取消用户username
- (void)canceelUserName;

//  保存用户的height
- (void)saveUserHeight:(NSNumber *)height;
//  获取用户的height
- (void)getUserHeight;
//  取消用户的height
- (void)cancelUserHeight;

//  保存用户的weight
- (void)saveUserWeight:(NSNumber *)weight;
//  获取用户的height
- (void)getUserWeight;
//  取消用户的height
- (void)cancelUserWeight;

//  保存用户的sign个人简介
- (void)saveUserSign:(NSString *)sign;
//  获取用户的sign个人简介
- (void)getUserSign;
//  取消用户的sign个人简介

//  

@end
