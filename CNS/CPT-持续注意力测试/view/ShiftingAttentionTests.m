//
//  ShiftingAttentionTests.m
//  CNS
//
//  Created by Mac on 16/3/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "ShiftingAttentionTests.h"

#import "ShiftingAttentionModel.h"

@interface ShiftingAttentionTests ()

/**
 *  三种图形的 layer. 和包含的 view
 */
@property (nonatomic,strong) CAShapeLayer *referenceLayer;

@property (nonatomic,strong) CAShapeLayer *leftLayer;

@property (nonatomic,strong) CAShapeLayer *rightLayer;

@property (nonatomic,strong) UIView *referenceView;

@property (nonatomic,strong) UIView *leftView;

@property (nonatomic,strong) UIView *rightView;

@property (nonatomic,strong) UIBezierPath *roundPath;

@property (nonatomic,strong) UIBezierPath *squarePath;

/**
 *  提示文字的 label
 */
@property (nonatomic,strong) UILabel *tipsLabel;

/**
 *  通过点击色块的方式,来让用户进行响应,
 */
@property (nonatomic,strong) UITapGestureRecognizer *leftTap;
@property (nonatomic,strong) UITapGestureRecognizer *rightTap;

/**
 *  记录当前测试个数-
 */
@property (nonatomic,assign) NSInteger currentCounts;

@property (nonatomic,readonly,getter=isChooseLeft) BOOL chooseLeft;

/**
 *  存放模型的数组-
 */
@property (nonatomic,strong) NSMutableArray *modelCotainArray;

/**
 *  计时器
 */
@property (nonatomic,strong) NSTimer *actionTimer;


/**
 *  一共经过的时间
 */
@property (nonatomic,assign) float totalTime;

/**
 *  当前屏幕测试经过的时间
 */
@property (nonatomic,assign) float currentTime;


@end

@implementation ShiftingAttentionTests

/**
 *  重写初始化方法
 */

-(instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

+(instancetype)test{
    return [[self alloc]init];
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        
        label.width = self.width *.5;
        
        label.height = self.width *.1;
        
        label.centerX = self.centerX;
        
        label.centerY = self.height * .2;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont boldSystemFontOfSize:25];
        
        label.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:label];
        
        self.tipsLabel = label;
    }
    return _tipsLabel;
}

-(BOOL)isChooseLeft{
    ShiftingAttentionModel *model = self.modelCotainArray[self.currentCounts];
    
    if (model.ShifitingTestType == ShifitingTestTypeColor&&model.referenceColorType == model.leftColorType) {
        return YES;
    }
    else if (model.ShifitingTestType == ShifitingTestTyoeForm&&model.referenceFormType == model.leftFormType){
        return YES;
    }
    else{
        return NO;
    }
}

-(UIBezierPath *)roundPath{
    if (!_roundPath) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.width * .1, self.width * .1) radius:self.width * .1 startAngle:0 endAngle:2*M_PI clockwise:YES];
        self.roundPath = path;
    }
    return _roundPath;
}

-(UIBezierPath *)squarePath{
    if (!_squarePath) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake( 0, 0, self.width * .2, self.width * .2)];
        self.squarePath = path;
    }
    return _squarePath;
}


/**
 *  这些layer还没有设置 fillcolor和 path.所以是无法观看的.
 */
-(CAShapeLayer *)referenceLayer{
    if (!_referenceLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.bounds = CGRectMake(0, 0, self.width * .2, self.width * .2);
        layer.position = CGPointMake(0, 0);
        layer.lineWidth = 2;
        _referenceLayer = layer;
    }
    return _referenceLayer;
}

-(CAShapeLayer *)leftLayer{
    if (!_leftLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.bounds = CGRectMake(0, 0,self.width * .2, self.width * .2);
        layer.position = CGPointMake(0, 0);
        layer.lineWidth = 2;
        _leftLayer = layer;
    }
    return _leftLayer;
}

