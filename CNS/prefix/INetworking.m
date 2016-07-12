//
//  INetworking.m
//  iTestAFNetworking
//
//  Created by administrator on 15/11/23.
//  Copyright © 2015年 administrator. All rights reserved.
//

#import "INetworking.h"
#import "AFNetworking.h"

typedef void(^wrong)();

static INetworking *network;

static BOOL isNetWorking = YES;


NSString * const loginUrl = @"http://www.yueqiao.org/SSM/user/getLogin";

NSString * const loginUrlForVisitor = @"http://www.yueqiao.org/SSM/user/getLogin2";

NSString * const newsUrl = @"http://www.yueqiao.org/SSM/news/getNewsByType";

NSString * const DetailNews = @"http://www.yueqiao.org/SSM/news/selectNewById";

NSString * const LikeAddUrl = @"http://www.yueqiao.org/SSM/news/addZan";

NSString * const addComment = @"http://www.yueqiao.org/SSM/comment/addComment";

NSString * const getQustType = @"http://www.yueqiao.org/SSM/suject/getSubjectByType";

NSString * const addRecord = @"http://www.yueqiao.org/SSM/record/addRecord";

NSString * const getRecord = @"http://www.yueqiao.org/SSM/record/getRecordByloginName";

NSString * const getCard = @"http://www.yueqiao.org/SSM/card/getCardByType";

NSString * const getCardById = @"http://www.yueqiao.org/SSM/card/selectCardById";

NSString * const addPlunge = @"http://www.yueqiao.org/SSM/plunge/addPlunge";

NSString * const addAnser = @"http://www.yueqiao.org/SSM/plunge/insertPlungeHuifu";

NSString * const addCard = @"http://www.yueqiao.org/SSM/card/addCard";

NSString * const getPersonBBs = @"http://www.yueqiao.org/SSM/card/getCardByLoginName";

NSString * const getLeavemsgByPage = @"http://www.yueqiao.org/SSM/leavemsg/getLeavemsgByPage";

NSString * const addSug = @"http://www.yueqiao.org/SSM/leavemsg/addleavemsg";


@implementation INetworking


-(void)setIpstr:(NSString *)ipstr{

    
    _ipstr = ipstr;
    
}


+(INetworking*)shareNet{

     static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        network = [[self alloc]init];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                    
                case AFNetworkReachabilityStatusNotReachable:{
                    
                    JSLog(@"无网络");
                    
                    isNetWorking = NO;
                    
                    break;
                    
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    
                    JSLog(@"WiFi网络");
                    
                    break;
                    
                }
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    
                    JSLog(@"无线网络");
                    
                    break;
                    
                }
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return network;
}

-(void)GET:(NSString*)URLString withParmers:(NSDictionary *)parmers do:(void(^)(id returnObject,BOOL isSuccess))myblok{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.requestSerializer.timeoutInterval = 10;
    
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [session GET:URLString parameters:parmers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        myblok(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         myblok(error,NO);
    }];
}

-(void)POST:(NSString*)object parameters:(id)parameters do:(void(^)(id returnObject,BOOL isSuccess))myblok{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer.timeoutInterval = 10;

    [manager POST:object parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        myblok(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        myblok(error,NO);
    }];
}


// 下载；   //存放到document中了；
-(void)dowloadWithLoadString:(NSString*)urlstring{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error){
        _errorDolowdToDo();
        }
    }];

    [downloadTask resume];

}


/**
 *  上传图片
 *
 *  @param name      图片名字
 *  @param URLString  url
 *  @param imageData  图片 data
 *  @param code       上传密码
 *  @param success   成功回调
 *  @param failure   失败回调   
 */
-(void)uploadImageWithName:(NSString *)name URLString:(NSString *)URLString imageData:(NSData *)imageData passCode:(NSString *)code success:(void (^)(id returnObject))success failure:(void (^)(NSError * error))failure{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:code fileName:name mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(responseObject);
        }
    }];
    [uploadTask resume];
}


@end
