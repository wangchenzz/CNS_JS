//
//  JSVisualAttentionTests.m
//  CNS
//
//  Created by Mac on 16/3/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSVisualAttentionTests.h"

#import <Foundation/Foundation.h>

@interface JSVisualAttentionTests ()

/**
 *  包含所有图片名字的 Array;
 */
@property (nonatomic,retain) NSMutableArray *containAllImageNameArray;


/**
 *  显示图片的 ImageView
 */
@property (nonatomic,weak) UIImageView *showImageView;



/**
 *  用于提示的 label;
 */

@property (nonatomic,weak) UILabel *tipsLabel;

/**
 *  用以计时的 timer
 */
@property (nonatomic,retain) NSTimer *calculatTimer;

/**
 *  当前显示的轮次
 */
@property (nonatomic,assign) NSInteger currentImageCount;

/**
 *  点击屏幕的手势
 */
@property (nonatomic,retain) UITapGestureRecognizer *tapScreen;

/**
 *  包含测试内容和测试结果的模型;
 */
@property (nonatomic,retain) JSVisualAttentionModel *model;


@property (nonatomic,assign) BOOL isModule;

@end

@implementation JSVisualAttentionTests

-(instancetype)initWithModelArray:(NSArray *)array withDifficult:(NSInteger)cultNum{
    
    if (self = [super init]) {
        
        [self setUpModelWithQarray:array andWithDiffLevel:cultNum];
        
        self.currentImageCount = 0;
    }
    return self;
}


+(instancetype)testWithModelArray:(NSArray *)array withDifficult:(NSInteger)cultNum{

    return [[self alloc]initWithModelArray:array withDifficult:cultNum];
    
}

-(void)show{
    
    self.calculatTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(showImage) userInfo:nil repeats:YES];
    
    [self.tipsLabel setText:@"请记下来每一张图的样子"];
    
    [[timerTool tool] fireInTheHoll:self.calculatTimer];
}

-(void)showTests{

    self.calculatTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(showTestsImage) userInfo:nil repeats:YES];
    
    [[timerTool tool] fireInTheHoll:self.calculatTimer];
    
    
    [self.tipsLabel setText:@"如果是要求记忆的图像请点击屏幕"];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScreen)];
    
    [self addGestureRecognizer:tap];
    
    self.setAnimationOn = YES;
    
    self.tapScreen = tap;
}

-(void)clickScreen{
    if ([self.delegate respondsToSelector:@selector(JSVisualAttentionTests:didClickScreen:withCurrentCount:)]) {
        [self.delegate JSVisualAttentionTests:self didClickScreen:self.model withCurrentCount:self.currentImageCount];
    }
}

/**
 *  第一次展示的正确图片
 */
-(void)showImage{                 
    

   
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *showImage;
        
        if (_isModule) {
            showImage = self.model.theRightImageArray[self.currentImageCount];
        }else{
            showImage = [UIImage imageNamed:self.model.theRightImageArray[self.currentImageCount]];
        }
        [self.showImageView startImageViewAnimationImage:showImage] ;
        
        self.currentImageCount++;
        
        if (self.currentImageCount >= self.model.theRightImageArray.count) {
            static BOOL isOver = NO;
            self.currentImageCount--;
            
            if (isOver) {
                [self.calculatTimer invalidate];
                self.currentImageCount = 0;
                [self.showImageView removeFromSuperview];
                [self.tipsLabel removeFromSuperview];
                [self removeGestureRecognizer:self.tapScreen];
                
                if ([self.delegate respondsToSelector:@selector(JSVisualAttentionTests:didFinishShowRightImage:)]) {
                    
                    
                    [self.delegate JSVisualAttentionTests:self didFinishShowRightImage:self.model];
                    
                }
                return;
            }
             isOver = YES;
            
        }
        
        
        
        
    });
}

