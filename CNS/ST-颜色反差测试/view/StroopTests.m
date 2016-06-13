//
//  StroopTests.m
//  CNS
//
//  Created by Mac on 16/3/14.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "StroopTests.h"

@interface StroopTests ()

/**
 *  显示词语的 label;
 */
@property (nonatomic,strong) UILabel *showWordsLabel;

/**
 *  显示词语的 label 的字体颜色;
 */
@property (nonatomic,retain) UIColor *labelTextColor;

/**
 *  用来提示的 label;
 */
@property (nonatomic,strong) UILabel *tipsLabel;

/**
 *  用来计时的定时器;
 */
@property (nonatomic,strong) NSTimer *timeTimer;

/**
 *  用来控制更新 label 的定时器;
 */
@property (nonatomic,strong) NSTimer *actionTimer;

/**
 *  当前 label 的展示时间;
 */
@property (nonatomic,assign) float currentShowTime;

/**
 *  记录经过了多少时间
 */
@property (nonatomic,assign) float timeTravel;

/**
 *  当前经过了多久.
 */
@property (nonatomic,assign) float currentTimeTravel;

/**
 *  当前所进行的测试状态
 */
@property (nonatomic,assign) StroopTestType StroopTestType;

/**
 *  1... 需要规定每个字显示多久;
 2... 过多久会更新一次 label;   默认显示的时间为 1~2s 时间.   一二点为同一属性.
 3... 模型构造;
 
 考虑之后 准备放置在一个类里面,供应调用,  模型数据存放于数组之中, 一共设置三个数组;
 */


/**
 *  存放简单测试的模型;
 */
@property (nonatomic,strong) NSMutableArray *SimplifyModelArray;

/**
 *  存放复杂测试的模型;
 */
@property (nonatomic,strong) NSMutableArray *ComplicationModelArray;

/**
 *  存放异色测试的模型;
 */
@property (nonatomic,strong) NSMutableArray *ColorInContrastModelArray;

/**
 *  存放颜色的数组
 */
@property (nonatomic,strong) NSArray *colorArray;

/**
 *  显示当前数组里的数组 index.  [0:]
 */
@property (nonatomic,assign) NSInteger currentCount;

/**
 *  存放文字的数组
 */
@property (nonatomic,strong) NSArray *textArray;


/**
 手势
 */

@property (nonatomic,strong) UITapGestureRecognizer *clickScreen;

@end

@implementation StroopTests

-(instancetype)init{
    if (self = [super init]) {
        
//        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpInfo];
        
        self.clickScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        
    }
    return self;
}

//-(NSTimer *)actionTimer{
//    if (!_actionTimer) {
//        self.actionTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(doSomeThing) userInfo:nil repeats:YES];
//    }
//    return _actionTimer;
//}
-(NSTimer *)timeTimer{
    if (!_timeTimer) {
        self.timeTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(someThingForNothing) userInfo:nil repeats:YES];
    }
    return _timeTimer;
}



-(void)click{
    
    if ([self.delegate respondsToSelector:@selector(StroopTests:clickScreenWithModel:andCurrentCount:andClickTime:)]) {
        
        StroopModel *model;
        
        if (self.StroopTestType == StroopTestsTypeSimplify) {
            
            model = self.SimplifyModelArray[_currentCount];
            
        }else if(self.StroopTestType == StroopTestsTypeComplication){
            
            model = self.ComplicationModelArray[_currentCount];
        }else{
            model = self.ColorInContrastModelArray[_currentCount];
        }
        [self.delegate StroopTests:self clickScreenWithModel:model andCurrentCount:self.currentCount andClickTime:self.currentTimeTravel];
    }
    
    if (self.StroopTestType != StroopTestsTypeSimplify) {
        self.currentTimeTravel = 0;
        self.currentCount++;
    }
    if (self.currentCount >= 20) {
        [self.timeTimer invalidate];
        
        [self.actionTimer invalidate];
        
        [self removeGestureRecognizer:self.clickScreen];
        
        self.showWordsLabel.text = @"";
        
        if (self.StroopTestType == StroopTestsTypeSimplify) {
            if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihSimplifyTest:)]) {
                [self.delegate StroopTestsDidFinsihSimplifyTest:self];
            }
            
        }else if(self.StroopTestType == StroopTestsTypeComplication){
            if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihComplicationTest:)]) {
                [self.delegate StroopTestsDidFinsihComplicationTest:self];
            }
            
        }else{
            if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihInContrastTest:)]) {
                [self.delegate StroopTestsDidFinsihInContrastTest:self];
            }
        }
        return;
    }
    if (self.StroopTestType != StroopTestsTypeSimplify) {
        [self seeLabel];
    }
}


