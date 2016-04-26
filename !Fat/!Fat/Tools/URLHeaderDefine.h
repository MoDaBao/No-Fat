//
//  URLHeaderDefine.h
//  No!Fat
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#ifndef URLHeaderDefine_h
#define URLHeaderDefine_h

#define LOGINURL @"http://api.fit-time.cn/ftuser/mobileLogin"// 登录POST
#define VERIFYCODEURL @"http://api.fit-time.cn/ftuser/getVerifyCode"// 获取验证码POST
#define REGISTURL @"http://api.fit-time.cn/ftuser/mobileRegister"// 注册POST

#define GETFANSCOUNTURL @"http://api.fit-time.cn/ftsns/getUserStatByIds"// 获取用户的粉丝数量GET
//#define ALTERUSERSIGNURL @"http://api.fit-time.cn/ftuser/update"// 修改个人简介POST 同下
#define ALTERUSERINFOURL @"http://api.fit-time.cn/ftuser/update"// 修改用户信息POST,此URL需要token作为参数传入并且需要对token参数进行encode

#define GETUSERNEWSURL @"http://api.fit-time.cn/ftsns/refreshUserFeed?page_size=20"// 获取个人动态GET


#endif /* URLHeaderDefine_h */
