
//
//  ShowSegModel.m
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "ShowSegModel.h"

@implementation ShowSegModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.userNickName = dic[@"nickName"];
        self.headerImageNStr = dic[@"img"];
        self.segContent = dic[@"context"];
        self.creatTime = dic[@"createtime"];
        [self getFrame];
    }
    return self;
}


-(void)getFrame{
    
    CGFloat xbj = 15;
    
    self.imageRect = CGRectMake(xbj, xbj, 40, 40);
    
    self.nameRect = CGRectMake(CGRectGetMaxX(self.imageRect) + xbj,  self.imageRect.origin.y, JSFrame.size.width - CGRectGetMaxX(self.imageRect) - xbj - xbj, 21);
    
    CGRect contenR = [self.segContent boundingRectWithSize:CGSizeMake(self.nameRect.size.width, MAXFLOAT) strFont:contentFont];
    
    
    self.contentRect = CGRectMake(self.nameRect.origin.x, 44, contenR.size.width, contenR.size.height);
    
    self.timeRect = CGRectMake(self.contentRect.origin.x, CGRectGetMaxY(self.contentRect) + 8, self.nameRect.size.width, 21);
    
    self.totalHeight = CGRectGetMaxY(self.timeRect) + 5;
}

@end
