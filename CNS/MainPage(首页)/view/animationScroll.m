//
//  animationScroll.m
//  CNS
//
//  Created by Mac on 16/4/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "animationScroll.h"

@interface animationScroll ()

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) NSInteger numberOfCount;

@property (nonatomic,retain) UILabel *tipsLabel;

@property (nonatomic,retain) UIImageView *blackImage;

@property (nonatomic,retain) UISwipeGestureRecognizer *swipRight;


@property (nonatomic,retain) UISwipeGestureRecognizer *swipLeft;

@property (nonatomic,retain) NSTimer *actionTimer;

@end

@implementation animationScroll



-(instancetype)init{
    if (self = [super init]) {
        
        self.currentIndex = 0;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        
        [self addGestureRecognizer:tap];
        
        self.swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipImage:)];
        self.swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipImage:)];
        
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.width, 40)];
        
        UIImageView *blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 40, self.width, 40)];
        
        self.tipsLabel = titleLabel;
        
        self.blackImage = blackView;
        
        [blackView addSubview:titleLabel];
        
        
        blackView.image = [UIImage imageNamed:@"black"];
        
        [self addSubview:blackView];
        
        self.swipRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        
        self.swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        [self addGestureRecognizer:self.swipRight];
        
        [self addGestureRecognizer:self.swipLeft];
        
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

-(void)layoutSubviews{
    self.tipsLabel.frame = CGRectMake(30, 0, self.width, 40);
    self.blackImage.frame = CGRectMake(0, self.height - 40, self.width, 40);
}

+(instancetype)getScroll{
    return [[self alloc]init];
}

-(void)showAnimation{
    [self sd_setImageWithURL:[NSURL URLWithString:[self.delegate animationScroll:self imageForIndex:self.currentIndex]]];
    [self.tipsLabel setTextColor:[UIColor whiteColor]];
    self.tipsLabel.text = [self.delegate animationScroll:self textForIndex:self.currentIndex];
    if (_actionTimer) {
        
    }else{
        
        [self actionTimer];
    
    }
}

//51
//7
//38  13
//6
//44


-(NSTimer *)actionTimer{
    if (!_actionTimer) {
        _actionTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(animationOn) userInfo:nil repeats:YES];
    }
    return _actionTimer;
}

-(NSInteger)numberOfCount{
    return [self.delegate numberOfImageInScrollView:self];
}

-(void)animationOn{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.8f;
    transition.type = @"cube";//rippleEffect cude suckEffect oglFlip pageCurl pageUnCurl cameraIrisHollowOpen cameraIrisHollowClose
    transition.subtype = @"fromRight";//type为fade的时候subtype无效
    
    [self.layer addAnimation:transition forKey:@"animation"];
    
    self.currentIndex ++;
    
    if (self.currentIndex >= [self.delegate numberOfImageInScrollView:self] ) {
        self.currentIndex = 0;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:[self.delegate animationScroll:self imageForIndex:self.currentIndex]]];
    self.tipsLabel.text = [self.delegate animationScroll:self textForIndex:self.currentIndex];
}

-(void)animationOff{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.8f;
    transition.type = @"cube";//rippleEffect cude suckEffect oglFlip pageCurl pageUnCurl cameraIrisHollowOpen cameraIrisHollowClose
    transition.subtype = @"fromLeft";//type为fade的时候subtype无效
    
    [self.layer addAnimation:transition forKey:@"animation"];
    
    self.currentIndex --;
    if (self.currentIndex < 0) {
        self.currentIndex = [self.delegate numberOfImageInScrollView:self] -1;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:[self.delegate animationScroll:self imageForIndex:self.currentIndex]]];
    self.tipsLabel.text = [self.delegate animationScroll:self textForIndex:self.currentIndex];
}

-(void)swipImage:(UISwipeGestureRecognizer *)swip{
    if (self.numberOfCount == 0) {
        return;
    }
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self animationOn];
    }else if(swip.direction == UISwipeGestureRecognizerDirectionRight){
        [self animationOff];
    }
}

-(void)clickImage{
    if ([self.delegate respondsToSelector:@selector(animationScroll:didClickInIndex:)]&&self.numberOfCount != 0) {
        [self.delegate animationScroll:self didClickInIndex:self.currentIndex];
    }
}


@end