-(CAShapeLayer *)rightLayer{
    if (!_rightLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.bounds = CGRectMake(0, 0, self.width * .2, self.width * .2);
        layer.position = CGPointMake(0, 0);
        layer.lineWidth = 2;
        [self.layer addSublayer:layer];
        _rightLayer = layer;
    }
    return _rightLayer;
}



/**
 *  从这开始是 view
 */

-(UIView *)referenceView{
    if (!_referenceView) {
        UIView *view = [[UIView alloc] init];
        
        view.height = view.width = self.width * .2;
        
        view.centerX = self.centerX;
        
        view.centerY = self.height *.3;
        
        [self addSubview:view];
        
        [view.layer addSublayer:self.referenceLayer];
        
        self.referenceView = view;
    }
    return _referenceView;
}

-(UIView *)leftView{
    if (!_leftView) {
        UIView *view = [[UIView alloc] init];
        
        view.height = view.width = self.width * .2;
        
        view.centerY = self.height * .7;
        
        view.centerX = self.width *.3;
        
        [self addSubview:view];
        
        [view.layer addSublayer:self.leftLayer];
        
        self.leftView = view;
    }
    return _leftView;

}

-(UIView *)rightView{
    if (!_rightView) {
        UIView *view = [[UIView alloc] init];
        
        [view.layer addSublayer:self.rightLayer];
        
        view.height = view.width = self.width * .2;
        
        view.centerY = self.height * .7;
        
        view.centerX = self.width *.7;
        
        [self addSubview:view];
        
        [view.layer addSublayer:self.rightLayer];
        
        self.rightView = view;
    }
    return _rightView;

}

-(UITapGestureRecognizer *)leftTap{
    if (!_leftTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick)];
        
        self.leftTap = tap;
    }
    return _leftTap;
}

-(UITapGestureRecognizer *)rightTap{
    if (!_rightTap) {
   
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)];
        
        self.rightTap = tap;
    }
    return _rightTap;
}

-(void)leftClick{
    
    if ([self.delegate respondsToSelector:@selector(ShiftingAttentionTests:clickInCount:clickIsRight:andClickPTime:)]) {
        [self.delegate ShiftingAttentionTests:self clickInCount:self.currentCounts clickIsRight:self.isChooseLeft andClickPTime:self.currentTime];
    }
    
    self.currentCounts ++;
    
    if (self.currentCounts >= self.modelCotainArray.count) {
        self.currentCounts = 0 ;
        [self.actionTimer invalidate];
        if ([self.delegate respondsToSelector:@selector(ShiftingAttentionTestsDidFinsih:)]) {
            [self.delegate ShiftingAttentionTestsDidFinsih:self];
        }
        
        return;
    }
    
    [self seeThis];
    
    self.currentTime = 0;
}

-(void)rightClick{
    
    if ([self.delegate respondsToSelector:@selector(ShiftingAttentionTests:clickInCount:clickIsRight:andClickPTime:)]) {
        [self.delegate ShiftingAttentionTests:self clickInCount:self.currentCounts clickIsRight:!self.isChooseLeft andClickPTime:self.currentTime];
    }
    self.currentCounts ++;
    if (self.currentCounts >= self.modelCotainArray.count) {
        self.currentCounts = 0 ;
        [self.actionTimer invalidate];
        if ([self.delegate respondsToSelector:@selector(ShiftingAttentionTestsDidFinsih:)]) {
            [self.delegate ShiftingAttentionTestsDidFinsih:self];
        }
        return;
    }
    [self seeThis];
    self.currentTime = 0;
}

/**
 *  这个名字还要改
 */
-(void)beginOneTest{
    
    self.setAnimationOn = YES;

    [self.rightView addGestureRecognizer:self.rightTap];
    
    [self.leftView addGestureRecognizer:self.leftTap];
    
    [self.referenceView viewWithTag:1];
    
    self.actionTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    self.totalTime = 0;
    self.currentTime = 0;
    [self seeThis];
    [[timerTool tool] fireInTheHoll:self.actionTimer];
}

