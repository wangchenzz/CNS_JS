

//
//  settingViewController.m
//  CNS
//
//  Created by Mac on 16/5/27.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "settingViewController.h"
#import "loginViewController.h"

@interface settingViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation settingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpTablevewBackColor];
    
    self.title =  @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


// 计算沙盒内文件的大小
- (CGFloat)sizeWithFile:(NSString *)filePath
{
    CGFloat totalSize = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExists = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (isExists) {
        if (isDirectory) {
            NSArray *subPaths =  [mgr subpathsAtPath:filePath];
            for (NSString *subPath in subPaths) {
                NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
                BOOL isDirectory;
                [mgr fileExistsAtPath:fullPath isDirectory:&isDirectory];
                if (!isDirectory) { // 计算文件尺寸
                    NSDictionary *dict =  [mgr attributesOfItemAtPath:fullPath error:nil];
                    totalSize += [dict[NSFileSize] floatValue];;
                }
            }
        }else{
            NSDictionary *dict =  [mgr attributesOfItemAtPath:filePath error:nil];
            totalSize =  [dict[NSFileSize] floatValue];
        }
    }
    return totalSize;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"setting"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
        
        UILabel *quieLabel =[[UILabel alloc] init];
        
        quieLabel.frame = CGRectMake(0, 0, self.view.width, 50);
        
        quieLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [cell.contentView addSubview:quieLabel];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        quieLabel.tag = 1;
    }
    
    UILabel *la = [cell viewWithTag:1];
    
    la.text = @"退出登录";
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIAlertController *quitControl = [UIAlertController alertControllerWithTitle:@"退出当前账号" message:@"请注意,一旦退出登录,你将无法再进行任何操作" preferredStyle:UIAlertControllerStyleAlert];
    
    quitControl.title = @"退出登录!";
    quitControl.message = @"请注意,一旦退出登录,你将无法再进行任何操作";
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf ntmgtc];
        
    }];
    
    [quitControl addAction:action1];
    
    [quitControl addAction:action2];
    
    
    [self presentViewController:quitControl animated:YES completion:nil];
    
}


-(void)ntmgtc{

    /**
     *  清空沙盒
     */
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    
    /**
     *  返回登录界面
     */
    loginViewController *lc = [[loginViewController alloc] init];
    
    self.view.window.rootViewController = lc;
    
    [self.view.window makeKeyAndVisible];

    
    
}


@end
