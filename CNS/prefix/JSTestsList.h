//
//  JSTestsList.h
//  CNS
//
//  Created by Mac on 16/4/14.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSTestsList : NSObject

//语言注意力测试
/**
 *  即时正确点击次数
 */

@property (nonatomic,assign) NSInteger VBMimmediateRightReaction;

/**
 *  即时错误点击次数
 */
@property (nonatomic,assign) NSInteger VBMimmediateWrongReaction;

/**
 *  延时正确点击次数
 */
@property (nonatomic,assign) NSInteger VBMdelayedRightReaction;

/**
 *  延时错误点击次数
 */
@property (nonatomic,assign) NSInteger VBMdelayedWrongReaction;

//视觉注意力测试
/**
 *  即时正确的点击次数
 */
@property (nonatomic,assign) NSInteger VIMimmediateRightReaction;

/**
 *  即时错误点击次数
 */
@property (nonatomic,assign) NSInteger VIMimmediateWrongReaction;

/**
 *  延时正确点击次数
 */
@property (nonatomic,assign) NSInteger VIMdelayedRightReaction;

/**
 *  延时错误点击次数
 */
@property (nonatomic,assign) NSInteger VIMdelayedWrongReaction;


//手指点击测试.

/**
 *  左手第一次
 */
@property (nonatomic,assign) NSInteger left1ClickCount;

/**
 *  左手第二次
 */
@property (nonatomic,assign) NSInteger left2ClickCount;

@property (nonatomic,assign) NSInteger left3ClickCount;

@property (nonatomic,assign) NSInteger right1ClickCount;

@property (nonatomic,assign) NSInteger right2ClickCount;

@property (nonatomic,assign) NSInteger right3ClickCount;

//符号位数测试;
@property (nonatomic,assign) NSInteger SDCRightSelect;

@property (nonatomic,assign) NSInteger SDCWrongSelect;

/**
 *  颜色反差测试,又叫斯特鲁普测试
 */

/**
 *  简单反应时间
 */
@property (nonatomic,retain) NSMutableArray* SimplifyTime;



/**
 *  正确复杂反应时间
 */
@property (nonatomic,retain) NSMutableArray* ComplicationTime;

/**
 *  正确错色反应时间
 */
@property (nonatomic,retain) NSMutableArray* InContrastTime;


/**
 *  注意力转移测试
 */

/**
 *  正确反应次数
 */
@property (nonatomic,assign) NSInteger trueCount;

/**
 *  失误次数
 */
@property (nonatomic,assign) NSInteger wrongCount;

/**
 *  正确反应时间
 */
@property (nonatomic,assign) float trueReatctiionTime;

/**
 *  持续注意力测试
 */

/**
 *  正确次数
 */
@property (nonatomic,assign) NSInteger CPTTrueCount;

/**
 *  错过次数
 */
@property (nonatomic,assign) NSInteger CPTMissCount;

/**
 *  错误次数
 */
@property (nonatomic,assign) NSInteger CPTWrongCount;

/**
 *  反应时间
 */
@property (nonatomic,assign) float CPTTime;


@end
