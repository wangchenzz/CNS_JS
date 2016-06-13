//
//  INetworking.h
//  iTestAFNetworking
//
//  Created by administrator on 15/11/23.
//  Copyright © 2015年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INetworking : NSObject
#define basicUrlStr @"http://www.yueqiao.org/SSM"

#define loginUrl @"http://www.yueqiao.org/SSM/user/getLogin"

#define newsUrl @"http://www.yueqiao.org/SSM/news/getNewsByType"

#define DetailNews @"http://www.yueqiao.org/SSM/news/selectNewById"

#define LikeAddUrl @"http://www.yueqiao.org/SSM/news/addZan"

#define addComment @"http://www.yueqiao.org/SSM/comment/addComment"

#define getQustType @"http://www.yueqiao.org/SSM/suject/getSubjectByType"

#define addRecord @"http://www.yueqiao.org/SSM/record/addRecord"

#define getRecord @"http://www.yueqiao.org/SSM/record/getRecordByloginName"


#define getCard @"http://www.yueqiao.org/SSM/card/getCardByType"

#define getCardById @"http://www.yueqiao.org/SSM/card/selectCardById"

#define addPlunge @"http://www.yueqiao.org/SSM/plunge/addPlunge"


#define addAnser @"http://www.yueqiao.org/SSM/plunge/insertPlungeHuifu"


#define addCard @"http://www.yueqiao.org/SSM/card/addCard"

#define getPersonBBs @"http://www.yueqiao.org/SSM/card/getCardByLoginName"

#define getLeavemsgByPage @"http://www.yueqiao.org/SSM/leavemsg/getLeavemsgByPage"

#define addSug @"http://www.yueqiao.org/SSM/leavemsg/addleavemsg"

@property (nonatomic,copy) NSString *ipstr;


//下载失败的block


@property (nonatomic,copy) void(^errorDolowdToDo)();

+(INetworking*)shareNet;


-(void)GET:(NSString*)URLString withParmers:(NSDictionary *)parmers do:(void(^)(id returnObject,BOOL isSuccess))myblok;

-(void)POST:(NSString*)object parameters:(id)parameters do:(void(^)(id returnObject,BOOL isSuccess))myblok;

@end
