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

#define GETUSERNEWSURL @"http://api.fit-time.cn/ftsns/refreshUserFeed?page_size=20&user_id=1923858&token=r1VPsKaxR4fHzcB4KpAPlZbNp1X8sPV9UW71BT7ugcdsrFTIr%2BerBw%3D%3D&device_id=FDB8955C-1AD4-45AA-9297-150E8574177B&client=ios&idfa=24D6B506-8085-47A3-BD5F-41D9013B7C90&os=iPhone%20OS%209.3.1&model=iPhone%206&ver=2.5.2"// 获取个人动态GET
#define DELETEMYNEWSURL @"http://api.fit-time.cn/ftsns/delFeed"// 删除个人动态POST



#define TUIJIANLIST_URL @"http://api.fit-time.cn/ftsns/refreshUserFeed?&elite=1"//推荐 get
#define TUIJIANLISTMORE_URL @"http://api.fit-time.cn/ftsns/loadMoreUserFeed?lon=121.288373&page_size=20&ver=2.5.2.1&lat=31.128097&client=android&last_id=3448178&adcode=310117&device_id=868698026359747&elite=1"//推荐下拉更多
#define USERMESSAGE_URL @"http://api.fit-time.cn/ftuser/loadUserProfile?";//用户信息 参数 user_id
#define GUANZHULIST_URL @"http://api.fit-time.cn/ftsns/refreshFollowFeed" //关注 get
#define ZUIXINLIST_URL @"http://api.fit-time.cn/ftsns/refreshUserFeed?" //最新页面
#define ZUIXINLISTMORE_URL @"http://api.fit-time.cn/ftsns/loadMoreUserFeed?lon=121.288366&lat=31.128092&page_size=20&ver=2.5.2.1&client=android&adcode=310117&last_id=3548487&device_id=868698026359747"//最新刷新
#define TIAJIAGUANZHU @"http://api.fit-time.cn/ftuser/loadRecommendUsers?"//添加关注数据


#endif /* URLHeaderDefine_h */
