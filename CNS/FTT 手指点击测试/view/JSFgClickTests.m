//
//  JSFgClickTests.m
//  CNS
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSFgClickTests.h"

/**
 初步设想是, 制作一种操作就是可以不断的创建这种测试, 但是这应该由系统内部来统筹, 只要告诉系统测试几次, 每次测试的细节, 测试完毕后 会告诉你这次测试的结果.
 */

@interface JSFgClickTests ()

/**
 *  用于倒计时的 label
 */
@property (nonatomic,strong) UILabel *countDownLabel;

/**
 *  用于提示的 label
 */
@property (nonatomic,strong) UILabel *tipsLabel;
/**
 *  计算时间的计时器
 */
@property (nonatomic,strong) NSTimer *calculateTimer;

/**
 *  总的测试次数;
 */
@property (nonatomic,readonly,assign) NSInteger totalCount;

/**
 *  默认从零开始.
 *  当前测试次数
 */

@property (nonatomic,assign) NSInteger currentCount;

/**
 *  点击次数
 */
@property (nonatomic,assign) NSInteger clickCount;

/**
 *  点击手势.
 */
@property (nonatomic,strong) UITapGestureRecognizer *clickTap;

/**
 倒计时开始的 timer;
 */
@property (nonatomic,strong) NSTimer *threeTimer;

/**
 倒计时的时间
 */

@property (nonatomic,assign) NSInteger countDownTimeCount;

/**
 *  点击倒计时的时间';
 */
@property (nonatomic,assign) NSInteger clickCountTime;

@end

@implementation JSFgClickTests

-(instancetype)init{

    if (self = [super init]) {
        
        [self setUpSetting];
        
    }
    return self;
}

-(void)setUpSetting{

    self.currentCount = 0;
    self.countDownTimeCount = 3;
    
    /**
     *  依然没有设置位置大小\
     */
}

-(NSTimer *)threeTimer{
    
    if (!_threeTimer) {
        self.threeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(runThree) userInfo:nil repeats:YES];
    }
    return _threeTimer;
}

-(void)runThree{
    
    if (self.countDownTimeCount <= 0) {
        
        [self.threeTimer invalidate];
        
        self.threeTimer = nil;
        
        [self.tipsLabel setText:@""];
        
        [self.countDownLabel setText:@""];
        
        self.countDownTimeCount = 3;
        /**
         *  倒计时完成, 此处开始读秒.
         */
        
        [self beginCountTest];
        
        return;
    }
    
    self.tipsLabel.text = @"倒计时";
    
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld",self.countDownTimeCount];
    
    self.countDownTimeCount --;
}


-(NSTimer *)calculateTimer{
    
    if (!_calculateTimer) {
        self.calculateTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
    }
    return _calculateTimer;
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

-(UILabel *)countDownLabel{
    if (!_countDownLabel) {
        
        UILabel *label = [[UILabel alloc] init];
        
        label.numberOfLines = 0;
        
        [label setFont:[UIFont boldSystemFontOfSize:38]];
        
        [label setBackgroundColor:[UIColor clearColor]];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label setTextColor:[UIColor blackColor]];
        
        [self addSubview:label];
        
        self.countDownLabel = label;
        
        self.countDownLabel.height = self.height * .2;
        self.countDownLabel.width = self.width * .2;
        
        self.countDownLabel.centerX = self.centerX;
        
        self.countDownLabel.centerY = self.centerY;
    }
    return _countDownLabel;
}


-(UITapGestureRecognizer *)clickTap{
    
    if (!_clickTap) {
        self.clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScreen)];
        
        self.clickTap.numberOfTouchesRequired = 1;
    }
    return _clickTap;
}

+(instancetype)test{
    
    return [[self alloc]init];
}


-(NSInteger)totalCount{
    
    return [self.delegate respondsToSelector:@selector(numberOfTestsCountInJSFgClickTests:)]?[self.delegate numberOfTestsCountInJSFgClickTests:self]: 3;
}

/**
 *  这里开始倒计时
 */
-(void)show{
    
    
    
    [[timerTool tool]fireInTheHoll:self.threeTimer];

}




-(void)beginCountTest{

    self.tipsLabel.text = [self.delegate JSFgClickTests:self titleForTipsInCount:self.currentCount];
    
    self.clickCountTime = [self.delegate JSFgClickTests:self timeTravelForCount:self.currentCount];
    
    [self addGestureRecognizer:self.clickTap];
    
    [[timerTool tool] fireInTheHoll:self.calculateTimer];
    
    self.setAnimationOn = YES;

}


-(void)clickScreen{
    self.clickCount++;
}


-(void)runTime{
    
    
    /**
     *  最终觉得 应该是在开始的时候 判断,
     */
    
    if (self.clickCountTime == 0) {
        
        [self removeGestureRecognizer:self.clickTap];
        
        [self.calculateTimer invalidate];
        
        self.calculateTimer = nil;
        
        self.countDownLabel.text = @"停";
        self.setAnimationOn = NO;
        
        
        
        /**
         *  用来得到每次的测试成绩的回调;
         */
        if ([self.delegate respondsToSelector:@selector(JSFgClickTests:clickCountForCurrentCount:andClickCount:)]) {
            [self.delegate JSFgClickTests:self clickCountForCurrentCount:self.currentCount andClickCount:self.clickCount];
        }
        
        /**
         *  回调完成后将属性置空;
         */
        self.clickCount = 0;
        
       
        /**
         *  在这里 currentCount ++ 再来判断是否还需要继续测试
         */
    
        self.currentCount ++;
        
        if (self.currentCount >= [self.delegate numberOfTestsCountInJSFgClickTests:self]) {
            
            self.tipsLabel.text = @"";
            
            self.countDownLabel.text = @"";
            
            self.setAnimationOn = NO;
            
            /**
             *  测试完毕的回调;
             */
            if ([self.delegate respondsToSelector:@selector(DidFinsihAllTest:)]) {
                [self.delegate DidFinsihAllTest:self];
            }
            
            
            
        }else{
            
            [self performSelector:@selector(show) withObject:nil afterDelay:1.2];
        }
        return;
    }

    [self.countDownLabel JSLabel_StarAnimationWithDirection:JSFakeAnimationRight toText:[NSString stringWithFormat:@"%ld",self.clickCountTime]];
    
    self.clickCountTime --;
    
}


@end
