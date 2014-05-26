//
//  ZTableViewController.m
//  Dota2-Video
//
//  Created by zhuayi on 5/16/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZTableViewController.h"
#import "MobClick.h"
@interface ZTableViewController ()

@end

@implementation ZTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        //左边线对不齐
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //清除UITableView底部多余的分割线
        [self setExtraCellLineHidden:self.tableView];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page"];
}

//**********************ASIHTTPRequest  start
- (void)http_Async : (NSString *) url
{
    [self setupLoadingWaitView];
    NSLog(@"url === %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL :[ NSURL URLWithString : url]];
    [request setDelegate : self];
    
    //***********设置ASIHTTP缓存
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    //设置缓存路径
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    [cache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"ASIDownloadCache"]];
    
    [cache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    //缓存时间
    [request setSecondsToCache:60*60];
    [self setMyCache:cache];
    
    [request startAsynchronous];
    
    //[request setDownloadCache:[self myCache]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    if (error)
    {
        NSLog(@"error === %@",error);
        [self loadDataFailed];
    }
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{

    self.responseString = [request responseString];
    [self http_result:self.responseString];

    [self removeLoadingMaskView];
}

//字符串转字典
- (NSDictionary *) get_dict_by_strings: (NSString *) strings
{
    NSError *error ;
    NSData * nsdata = [strings dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:nsdata options:NSJSONReadingMutableLeaves error:&error];
}

//**********************ASIHTTPRequest  loding start
#pragma mark - View lifecycle

- (void)setupLoadingWaitView
{
    if (! _mLoadingWaitView)
    {
        _mLoadingWaitView = [[UIView alloc] initWithFrame:self.view.bounds];
        _mLoadingWaitView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        _mLoadingWaitView.autoresizesSubviews = YES;
        _mLoadingWaitView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _mLoadingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-300)/2, 210, 300, 21)];
        _mLoadingStatusLabel.backgroundColor = [UIColor clearColor];
        _mLoadingStatusLabel.textColor = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0];
        _mLoadingStatusLabel.font = [UIFont systemFontOfSize:15.0f];
        _mLoadingStatusLabel.text = @"正在加载数据，请稍等...";
        _mLoadingStatusLabel.textAlignment = UITextAlignmentCenter;
        _mLoadingStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_mLoadingWaitView addSubview:_mLoadingStatusLabel];
        
        _mLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _mLoadingActivityIndicator.backgroundColor = [UIColor clearColor];
        _mLoadingActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _mLoadingActivityIndicator.frame = CGRectMake((self.view.bounds.size.width-30)/2, 170, 30, 30);
        [_mLoadingWaitView addSubview:_mLoadingActivityIndicator];
        [self.view insertSubview:_mLoadingWaitView aboveSubview:self.tableView];
    }
    
    [_mLoadingActivityIndicator startAnimating];
    
    
}
- (void)removeLoadingMaskView
{
    
    if ([_mLoadingWaitView superview])
    {
        [_mLoadingWaitView removeFromSuperview];
    }
}

- (void)loadDataFailed {
    
    _mLoadingActivityIndicator.hidden = YES;
    
    if (!_mNoNetworkImageView)
    {
        UIImage *image = [UIImage imageNamed:@"um_no_network"];
        CGSize imageSize = image.size;
        _mNoNetworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_mLoadingWaitView.bounds.size.width - imageSize.width) / 2, 80, imageSize.width, imageSize.height)];
        _mNoNetworkImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _mNoNetworkImageView.image = image;
    }
    
    if (![_mNoNetworkImageView superview])
    {
        [_mLoadingWaitView addSubview:_mNoNetworkImageView];
    }
    
    _mLoadingStatusLabel.text = @"抱歉，网络连接不畅，请稍后再试！";
}
//**********************ASIHTTPRequest  end


//清除UITableView底部多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float navigation_height;
    
    if (IsIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        navigation_height = 64.f;
    }
    else
    {
        navigation_height = 0;
    }
    
    self.view.frame = CGRectMake(0, navigation_height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navigation_height);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,60, 32)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"toolbar_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backButton addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem;
    NSLog(@"self.navigationItem.leftBarButtonItem == %@",self.navigationItem);
    homeData = [[ZModelHome alloc] init];
}

- (void) backToIndex
{
    //NSLog(@"self.baseControllerDelegate == %@",self.baseControllerDelegate);
    //[self.baseControllerDelegate back];
    [_baseControllerDelegate back];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//**********************MJRefresh START
- (void) addHeaderReload : (UITableView * )tableView delegate : (id) delegate
{
    header = [MJRefreshHeaderView header];
    header.scrollView = tableView;
    header.delegate = delegate;
}

- (void) addFootReload : (UITableView * )tableView delegate : (id) delegate
{
    footer = [MJRefreshFooterView footer];
    footer.scrollView = tableView;
    footer.delegate = delegate;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [self doneloadingReloadTableData];
    [refreshView endRefreshing];
}

- (void)doneloadingReloadTableData
{
    // 刷新表格
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    // 2.2秒后刷新表格UI
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
}
#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
    [header free];
    [footer free];
}
//**********************MJRefresh  END


//**********************EGORefreshTableHeaderView  START
/*
-(void) showPull
{
    if(_refreshHeaderView == nil)
    {
        
        EGORefreshTableHeaderView * view =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)reloadTableViewDataSource
{
    
    _reloading =YES;
    
}

-(void)doneLoadingTableViewData
{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    [self doneloadingReloadTableData];
    
}

//zhuayi 自定义回调方法,用来设置下拉刷新后的回调
-(void)doneloadingReloadTableData
{
    NSLog(@"aaaa==");
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading; // should return if data source model is reloading
    
}

-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return[NSDate date]; // should return date data source was last changed
    
}

-(void)viewWillUnload
{
    _refreshHeaderView = nil;
}
-(void)dealloc
{
    
    _refreshHeaderView =nil;
}
**********************EGORefreshTableHeaderView  END
*/


@end