-(void)timeRun{
    self.currentTime += 0.01;
    self.totalTime += 0.01;
    
    if (self.currentTime >=3&&self.currentTime < 3.2) {
        self.leftView.hidden = YES;
        self.rightView.hidden = YES;
        self.referenceView.hidden = YES;
        
    }
    
    if (self.currentCounts >= self.modelCotainArray.count) {
        
        self.setAnimationOn = NO;
        
        self.currentCounts = 0 ;
        [self.actionTimer invalidate];
        
        if ([self.delegate respondsToSelector:@selector(ShiftingAttentionTestsDidFinsih:)]) {
            [self.delegate ShiftingAttentionTestsDidFinsih:self];
        }
        
        return;
        }
    
    
    if (self.currentTime >= 3.2) {
        self.currentCounts ++;
        
        
        [self performSelectorOnMainThread:@selector(seeThis) withObject:nil waitUntilDone:nil];
        
        self.currentTime = 0;
        
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        self.referenceView.hidden = NO;     }
    

}


-(ShiftingAttentionModel *)getModel{

    ShiftingAttentionModel *model = [[ShiftingAttentionModel alloc] init];
    
    model.ShifitingTestType = arc4random()%2?ShifitingTestTypeColor:ShifitingTestTyoeForm;
    model.referenceColorType = arc4random()%2?ShifitingColorTyoeGreen:ShifitingColorTypeRed;
    model.referenceFormType = arc4random()%2?ShifitingFormTypeRound:ShifitingFormTypeSquare;
    model.leftColorType = arc4random()%2?ShifitingColorTyoeGreen:ShifitingColorTypeRed;
    model.leftFormType = arc4random()%2?ShifitingFormTypeRound:ShifitingFormTypeSquare;
    return model;
    
}

-(NSMutableArray *)modelCotainArray{

    if (!_modelCotainArray) {
        self.modelCotainArray = [NSMutableArray array];
        for (int i = 0 ; i < 20; i ++) {
            [self.modelCotainArray addObject:[self getModel]];
        }
    }
    return _modelCotainArray;
}

-(void)seeThis{
    
    if (self.currentCounts>=self.modelCotainArray.count) {
        [self.referenceView removeFromSuperview];
        [self.leftView removeFromSuperview];
        [self.rightView removeFromSuperview];
        [self.tipsLabel removeFromSuperview];
        return;
    }
    
    ShiftingAttentionModel *model = self.modelCotainArray[self.currentCounts];
    
    self.tipsLabel.text = model.ShifitingTestType == ShifitingTestTypeColor ? @"请选择颜色相同的":@"请选择形状相同的";
    
    self.referenceLayer.path = model.referenceFormType == ShifitingFormTypeRound ? self.roundPath.CGPath:self.squarePath.CGPath;
    
    self.referenceLayer.fillColor = model.referenceColorType == ShifitingColorTyoeGreen ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
    
    self.leftLayer.path = model.leftFormType == ShifitingFormTypeRound ? self.roundPath.CGPath:self.squarePath.CGPath;

    self.leftLayer.fillColor = model.leftColorType == ShifitingColorTyoeGreen ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;

    self.rightLayer.path = model.leftFormType != ShifitingFormTypeRound ? self.roundPath.CGPath:self.squarePath.CGPath;

    self.rightLayer.fillColor = model.leftColorType != ShifitingColorTyoeGreen ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
    
    /**
     *  考虑再三, 这里还是不要使用动画效果比较好.
     */
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
//    
//    animation.fromValue = (id)self.referenceLayer.path;
//    
//    animation.toValue = (id)self.squarePath.CGPath;
//    
//    animation.duration = 0.5 ;
//    
//    animation.removedOnCompletion = NO;
//    
//    animation.fillMode = kCAFillModeBoth;;
//    
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    
//    /**
//     *  endStatus
//     */
//    
//    //    self.referenceLayer.path = self.squarePath.CGPath;
//    
//    animation.delegate = self;
//    
//    [self.referenceLayer addAnimation:animation forKey:@"1"];

}

@end
