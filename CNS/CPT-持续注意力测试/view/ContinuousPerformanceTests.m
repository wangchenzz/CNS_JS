//  ContinuousPerformanceTests.m
//  CNS
//  Created by Mac on 16/3/31.
//  Copyright © 2016年 竞思教育. All rights reserved.

#import "ContinuousPerformanceTests.h"

@interface ContinuousPerformanceTests ()

@property (nonatomic,strong) UILabel *worsLabel;

@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) NSMutableArray *wordsContainArray;

@property (nonatomic,strong) NSTimer *actionTimer;

@property (nonatomic,assign) float timeTraval;

@property (nonatomic,assign) float currentTime;

@property (nonatomic,assign) NSInteger currentCount;

@property (nonatomic,retain) UITapGestureRecognizer *tap;

@property (nonatomic,retain) NSMutableArray *selectArray;


@end

@implementation ContinuousPerformanceTests

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+(instancetype)test{
    return [[self alloc]init];
}

-(NSMutableArray *)selectArray{
    if (!_selectArray ) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

/**
 *  用来得到所有的测试数据,用这些数据可以进行测试
 */
-(void)getTestArray{
    for (int i = 0; i < 30 ; i ++) {
        NSString *word = self.wordsContainArray[arc4random()%self.wordsContainArray.count];
        
        [self.selectArray addObject:word];
    }
    
    [self addWordBForCount:20 toArray:self.selectArray];
}

-(void)addWordBForCount:(NSInteger)count toArray:(NSMutableArray *)array{

    if (!array) {
        array = [NSMutableArray array];
    }
    NSInteger araryCount = [array count];
    
    for (int i = 0 ; i < count; i ++) {
        NSInteger rollNum = arc4random()%araryCount;
        
        [array insertObject:@"b" atIndex:rollNum];
        
        araryCount ++;
    }
}

-(UILabel*)worsLabel{
    if (!_worsLabel) {
        UILabel *label = [[UILabel alloc] init];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.width = label.height = self.height * .05;
        
        label.font = [UIFont boldSystemFontOfSize:33];
        
        label.centerX = self.centerX;
        
        label.centerY = self.centerY;
        
        label.backgroundColor = [UIColor whiteColor];
        
        label.textColor = [UIColor blackColor];
        
        [self addSubview:label];
        
        _worsLabel = label;
        
    }
    return _worsLabel;
}

-(void)showMeTheTest{
    
    /**
     *  1.界定什么时候开始测试;
     *  2.屏幕上会循环出现一些字母;  --label  count  timer  tap
     *  3.点击的时间;
     *  4.出现的次数;
     *  5.结束回调;
     */
    
    self.setAnimationOn = YES;
    [self getTestArray];
    
    self.actionTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(showlabel:) userInfo:nil repeats:YES];
    
    self.currentCount = 0;
    
    [self seeLabel];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIn)];
    
    [self addGestureRecognizer:self.tap];
    
    [[timerTool tool] fireInTheHoll:self.actionTimer];

}

-(void)clickIn{
    if ([self.delegate respondsToSelector:@selector(ContinuousPerformanceTests:didClickWithCount:andWords:andTimeTravel:)]) {
        [self.delegate ContinuousPerformanceTests:self didClickWithCount:self.currentCount andWords:self.selectArray[self.currentCount] andTimeTravel:self.currentTime];
    }
    self.currentCount++;
    self.currentTime = 0;
    [self seeLabel];
}

-(void)showlabel:(NSTimer *)timer{

    self.timeTraval += 0.01;
    self.currentTime+= 0.01;
    
    if (self.currentTime >= 2) {
        self.currentTime = 0;
        self.currentCount +=1;
        [self performSelectorOnMainThread:@selector(seeLabel) withObject:nil waitUntilDone:YES];
    }
}

-(void)seeLabel{
    if (self.currentCount >= self.selectArray.count) {
        
        /**
         *  这里结束所有测试.
         */
        self.setAnimationOn = NO;
        [self.worsLabel removeFromSuperview];
        self.worsLabel = nil;
        [self.actionTimer invalidate];
        if ([self.delegate respondsToSelector:@selector(ContinuousPerformanceTests:didFinishWithTime:)]) {
            [self.delegate ContinuousPerformanceTests:self didFinishWithTime:self.timeTraval];
        }
        
        return;
    }

//    JSLog(@"%f",self.currentCount);
    
    NSString *showWord = self.selectArray[self.currentCount];
    
    [self.worsLabel JSLabel_StarAnimationWithDirection:JSFakeAnimationRight toText:showWord];
}

-(NSMutableArray *)wordsContainArray{
    if (!_wordsContainArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 65 ; i < 91 ; i ++) {
            //97 ~ 121  65-90
            char a = i;
            char biga = i + 32;
            NSString *l = [NSString stringWithFormat:@"%c",a];
            NSString *n = [NSString stringWithFormat:@"%c",biga];
            /**
             
             */
            [array addObject:l];
            [array addObject:n];
        }
        _wordsContainArray = array;
    }
    return _wordsContainArray;
}

/**
 *  当屏幕上出现 b 这个字段的时候,需要用户进行响应,
 */


@end
