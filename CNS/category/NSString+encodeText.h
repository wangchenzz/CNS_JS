//
//  NSString+encodeText.h
//  CNS
//
//  Created by Mac on 16/6/24.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *Base64String(NSString *a);



@interface NSString (encodeText)


-(NSString *)encodeForBase64;


-(NSString *)decodeFromBase64;


-(NSString *)encodeForMd5;

@end
