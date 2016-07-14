//
//  profileViewController.m
//  CNS
//
//  Created by Mac on 16/5/19.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "profileViewController.h"

#import "settingViewController.h"

#import "ShowPersonalBBSViewController.h"

#import "TheRerunSgViewContoller.h"

#import "tousuJubaoController.h"

#import <AVFoundation/AVFoundation.h>

@interface profileViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat contentImageBj;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIVisualEffectView *visualView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *anotherLabel;
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, retain) UIImage *oldBackNaviIm;

@property (nonatomic, retain) NSMutableArray *ary;


@property (nonatomic,retain) UIView *sourceViewClear;


@property (nonatomic, assign) BOOL isPushing;
@end

@implementation profileViewController
- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    
//    self.ary = [NSMutableArray array];
    self.headerHeight = 300;
    [self setUpHeader];
    
    [self.view addSubview:self.tableView];
    
    [self doImportant];

    
    
    
}


-(void)doImportant{

    self.oldBackNaviIm = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


-(void)setUpHeader{
    //header
    CGRect bounds = CGRectMake(0, 0, self.view.width, self.headerHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:bounds];
    contentView.backgroundColor = [UIColor whiteColor];
    //背景
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.bounds = bounds;
    headerImageView.height = contentView.height * .5f;
    
    self.contentImageBj = contentView.height  - headerImageView.height;
    
    headerImageView.x = contentView.x;
    
    headerImageView.y = contentView.y;
    
    contentView.layer.masksToBounds = YES;
    
    /**
     *  添加模糊试图;
     */
    
    
    UIVisualEffectView *backVisual = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    //将模糊视图的大小等同于自身
    backVisual.frame = headerImageView.bounds;
    //设置模糊视图的透明度
    backVisual.alpha = 0.98;
    
    [headerImageView addSubview:backVisual];
    
//    [headerImageView sendSubviewToBack:backVisual];
    
    self.visualView = backVisual;
    
    
    
    
    self.headerImageView = headerImageView;
    
    self.headerContentView = contentView;
    
    [self.headerContentView addSubview:self.headerImageView];
    self.headerContentView.layer.masksToBounds = YES;
    
    //信息内容
    
    UIImageView *icon = [[UIImageView alloc] init];
    
    icon.width = icon.height = 100;
    
    icon.centerX = self.view.centerX;
    
    icon.centerY = CGRectGetMaxY(self.headerImageView.frame);
    
    
    icon.backgroundColor = [UIColor clearColor];
    
    
    NSString *headerImageStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"img"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",basicUrlStr,headerImageStr];
    
    [icon sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    
    
    icon.layer.cornerRadius = 100/2.0f;
    icon.layer.masksToBounds = YES;
    icon.layer.borderWidth = 1.0f;
    icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.headerContentView addSubview:icon];
    
    
    /**
     *  更改头像
     */
    icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)];
    
    [icon addGestureRecognizer:tap];
    
    self.icon = icon;
    
    UILabel *label = [[UILabel alloc] init];
    
    label.height = 50;
    
    label.width = self.view.width;
    
    label.centerX = self.view.centerX;
    
    label.centerY = CGRectGetMaxY(self.icon.frame) + 25;
    
    label.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"nickName"];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.numberOfLines = 0;
    self.label = label;
    
    
    UILabel *another = [[UILabel alloc] init];
    
    another.height = 50;
    
    another.width = self.view.width;
    
    another.centerX = self.view.centerX;
    
    another.centerY = CGRectGetMaxY(self.label.frame) + 15;
    
    another.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobile"];
    another.textColor = [UIColor grayColor];
    another.textAlignment = NSTextAlignmentCenter;
    another.font = [UIFont boldSystemFontOfSize:15];
    another.numberOfLines = 0;
    self.anotherLabel = another;
    
    
    [self.headerContentView addSubview:self.anotherLabel];
    
    [self.headerContentView addSubview:self.label];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:bounds];
    [headerView addSubview:self.headerContentView];
    
    self.tableView.tableHeaderView = headerView;;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setNavi{
//    UIColor *color = [UIColor colorWithRed:170/255.0 green:60/255.0 blue:99/255.0 alpha:0];
//    UIImage *image = [UIImage imageWithBgColor:color];
//    
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    //去掉底部线条
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];


}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_isPushing) {
        return;
    }

    CGFloat offset_Y = scrollView.contentOffset.y;
    
    CGFloat alpha = (offset_Y )/300.0f;
    
    
    UIColor *color = [UIColor colorWithRed:170/255.0 green:60/255.0 blue:99/255.0 alpha:alpha];
    UIImage *image = [UIImage imageWithBgColor:color];
