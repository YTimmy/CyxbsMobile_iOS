//
//  FinderViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 张润峰 on 15/8/25.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "FinderViewController.h"
#import "ShopViewController.h"
#import "WebViewController.h"
#import "ChuangyeViewController.h"
#import "ShakeViewController.h"
#import "CommunityViewController.h"

#define kCount 3

@interface FinderViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *redrockButton;
@property (weak, nonatomic) IBOutlet UIButton *chuangyeButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *shakeButton;
@property (weak, nonatomic) IBOutlet UIButton *communityButton;


//@property (strong, nonatomic)UIButton *shopButton;
//@property (strong, nonatomic)UIButton *webButton;
//@property (strong, nonatomic)UIButton *introductionButton;
//@property (strong, nonatomic)UIButton *mapButton;
//@property (strong, nonatomic)UIButton *shakeButton;
//@property (strong, nonatomic)UIButton *secretButton;

@end

@implementation FinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ButtonView" owner:self options:nil];
    _buttonsView = [nib objectAtIndex:0];
    _buttonsView.frame = CGRectMake(0, MAIN_SCREEN_W/1.5 + 64, MAIN_SCREEN_W, 300);
    [self.view addSubview:_buttonsView];
    //图片轮播
    self.automaticallyAdjustsScrollViewInsets = NO;//防止出现20或64的下移
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_shopButton addTarget:self
                    action:@selector(enterShop)
          forControlEvents:UIControlEventTouchUpInside];
    
    [_redrockButton addTarget:self
                       action:@selector(enterWeb)
             forControlEvents:UIControlEventTouchUpInside];
    
    [_chuangyeButton addTarget:self
                        action:@selector(enterIntroduction)
              forControlEvents:UIControlEventTouchUpInside];
    
    [_mapButton addTarget:self
                   action:@selector(enterMap)
         forControlEvents:UIControlEventTouchUpInside];
    
    [_shakeButton addTarget:self
                     action:@selector(enterShake)
           forControlEvents:UIControlEventTouchUpInside];
    
    [_communityButton addTarget:self
                      action:@selector(enterCommunity)
            forControlEvents:UIControlEventTouchUpInside];
    
    //设置图片
    for(int i=0;i<kCount;i++){
        NSString *imageName=[NSString stringWithFormat:@"重邮美景%d.jpg",i+1];
        UIImage *image=[UIImage imageNamed:imageName];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image=image;
        [self.scrollView addSubview:imageView];
    }
    //设置每个imageView的位置
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        CGRect frame=imageView.frame;
        frame.origin.x=idx*frame.size.width;
        imageView.frame=frame;
    }];
    
    self.pageControl.currentPage=0;
    //时钟开始
    [self startTime];
}

- (void)enterShop{
    ShopViewController *svc = [[ShopViewController alloc] init];
    [self.navigationController pushViewController:svc
                                         animated:YES];
}

- (void)enterWeb{
    WebViewController *wvc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.navigationController pushViewController:wvc
                                         animated:YES];
}

- (void)enterIntroduction{
    ChuangyeViewController *cvc = [[ChuangyeViewController alloc] init];
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

- (void)enterMap{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://map.baidu.com/mobile/webapp/place/detail/qt=ninf&wd=%E9%87%8D%E5%BA%86%E9%82%AE%E7%94%B5%E5%A4%A7%E5%AD%A6&c=132&searchFlag=bigBox&version=5&exptype=dep&src_from=webapp_all_bigbox&nb_x=11868605&nb_y=3422975&center_rank=1&uid=844a750e01b56cba626858cd&industry=education&qid=9839006734857167438/showall=1&pos=0&da_ref=listclk&da_qrtp=11&detail_from=list&third_party=webapp-aladdin&vt=map"]];

}

- (void)enterShake{
    ShakeViewController *svc = [[ShakeViewController alloc] init];
    [self.navigationController pushViewController:svc
                                         animated:YES];
}

- (void)enterCommunity{
    CommunityViewController *cvc = [[CommunityViewController alloc] init];
    [self.navigationController pushViewController:cvc
                                         animated:YES];
}

#pragma mark - 图片轮播
-(UIScrollView *)scrollView
{
    if(_scrollView==nil){
        //初始化scrollView
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_W, MAIN_SCREEN_W/1.5)];
        _scrollView.backgroundColor=[UIColor yellowColor];
        [self.view addSubview:_scrollView];
        //设置scrollView的相关属性
        _scrollView.contentSize=CGSizeMake(kCount*_scrollView.bounds.size.width, 0);
        _scrollView.bounces=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        //添加代理方法
        _scrollView.delegate=self;
    }
    return _scrollView;
}
-(UIPageControl *)pageControl
{
    if(_pageControl==nil){
        _pageControl=[[UIPageControl alloc] init];
        //分页数
        _pageControl.numberOfPages=kCount;
        //控件的尺寸
        CGSize size=[_pageControl sizeForNumberOfPages:kCount];
        _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
        _pageControl.center=CGPointMake(self.view.center.x, 64 + MAIN_SCREEN_W/1.5 - 15);
        //相关的属性
        //        _pageControl.pageIndicatorTintColor=[UIColor grayColor];
        //        _pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
        //添加控件
        [self.view addSubview:_pageControl];
        //添加事件
        [_pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
-(void) valueChange:(UIPageControl *)page
{
    CGFloat x=page.currentPage*self.scrollView.bounds.size.width;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void) startTime
{
    self.timer=[NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    //添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
//时钟所需要做的事情
-(void) updateTime
{
    int page=(self.pageControl.currentPage+1)%kCount;
    self.pageControl.currentPage=page;
    [self valueChange:self.pageControl];
}
//拖拽的时候时钟停止
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}


//停止拖拽的时候时钟开始
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTime];
    int distance = _scrollView.frame.size.width;
    int num = floor((_scrollView.contentOffset.x+0.5*distance)/distance);
    _pageControl.currentPage = num;
    
}



@end