//
//  showLevelController.m
//  CNS
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "normalShowLevelController.h"

#import "showLevelCell.h"

@interface normalShowLevelController ()

@property (nonatomic,strong) NSMutableArray *nameArray;

@property (nonatomic,strong) NSMutableArray *valueArray;

@end

@implementation normalShowLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = NO;
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTestsList:(JSTestsList *)testsList{
    if (_testsList != testsList) {
        _testsList = testsList;
        NSMutableArray *array = [@[@"-即时正确点击次数-",@"-即时错误点击次数-",@"-即时正确点击次数-",@"-即时错误点击次数-",@"-左手平均点击次数-",@"-右手平均点击次数-",@"-正确选择-",@"-错误选择-",@"-简单反应时间-",@"-正确复杂反应时间-",@"-错色反应时间-",@"-正确反应次数-",@"-失误次数-",@"-正确反应时间-",@"-正确次数-",@"-错过次数-",@"-失误次数-",@"-反应时间-"] mutableCopy] ;
        
        self.nameArray = array;
        
        NSString *VBMcrc = [NSString stringWithFormat:@"%ld",testsList.VBMimmediateRightReaction];
        NSString *VBMcwc = [NSString stringWithFormat:@"%ld",testsList.VBMimmediateWrongReaction];
        
        NSString *cwc = [NSString stringWithFormat:@"%ld",testsList.VIMimmediateRightReaction];
        NSString *VIMcwc = [NSString stringWithFormat:@"%ld",testsList.VIMimmediateWrongReaction];
        
        NSString *leftCount = [NSString stringWithFormat:@"%ld",(testsList.left1ClickCount + testsList.left2ClickCount+testsList.left3ClickCount)/3];
        NSString *rightCount = [NSString stringWithFormat:@"%ld",(testsList.right1ClickCount + testsList.right2ClickCount+testsList.right3ClickCount)/3];
        
        NSString *SDCr = [NSString stringWithFormat:@"%ld",testsList.SDCRightSelect];
        NSString *SDCw = [NSString stringWithFormat:@"%ld",testsList.SDCWrongSelect];
        float simTime;
        for (NSNumber *a in testsList.SimplifyTime) {
            simTime += a.floatValue;
        }
        float Complic;
        for (NSNumber *a in testsList.ComplicationTime) {
            Complic += a.floatValue;
        }
        float InContrast;
        for (NSNumber *a in testsList.InContrastTime) {
            InContrast += a.floatValue;
        }
        
        
        NSString *simTimeStr = (_testsList.SimplifyTime.count == 0)? @"0":[NSString stringWithFormat:@"%.3f s",(simTime/_testsList.SimplifyTime.count)];
        
        NSString *compTimeStr = (_testsList.ComplicationTime.count == 0)? @"0":[NSString stringWithFormat:@"%.3f s",(Complic/_testsList.ComplicationTime.count)];
        
        NSString *contrasTimeStr = (_testsList.InContrastTime.count == 0)? @"0":[NSString stringWithFormat:@"%.3f s",(InContrast/_testsList.InContrastTime.count)];
        
        
        NSString *trueCount = [NSString stringWithFormat:@"%ld",testsList.trueCount];
        
        NSString *wrongCount = [NSString stringWithFormat:@"%ld",testsList.wrongCount];
        
        NSString *trueTime ;
        
        if (_testsList.trueCount == 0) {
            trueTime = @"0";
        }else{
        
        
        trueTime = [NSString stringWithFormat:@"%.3f s",_testsList.trueReatctiionTime/_testsList.trueCount];
        }
        
        NSString *CPTTrueCount = [NSString stringWithFormat:@"%ld",testsList.CPTTrueCount];
        
        
        /**
         *  错过次数
         */
        NSString *CPTMissCount= [NSString stringWithFormat:@"%ld",testsList.CPTMissCount];
        
        /**
         *  错误次数
         */
        NSString *CPTWrongCount= [NSString stringWithFormat:@"%ld",testsList.CPTWrongCount];
        
        /**
         *  反应时间
         */
        
        NSString *CPTTime;
        if (_testsList.CPTTrueCount == 0) {
            CPTTime = @"";
        }else{
        
            CPTTime= [NSString stringWithFormat:@"%.3f s",_testsList.CPTTime/_testsList.CPTTrueCount];
        }
        self.valueArray = [NSMutableArray arrayWithObjects:VBMcrc,VBMcwc,cwc,VIMcwc,leftCount,rightCount,SDCr,SDCw,simTimeStr,compTimeStr,contrasTimeStr,trueCount,wrongCount,trueTime,CPTTrueCount,CPTMissCount,CPTWrongCount,CPTTime, nil];
        
        
        
        [self upLoadData];
        
        
    }
}
-(void)upLoadData{

    
    NSString *sbStr = [self.valueArray componentsJoinedByString:@","];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"difficulty"] = @"0";
    dic[@"sub_Id"] = @"0";
    dic[@"type"] = @"0";
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    
    
    dic[@"correct"] = sbStr;
    [[INetworking shareNet] GET:addRecord withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        JSLog(@"%d",isSuccess);
        
        JSLog(@"%@",returnObject);
        
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 2;
    }else if (section < 6){
        return 3;
    }else{
        return 4;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"  语言注意力测试";
            break;
        case 1:
            return @"  视觉注意力测试";
            break;
        case 2:
            return @"  手指点击测试";
            break;
        case 3:
            return @"  符号位数测试";
            break;
        case 4:
            return @"  颜色反差测试";
            break;
        case 5:
            return @"  注意力转移测试";
            break;
        default:
            return @"  持续注意力测试";
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    showLevelCell *cell = [showLevelCell cellForTableview:self.tableView];
    
    NSInteger indx;
    
    if (indexPath.section < 4) {
        indx = indexPath.section * 2 + indexPath.row;
        
    }else if (indexPath.section < 6){
        
        indx = 8 + (indexPath.section - 4)*3 + indexPath.row;
        
    }else{
        
        indx = 14 + indexPath.row;
    }
    
    
    cell.nameLabel.text = self.nameArray[indx];
    cell.valueLabel.text = self.valueArray[indx];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
    
}





@end