//
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    /**
     *  上面用来 完成导航条透明效果;
     */
    if (offset_Y < 0) {
        //放大比例
        CGFloat add_topHeight = -(offset_Y);
        self.scale = (self.headerHeight+add_topHeight)/self.headerHeight;
        //改变 frame
        CGRect contentView_frame = CGRectMake(0, -add_topHeight, self.view.width, self.headerHeight+add_topHeight);
        
        self.headerContentView.frame = contentView_frame;
        
        CGRect imageView_frame = CGRectMake(-(self.view.width*self.scale-self.view.width)/2.0f,
         0,self.view.width*self.scale,self.headerContentView.height-self.contentImageBj);
        
        self.headerImageView.frame = imageView_frame;
        
        self.icon.centerY = CGRectGetMaxY(self.headerImageView.frame);
        
        self.label.centerY = CGRectGetMaxY(self.icon.frame) + 25;
        
        self.anotherLabel.centerY = CGRectGetMaxY(self.label.frame) + 15;
        
        self.visualView.frame = self.headerImageView.bounds;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageview = [[UIImageView alloc] init];
        
        imageview.width = imageview.height = 20;
        
        imageview.x = 10;
        
        imageview.y = 15;
        
        [cell.contentView addSubview:imageview];
        
        UILabel *contentLabel =[[UILabel alloc] init];
        
        contentLabel.height = 35;
        contentLabel.width = self.view.width * .7;
        contentLabel.x= CGRectGetMaxX(imageview.frame) + 12;
        contentLabel.centerY = imageview.centerY;
        contentLabel.font = JSFont(15);
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        
        [cell.contentView addSubview:contentLabel];
        
        /**
         *  右侧图标
         */
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        imageview.tag = 1;
        contentLabel.tag = 2;
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *im = [cell viewWithTag:1];
    UILabel *la =[cell viewWithTag:2];
    
    switch (indexPath.row) {
        case 0:
            im.image = [UIImage imageNamed:@"say"];
            la.text = @"我的帖子";
            break;
        case 1:
            im.image = [UIImage imageNamed:@"tiezi"];
            la.text = @"意见反馈";
            break;
        case 2:
            im.image = [UIImage imageNamed:@"setting"];
            la.text = @"设置";
            break;
        case 3:
            im.tintColor = [UIColor whiteColor];
            im.image = [UIImage imageWithRenderNamed:@"cp1"];
            la.text = @"投诉,举报";
        default:
            break;
    }

    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect tableView_frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        UIImageView *backrounView = [[UIImageView alloc] init];
        
        [backrounView setFrame:CGRectMake(0, 0, self.view.width, self.tableView.height)];
        
        backrounView.image = [UIImage imageNamed:@"底色"];
        
        [_tableView setValue:backrounView forKeyPath:@"backgroundView"];
        
    }
    
    return _tableView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _isPushing = YES;

    
    [self.navigationController.navigationBar setBackgroundImage:self.oldBackNaviIm forBarMetrics:UIBarMetricsDefault];
    
    if (indexPath.row == 1) {
        TheRerunSgViewContoller *bbs = [[TheRerunSgViewContoller alloc] init];
        
        bbs.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:bbs animated:YES];
        
    }
    
    
    if (indexPath.row == 2) {
        
    
        
        settingViewController *svc = [[settingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        svc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:svc animated:YES];
    }
    
    else if (indexPath.row == 0) {
        
        ShowPersonalBBSViewController *spb = [[ShowPersonalBBSViewController alloc] init];
        
        spb.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:spb animated:YES];
    }
    
    else if (indexPath.row == 3) {
        
        tousuJubaoController *spb = [[tousuJubaoController alloc] init];
        
        spb.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:spb animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _isPushing = NO;
    
    [self setNavi];
}

