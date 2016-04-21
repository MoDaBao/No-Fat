//
//  UserInfoManager.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+ (UserInfoManager *)shareInstance {
    static UserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserInfoManager alloc] init];
    });
    return manager;
}

//  保存用户的username
- (void)saveUserName:(NSString *)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的username
- (NSString *)getUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if (!name) {
        return @"游客";
    }
    return name;
}
//  取消用户username
- (void)canceelUserName {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  保存用户的id
- (void)saveUserID:(NSNumber *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID.stringValue forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的id
- (NSString *)getUserID {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (!userID) {
        return @" ";
    }
    return userID;
}
//  取消用户的ID
- (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  保存用户avatar
- (void)saveUserAvatar:(NSString *)avatar {
    [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"UserAvatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的avatar
- (NSString *)gettUserAvatar {
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAvatar"];
    if (!avatar) {
        return @" ";
    }
    return avatar;
}
//  取消用户的avatar
- (void)cancelUserAvatar {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAvatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  保存用户的gender
- (void)saveUserGender:(NSNumber *)gender {
    [[NSUserDefaults standardUserDefaults] setObject:gender.stringValue forKey:@"UserGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的gender
- (NSString *)getUserGender {
    NSString *gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserGender"];
    if (!gender) {
        return @" ";
    }
    return gender;
}
//  取消用户的gender
- (void)cancelUserGender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  保存用户的mobile
- (void)saveUserMobile:(NSString *)mobile {
    [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"UserMobile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的mobile
- (NSString *)getUserMobile {
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserMobile"];
    if (!mobile) {
        return @" ";
    }
    return mobile;
}
//  取消用户mobile
- (void)canceelUserMobile {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserMobile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
