//
//  JSNewsFrameModel.m
//  CNS
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSNewsFrameModel.h"

@implementation JSNewsFrameModel

-(instancetype)initWithModel:(JSNewsModel *)model{
    if (self = [super init]) {
        
        
        self.imageRectArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.commentArray = [NSMutableArray array];
        self.lmodel = model;
        
        
    }
    return self;
}



-(void)setLmodel:(JSNewsModel *)lmodel{
    if (_lmodel!=lmodel) {
        _lmodel = lmodel;
        
        CGFloat keplinth = 10;
        
        NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
        titleDic[NSFontAttributeName] = titleFont;
        
        CGRect titleR = [self.lmodel.title boundingRectWithSize:CGSizeMake(JSFrame.size.width-keplinth-8*keplinth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
        
        self.titleRect = CGRectMake(keplinth, keplinth, JSFrame.size.width - 9*keplinth, titleR.size.height);
        
        
        
        
        NSMutableDictionary *diction = [NSMutableDictionary dictionary];
        diction[NSFontAttributeName] = contentFont;
        
        self.creatTimeRect = [self.lmodel.createtime boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:diction context:nil];
        
        self.creatTimeRect = CGRectMake(keplinth,(CGRectGetMaxY(_titleRect)), self.creatTimeRect.size.width, self.creatTimeRect.size.height);
        
        
//        JSLog(@"%@",NSStringFromCGRect(self.creatTimeRect));
        
        /**
         *  作者位置
         */
        
        self.authorRect = CGRectMake(CGRectGetMaxX(self.creatTimeRect)+keplinth * 2, self.creatTimeRect.origin.y, 200, self.creatTimeRect.size.height);
        
        /**
         *  图片:
         */
        
     __block CGRect bImage = CGRectMake(0, CGRectGetMaxY(self.creatTimeRect)+1*keplinth,0,0);
        
        
        NSArray *imageArray = [self.lmodel.images componentsSeparatedByString:@","];
        
        for (int i = 0  ; i < imageArray.count; i ++) {
            NSString *imastr = [NSString stringWithFormat:@"%@%@",basicUrlStr,imageArray[i]];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imastr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (image.size.width * image.scale <= JSFrame.size.width) {
                  bImage = CGRectMake(0, bImage.origin.y + 1*keplinth + bImage.size.height, JSFrame.size.width, image.size.height * image.scale);
                    
                }else{
                  bImage = CGRectMake(0, bImage.origin.y+ 1* keplinth + bImage.size.height, JSFrame.size.width, image.size.height * JSFrame.size.width/image.size.width);
                }
            [self.imageArray addObject:image];
                
                
                
            }];
            [self.imageRectArray addObject:NSStringFromCGRect(bImage)];
        }
        /**
         *  正文 rect
         */
        CGPoint Bcontent = CGPointMake(0, CGRectGetMaxY(bImage)+2*keplinth);
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[NSFontAttributeName] = TruecontentFont;
        
        
        CGRect textRect = [self.lmodel.content boundingRectWithSize:CGSizeMake(JSFrame.size.width - 4 * keplinth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil];
        
        self.contentRect = CGRectMake(2*keplinth, Bcontent.y, JSFrame.size.width - 4 * keplinth, textRect.size.height);
        
        

        
        
    }
}

-(void)setLikeNum:(NSString *)likeNum{
    
    /**
     *  功能按钮
     */
    _likeNum = likeNum;
    
    NSMutableDictionary *diccomment = [NSMutableDictionary dictionary];
    diccomment[NSFontAttributeName] = contentFont;
    
    CGRect commentrect = [self.commentNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:diccomment context:nil];
    
    
    self.commentButRect = CGRectMake(10, CGRectGetMaxY(self.contentRect)+40, commentrect.size.width, commentrect.size.height);
    
    
    
    
    CGRect likeRect = [self.likeNum boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:diccomment context:nil];
    
    
    self.likeTooButRect = CGRectMake(CGRectGetMaxX(self.commentButRect)+10, self.commentButRect.origin.y, likeRect.size.width, likeRect.size.height);
    
    
    /**
     *  总高度
     */
    
    self.totalHeight = CGRectGetMaxY(self.likeTooButRect)+10*3;
}



@end