-(void)showTestsImage{
    
    UIImage *showImage;
    
    if (_isModule) {
        showImage = self.model.theTestsAllImageArray[self.currentImageCount];
    }else{
        showImage = [UIImage imageNamed:self.model.theTestsAllImageArray[self.currentImageCount]];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.showImageView startImageViewAnimationImage:showImage];
        
        self.currentImageCount++;
        
        if (self.currentImageCount >= self.model.theTestsAllImageArray.count) {
            [self.calculatTimer invalidate];
            self.currentImageCount = 0;
            [self.showImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
            [self removeGestureRecognizer:self.tapScreen];
            self.setAnimationOn = NO;
            if ([self.delegate respondsToSelector:@selector(JSVisualAttentionTests:didFinishShowRightImage:)]) {
                [self.delegate JSVisualAttentionTests:self didFinsihTests:self.model];
            }
            return;
        }
    });

}


/**
 *  这里是将要可能使用的数据放在数组中,实际中还未定,
 *
 *  @return ...
 */
-(NSMutableArray *)containAllImageNameArray{

    if (!_containAllImageNameArray) {
        self.containAllImageNameArray = [@[@"visualImage1",@"visualImage2",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage2",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage3",@"visualImage4",@"visualImage5",@"visualImage6",@"visualImage3",@"visualImage4",@"visualImage5"] mutableCopy];
    }
    return _containAllImageNameArray;
}

-(void)setUpModelWithQarray:(NSArray *)array andWithDiffLevel:(NSInteger)level{
    
    JSVisualAttentionModel *model = [[JSVisualAttentionModel alloc] init];
    
    
    if (array) {
        
        _isModule = YES;
        
        NSMutableArray *ar = [NSMutableArray array];
        
        int selectNum = 0;
        if (level < 2) {
            selectNum = 5;
        }else if(level < 4){
            selectNum = 8;
        }else{
            selectNum = 10;
        }
        
        for (NSString *urlString in array) {
            
            NSString *imastr = [NSString stringWithFormat:@"%@%@",basicUrlStr,urlString];
            
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imastr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    [ar addObject:image];
                }
                
                if ([urlString isEqualToString:array.lastObject]) {
                    model.theTestsAllImageArray = [self getSomeImageFromArray:ar withCount:(int)ar.count];
                    
                    model.theRightImageArray = [self getSomeImageFromArray:model.theTestsAllImageArray withCount:selectNum];
                }
            }];
        }
        
    }else{
        
        model.theTestsAllImageArray = [self getSomeImageFromArray:self.containAllImageNameArray withCount:30];
        
        model.theRightImageArray = [self getSomeImageFromArray:model.theTestsAllImageArray withCount:15];
    }

    
    
    self.model = model;
    
}
-(UIImageView *)showImageView{
    
    if (!_showImageView) {
        
        UIImageView *imageView = [[UIImageView alloc] init];

        [self addSubview:imageView];
        
        self.showImageView = imageView;
        
        self.showImageView.height = self.showImageView.width = self.width * .4;
        
        self.showImageView.centerX = self.centerX;
        
        self.showImageView.centerY = self.centerY;
    }
    return _showImageView;
}


-(UILabel *)tipsLabel{
    
    if (!_tipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        
        label.numberOfLines = 0;
        
        [label setFont:[UIFont systemFontOfSize:22]];
        
        [label setBackgroundColor:[UIColor clearColor]];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label setTextColor:[UIColor blackColor]];
        
        [self addSubview:label];
        
        self.tipsLabel = label;
        
        self.tipsLabel.height = self.height * .15;
        self.tipsLabel.width = self.width * .5;
        
        self.tipsLabel.centerX = self.centerX;
        
        self.tipsLabel.centerY = self.height * .8;
        
    }
    return _tipsLabel;
}

/**
 *  从一个数组中乱序得到一些元素
 *  3
 *  @param array 目标数组
 *  @param count 元素个数
 */
-(NSMutableArray *)getSomeImageFromArray:(NSMutableArray *)array withCount:(NSInteger)count{

    NSMutableArray *cotainArray = [NSMutableArray array];
    
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:array];
    
    if (count > array.count) {
        count = (int)array.count;
    }
    for (int i = (int)count ;i > 0 ;i -- ) {
        
        int a = arc4random()%copyArray.count;
        
        [cotainArray addObject:copyArray[a]];
        
        [copyArray removeObjectAtIndex:a];
        
    }
    return cotainArray;

}

@end