-(void)changeHeaderImage{
    
#warning --这个功能因为接口的原因无法完成.
    
    
//    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
//    
//    [self.view addSubview:web];
//    
//    NSString *urlstr = @"http://www.yueqiao.org/SSM/user/toColorGame";
//    
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    return;
    
    
    UIAlertController *quitControl = [UIAlertController alertControllerWithTitle:@"更改头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    quitControl.title = @"退出登录!";
    //    quitControl.message = @"请注意,一旦退出登录,你将无法再进行任何操作";
    
    BOOL isCamera = NO;
    
    BOOL isLibray = NO;
    
    BOOL isAlbum = NO;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JSLog(@"支持相机");
        isCamera = YES;
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        JSLog(@"支持图库");
        isLibray = YES;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        JSLog(@"支持相片库");
        isAlbum = YES;
    }
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (isCamera) {
            
            [self ModelImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else{
            
            [MBProgressHUD showError:@"无法调出相机"];
        }
        
    }];
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (isAlbum||isLibray) {
            
            UIImagePickerControllerSourceType sourcesType =UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self ModelImagePickerWithSourceType:sourcesType];
        }else{
            
            [MBProgressHUD showError:@"无法调出相册"];
        }
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    
    [quitControl addAction:action1];
    
    [quitControl addAction:action2];
    
    [quitControl addAction:actionCancel];
    
    UIPopoverPresentationController *popover = quitControl.popoverPresentationController;
    if (popover) {
        
        self.sourceViewClear = [[UIView alloc] initWithFrame:CGRectMake(self.icon.centerX, CGRectGetMaxY(self.icon.frame), 300, 100)];
        [self.view addSubview:self.sourceViewClear];
        
        popover.sourceView = self.sourceViewClear;
        
    }
    
    [self presentViewController:quitControl animated:YES completion:nil];
    
}

-(void)ModelImagePickerWithSourceType:(UIImagePickerControllerSourceType) sourcestype{
    
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = [UIColor orangeColor];
    
    UIImagePickerControllerSourceType sourcheType = sourcestype;
    
    //    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeSavedPhotosAlbum | UIImagePickerControllerSourceTypePhotoLibrary;
    picker.sourceType = sourcheType;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - imagePikerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *pickerImage = info[@"UIImagePickerControllerOriginalImage"];
    
    /**
     *
     */
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:info];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    //判断是否含有视频轨道
    BOOL hasVideoTrack = [tracks count] > 0;
    if (hasVideoTrack) {
        [picker dismissViewControllerAnimated:YES completion:^{
          
            [MBProgressHUD showError:@"无法添加视频"];
            
        }];
        return;
    }
    
    /**
     *
     */
    
    self.icon.image = pickerImage;
    
    [self uploadImage:pickerImage];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - upload image
-(void)uploadImage:(UIImage *)pikerImage{
    
    NSData *imageData = UIImageJPEGRepresentation(pikerImage, 0.5f);
    
    NSMutableDictionary *valueDic = [[JSUserManager shareManager] getUserDic];
    
    valueDic[@"img"] = imageData;
    
    [[INetworking shareNet] uploadImageWithName:@"uploadFirstImage" URLString:uploadHeaderImage imageData:imageData passCode:@"file" success:^(id returnObject) {
        JSLog(@"%@",returnObject);
    } failure:^(NSError *error) {
        JSLog(@"%@",error);
    }];
}



@end
