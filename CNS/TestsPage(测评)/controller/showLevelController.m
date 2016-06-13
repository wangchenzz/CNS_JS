//
//  showLevelController.m
//  CNS
//
//  Created by Mac on 16/5/18.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "showLevelController.h"

#import "showLevelModel.h"

#import "showLevelCell.h"

@interface showLevelController ()

@property (nonatomic,retain) NSMutableArray *moduleModelArray;

@property (nonatomic,retain) NSMutableArray *normalModelArray;

@property (nonatomic,retain) UISegmentedControl *chooseSegment;

@property (nonatomic,assign) NSInteger curPage;

@end

@implementation showLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    /**
     *  在这里传输模块次
     *
     *  @return
     */
    self.curPage = 1;
    
    self.tableView.separatorStyle = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    self.moduleModelArray = [NSMutableArray array];
     self.normalModelArray = [NSMutableArray array];
    if(!_isUpload){
    self.modelArray = self.normalModelArray;
    }
    
    [self decide];
    
    [self returnPage];
}

-(void)returnPage{
    if (_isUpload) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [but setTitle:@"< 返回" forState: UIControlStateNormal];
        
        [but setFrame:CGRectMake(0, 0, 64, 44)];
 
        
        
        [but addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:but];
        
        [self.navigationItem setLeftBarButtonItem:item];
    }
}