-(NSArray *)colorArray{
    
    if (!_colorArray) {
        _colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor blackColor],[UIColor yellowColor],[UIColor orangeColor]];
    }
    return _colorArray;
}

/**
 *  设置数据数组,三种测试的数据完全填充完毕;
 */
-(void)setUpInfo{
    
    self.SimplifyModelArray = [NSMutableArray array];
    self.ColorInContrastModelArray = [NSMutableArray array];
    self.ComplicationModelArray = [NSMutableArray array];
    
    for (int i = 0; i < 20; i ++) {
        [self.SimplifyModelArray addObject:[self getModelForType:StroopTestsTypeSimplify]];
    }
    for (int i = 0; i < 20; i ++) {
        [self.ColorInContrastModelArray addObject:[self getModelForType:StroopTestsTypeInContrast]];
    }
    for (int i = 0; i < 20; i ++) {
        [self.ComplicationModelArray addObject:[self getModelForType:StroopTestsTypeComplication]];
    }
}

-(NSArray *)textArray{
    if (!_textArray) {
        _textArray = @[@"红",@"蓝",@"绿",@"黑",@"黄",@"橙"];
    }
    return _textArray;
}

-(StroopModel*)getModelForType:(StroopTestType)type{
    
    NSInteger counts = self.colorArray.count;
    
    if (type == StroopTestsTypeSimplify) {
        StroopModel *model = [[StroopModel alloc] init];
        
        model.textColor = [UIColor blackColor];
//        model.showTime = 1 + arc4random()%200/100.0;
        model.showTime  = 1.5f;
        
        model.showText = self.textArray[arc4random()%counts];
        
        return model;
    }else{
        
        StroopModel *model = [[StroopModel alloc] init];
        
        model.textColor = self.colorArray[arc4random()%counts];
//        model.showTime = 1 + arc4random()%200/100.0;
        model.showTime  = 1.5f;
        model.showText = self.textArray[arc4random()%counts];
        
        return model;
    }
}

/**
 *  设置 label 的属性
 */
-(void)settingUi{
    
    self.showWordsLabel = ({
        
        self.showWordsLabel = [[UILabel alloc] init];
        
        self.showWordsLabel.font = [UIFont boldSystemFontOfSize:39];
        
        self.showWordsLabel.adjustsFontSizeToFitWidth = YES;
        
        self.showWordsLabel.height = self.showWordsLabel.width = self.width * .1;
        
        self.showWordsLabel.centerX = self.centerX;
        
        self.showWordsLabel.centerY = self.height * .5;
        
        self.showWordsLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.showWordsLabel];
        
        self.showWordsLabel;
    });
    
    self.tipsLabel = ({
        
        self.tipsLabel = [[UILabel alloc] init];
        
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        
        self.tipsLabel.font = JSFont(19);
        
        self.tipsLabel.textColor = [UIColor blackColor];
        
        self.tipsLabel.height = self.width * .1;
        
        self.tipsLabel.width = self.width * .5;
        
        self.tipsLabel.centerX = self.centerX;
        
        self.tipsLabel.centerY = self.height * .7;
        
        [self addSubview:self.tipsLabel];
        
        self.tipsLabel.text = @"请按照规则进行操作";
        
        self.tipsLabel;
        
    });
}

-(void)setLabelTextColor:(UIColor *)labelTextColor{
    if (_labelTextColor != labelTextColor) {
        _labelTextColor = labelTextColor;
        [self.showWordsLabel setTextColor:_labelTextColor];
    }
}

