//
//  tableHeaderButton.m
//  CNS
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "tableHeaderButtonView.h"

@interface tableHeaderButtonView ()

@property (nonatomic,retain) UIScrollView *mainScrollView;

@property (nonatomic,retain) NSMutableArray *buttonArray;

@property (nonatomic,retain) NSMutableArray *titleArray;

@end

/**
 1.不要固定 size 而是在 layoutSubview 里面更新 frame;
 2.使用 kvo 来检测数据的改变
 */

@implementation tableHeaderButtonView


-(instancetype)init{
    if (self = [super init]) {
        _mainScrollView = [[UIScrollView alloc] init];
        [self addSubview:_mainScrollView];
        
        self.buttonArray = [NSMutableArray array];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        
        self.currentIndex = 0;
    }
    return self;
}

+(instancetype)getHeader{
    
    return [[self alloc] init];
    
}

-(void)setDelegare:(id<tableHeaderButtonViewDelegate>)delegare{
    if (_delegare != delegare) {
        _delegare = delegare;
        if ([self.delegare respondsToSelector:@selector(titleArrayForTableHeaderButtonView:)]) {
            self.titleArray = [[self.delegare titleArrayForTableHeaderButtonView:self] mutableCopy];
        }
    }
}

-(void)setTitleArray:(NSMutableArray *)titleArray{
    if (_titleArray != titleArray) {
        _titleArray = titleArray;
        
        int tag = 0;
        for (NSString *titleStr in self.titleArray) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            [but setTitle:titleStr forState:UIControlStateNormal];
//            [but setBackgroundImage:[UIImage imageNamed:@"caitao"] forState:UIControlStateNormal];
            
            
            [but.titleLabel setFont:JSFont(14)];
            
            [but setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.3]];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[NSFontAttributeName] = JSFont(14);
            
            CGRect bounding = [titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        
            but.bounds = bounding;
            
            but.width = but.width + 16 ;
            but.height = but.height + 3;
            
            [but setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            
            [but addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [but setTag:tag];
            
            tag++;
            
            [self.buttonArray addObject:but];
            
        }
        
        [(UIButton *)_buttonArray.firstObject setSelected:YES];
        
        static CGRect lastRect = {{0,0},{0,0}};
        
        for (UIButton *but in self.buttonArray) {
            /**
             *  此时不一定知道 self的 frame;  所以不能制动 button 具体位置;
             */
            but.x = CGRectGetMaxX(lastRect) + 8;
            
            lastRect = but.frame;
            
            [self.mainScrollView addSubview:but];
            
        }
    }
}

-(void)clickButton:(UIButton *)but{
    
    if (_currentIndex == but.tag) {
        return;
    }
    
    UIButton *beforeBu =  _buttonArray[_currentIndex];
    
    beforeBu.selected = NO;

    if ([self.delegare respondsToSelector:@selector(tableHeaderButtonView:didSelecte:)]) {
        [self.delegare tableHeaderButtonView:self didSelecte:but.tag];
        
        but.selected = YES;
        
        self.currentIndex = but.tag;
    }


}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex !=currentIndex) {
        
        UIButton *beforeBu =  _buttonArray[_currentIndex];
        
        beforeBu.selected = NO;
        
        UIButton *nowBu =  _buttonArray[currentIndex];
        
        nowBu.selected = YES;
        
        _currentIndex = currentIndex;
    }
    

}

-(void)layoutSubviews{
    
    static CGSize sss;
    
    
    if (CGSizeEqualToSize(sss, self.frame.size)  ) {
        return;
    }
    self.mainScrollView.frame = self.bounds;
    
    UIButton *but = self.buttonArray.lastObject;
    _mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(but.frame), self.height);
    for (UIButton *but in self.buttonArray) {
        but.centerY = _mainScrollView.centerY;
        
    }
    sss = self.bounds.size;

}


@end