-(void)popTo{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)decide{
    if (_isUpload) {
        showLevelModel *model = _modelArray[0];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"difficulty"] = model.diffLevel;
        dic[@"sub_Id"] = model.testId;
        dic[@"type"] = [NSString stringWithFormat:@"%ld",model.TestType];
        dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
        dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        
        
        NSArray *parmasArray = @[@"correct",@"error",@"delayed_c",@"delayde_e"];
        
        for (int i = 0 ; i < model.valueArray.count; i ++) {
            dic[parmasArray[i]] = model.valueArray[i];
        }
        
        [[INetworking shareNet] GET:addRecord withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            if (!isSuccess) {
                [MBProgressHUD showError:@"上传失败"];
            }
            
        }];
        
    }else{
        
        [self getRecords];
        
        __weak __typeof__(self)weakSelf = self;
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf getRecords];
            
            [weakSelf.tableView.mj_footer beginRefreshing];
            
        }];

        
        
        _chooseSegment = [[UISegmentedControl alloc] initWithItems:@[@"标准测试",@"模块测试"]];
        
        _chooseSegment.selectedSegmentIndex = 0;
        
        self.navigationItem.titleView = _chooseSegment;
        
        [_chooseSegment addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
        
    }

}
-(void)getRecords{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
    
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.curPage];
    
    [[INetworking shareNet] GET:getRecord withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        /**
         *  得到数据
         */
        if (isSuccess) {
            
            NSArray *containArray = returnObject[@"list"];
            for (NSDictionary *dic in containArray) {
                showLevelModel *model = [[showLevelModel alloc] init];
                /**
                 *  判断是否是模块测试
                 */
                if ([dic[@"type"] isEqualToString:@"0"] ) {
                    /**
                     *  这里是标准测试;
                     */
                    model.TestType = [dic[@"type"] integerValue];;
                    
                    model.testTime = @"createTime";
                    
                    NSString *valueString = dic[@"correct"];
                    NSArray *valueAry = [valueString componentsSeparatedByString:@","];
                    
                    
                    model.valueArray = valueAry;
                    
                    model.nameArray = @[@"-即时正确点击次数-",@"-即时错误点击次数-",@"-即时正确点击次数-",@"-即时错误点击次数-",@"-左手平均点击次数-",@"-右手平均点击次数-",@"-正确选择-",@"-错误选择-",@"-简单反应时间-",@"-正确复杂反应时间-",@"-错色反应时间-",@"-正确反应次数-",@"-失误次数-",@"-正确反应时间-",@"-正确次数-",@"-错过次数-",@"-失误次数-",@"-反应时间-"];
                    model.testTitle = @"标准测试";
                    
                    [self.normalModelArray addObject:model];
                    
                    
                }else{
                    /**
                     *  这里是模块测试;
                     */


                    
                    model.diffLevel = @"difficulty";
                    
                    model.TestType = [dic[@"type"] integerValue];;
                    
                    model.testId = @"id";
                    model.testTime = @"createTime";
                    
                    switch (model.TestType) {
                        case 1:
                        {
                            /**
                             *  1
                             */
                            model.testTitle = @"语言注意力测试";
                            
                            NSString *VBMcrc = dic[@"correct"];
                            NSString *VBMcwc = dic[@"error"];
                            
                            model.valueArray = @[VBMcrc,VBMcwc];
                            
                            model.nameArray = @[@"-即时正确点击次数-",@"-即时错误点击次数-"];
                            
                            model.TestType = 1;
                        }
                            break;
                        case 2:
                        {
                            /**
                             *  2
                             */
                            model.testTitle = @"图像注意测验";
                            NSString *cwc = dic[@"correct"];;
                            NSString *VIMcwc = dic[@"error"];
                            
                            model.valueArray = @[cwc,VIMcwc];
                            model.nameArray = @[@"-即时正确点击次数-",@"-即时错误点击次数-"];
                            
                            model.TestType = 2;
                            
                        }
                            break;
                            
                        case 3:
                        {
                            /**
                             *  3
                             */
                            model.testTitle = @"手指敲击测试";
                            
                            NSString *leftCount = dic[@"correct"];
                            NSString *rightCount = dic[@"error"];
                            model.valueArray = @[leftCount,rightCount];
                            model.nameArray = @[@"-左手平均点击次数-",@"-右手平均点击次数-"];
                            
                            model.TestType = 3;
                            
                            
                        }
                            break;
                            
                        case 4:
                        {
                            /**
                             *  4
                             */
                            model.testTitle = @"符号数字编码";
                            NSString *SDCr = dic[@"correct"];
                            NSString *SDCw = dic[@"error"];
                            model.valueArray = @[SDCr,SDCw];
                            model.nameArray = @[@"-正确选择-",@"-错误选择-"];
                            
                            model.TestType = 4;
                        }
                            break;
                            
                        case 5:
                        {
                            /**
                             *  5
                             */
                            model.testTitle = @"斯特鲁普测试";
                            
                            
                            
                            NSString *simTimeStr = dic[@"correct"];
                            
                            NSString *compTimeStr = dic[@"error"];
                            NSString *contrasTimeStr = dic[@"delayed_c"];
                            
                            model.valueArray = @[simTimeStr,compTimeStr,contrasTimeStr];
                            
                            model.nameArray = @[@"-简单反应时间-",@"-正确复杂反应时间-",@"-错色反应时间-"];
                            
                            model.TestType = 5;
                        }
                            break;
                            
                        case 6:
                        {
                            /**
                             *  6
                             */
                            model.testTitle = @"注意力转移测试";
                            
                            NSString *trueCount = dic[@"correct"];
                            
                            NSString *wrongCount = dic[@"error"];
                            
                            NSString *trueTime = dic[@"delayed_c"];
                            
                            model.valueArray = @[trueCount,wrongCount,trueTime];
                            
                            model.nameArray = @[@"-正确反应次数-",@"-失误次数-",@"-正确反应时间-"];
                            
                            
                            model.TestType = 6;
                            
                        }
                            break;
                            
                        case 7:
                        {
                            
                            /**
                             *  7
                             */
                            model.testTitle = @"持续性操作测验";
                            
                            NSString *CPTTrueCount = dic[@"correct"];
                            
                            
                            /**
                             *  错过次数
                             */
                            NSString *CPTMissCount= dic[@"error"];
                            
                            /**
                             *  错误次数
                             */
                            NSString *CPTWrongCount= dic[@"delayed_c"];
                            
                            /**
                             *  反应时间
                             */
                            NSString *CPTTime= dic[@"delayed_e"];
                            
                            model.nameArray = @[@"-正确次数-",@"-错过次数-",@"-失误次数-",@"-反应时间-"];
                            model.valueArray = @[CPTTrueCount,CPTMissCount,CPTWrongCount,CPTTime];
                            
                            model.TestType = 7;
                        }
                            break;
                            
                            /**
                             *
                             */
                            
                        default:
                            break;
                    }
                [self.moduleModelArray addObject:model];
                }
                
                
                
            }
            [self.tableView.mj_footer endRefreshing];
            
            self.curPage ++;
            
            [self.tableView reloadData];
        }
        
        
    }];
}


-(void)changed:(UISegmentedControl*)seg{
    if(seg.selectedSegmentIndex == 0){
        /**
         *  这里装在标准测试记录/
         */
        
        self.modelArray = self.normalModelArray;
        
        [self.tableView reloadData];
    
    }else{
        /**
         *  这里是模块测试记录
         */
        
        self.modelArray = self.moduleModelArray;
        
        [self.tableView reloadData];
        
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    showLevelModel *mm = _modelArray[section];
    
    
    return mm.valueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    showLevelCell *cell = [showLevelCell cellForTableview:self.tableView];
    
    
    showLevelModel *mm = _modelArray[indexPath.section];
    cell.nameLabel.text = mm.nameArray[indexPath.row];
    cell.valueLabel.text = mm.valueArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    showLevelModel *mm = _modelArray[section];

    NSString *TestTitle = mm.testTitle;
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSString *headTitle = [NSString stringWithFormat:@"%@ / %@",TestTitle,[dateStr substringToIndex:10]];
    
    return headTitle;
}




@end