/**
 *  初始化方法
 *  依然需要设置 frame 和加入 superview
 */
+(instancetype)test{
    return [[self alloc] init];
}


/**
 *  简单测试.   高内聚,低耦合.
 */
-(void)showSimplify{
    self.setAnimationOn = YES;
    
    self.StroopTestType = StroopTestsTypeSimplify;
    
    [self settingUi];
    
    self.currentCount = 0;
    
    [self addGestureRecognizer:self.clickScreen];
    
    [self seeLabel];
    
    self.tipsLabel.hidden = NO;
    
    [[timerTool tool] fireInTheHoll:self.timeTimer];
}



-(void)showComplication{
    self.setAnimationOn = YES;
    self.StroopTestType = StroopTestsTypeComplication;
    
    
    [self settingUi];
    
    self.currentCount = 0;
    
    [self seeLabel];
    self.tipsLabel.hidden = NO;
    
    [self addGestureRecognizer:self.clickScreen];
    
    //    [[timerTool tool] fireInTheHoll:self.actionTimer];
    
    [[timerTool tool] fireInTheHoll:self.timeTimer];
    
}

-(void)showColorInContrast{
    self.setAnimationOn = YES;
    self.StroopTestType = StroopTestsTypeInContrast;
    
    
    [self settingUi];
    self.tipsLabel.hidden = NO;
    
    self.currentCount = 0;
    
    [self seeLabel];
    
    [self addGestureRecognizer:self.clickScreen];
    
    //    [[timerTool tool] fireInTheHoll:self.actionTimer];
    
    [[timerTool tool] fireInTheHoll:self.timeTimer];
    
}


//定时器方法
/**
 *  暂时未定用来干什么
 */
-(void)doSomeThing{
    
    
    
}


/**
 *  定时器方法  此方法会一直全程执行, 知道任务结束;
 */
-(void)someThingForNothing{
    
    /**
     *  timetravel 是当前经过的时间,一直随时间增长
     */
    self.timeTravel += 0.01;
    self.currentTimeTravel += 0.01;
    
    if (self.currentTimeTravel >= self.currentShowTime) {
        self.currentTimeTravel = 0;
        self.currentCount++;
        if (self.currentCount >= 20) {
            
            self.setAnimationOn = NO;
            
            [self.timeTimer invalidate];
            
            [self.actionTimer invalidate];
            
            
            self.tipsLabel.hidden = YES;
            
            self.timeTimer = nil;
            self.actionTimer = nil;
            
            [self removeGestureRecognizer:self.clickScreen];
            
            self.showWordsLabel.text = @"";
            
            if (self.StroopTestType == StroopTestsTypeSimplify) {
                if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihSimplifyTest:)]) {
                    [self.delegate StroopTestsDidFinsihSimplifyTest:self];
                }
                
            }else if(self.StroopTestType == StroopTestsTypeComplication){
                if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihComplicationTest:)]) {
                    [self.delegate StroopTestsDidFinsihComplicationTest:self];
                }
                
            }else{
                if ([self.delegate respondsToSelector:@selector(StroopTestsDidFinsihInContrastTest:)]) {
                    [self.delegate StroopTestsDidFinsihInContrastTest:self];
                }
                
            }
            return;
        }
        
        [self performSelectorOnMainThread:@selector(seeLabel) withObject:nil waitUntilDone:nil];
    }
}

/**
 *  根据 currentCount 显示 label
 */
-(void)seeLabel{
    StroopModel *model;
    if (self.StroopTestType == StroopTestsTypeSimplify) {
        model = self.SimplifyModelArray[self.currentCount];
    }else if(self.StroopTestType == StroopTestsTypeComplication){
        model = self.ComplicationModelArray[self.currentCount];
    }else{
        model = self.ColorInContrastModelArray[self.currentCount];
    }
    [self.showWordsLabel JSLabel_StarAnimationWithDirection:JSFakeAnimationRight toText:model.showText andToColor:model.textColor];
    self.currentShowTime = model.showTime;
}


@end
