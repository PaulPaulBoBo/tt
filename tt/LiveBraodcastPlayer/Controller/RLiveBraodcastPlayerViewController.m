//
//  RLiveBraodcastPlayerViewController.m
//  tt
//
//  Created by l on 2021/2/24.
//

#import "RLiveBraodcastPlayerViewController.h"
#import "TXLivePlayer.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "R_LBPCoverOperationView.h"

@interface RLiveBraodcastPlayerViewController ()<TXLivePlayListener>

@property (nonatomic, strong) UIView *videoView; // 视频画面
@property (nonatomic, strong) TXLivePlayer *player; // 播放器
@property (nonatomic, strong) NSString *playUrl; // 直播地址
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, assign) TX_Enum_PlayType playType; // 播放类型
@property (nonatomic, strong) R_LBPCoverOperationView *coverOperationView; // 操作视图层


@end

@implementation RLiveBraodcastPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCustomView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.playUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    BOOL isSuc = [self startPlay];
    if(!isSuc) {
        [self stopPlay];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)interactivePopGestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

// 不支持屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - private

-(void)loadCustomView {
    [self.view addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.player setupVideoWidget:CGRectZero containView:self.videoView insertIndex:0];
    
    [self.view addSubview:self.coverOperationView];
    [self.coverOperationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)startPlay {
    if (![self checkPlayUrl:self.playUrl]) {
        return NO;
    }
    [self.player setRenderRotation:HOME_ORIENTATION_DOWN];
    [self.player setRenderMode:RENDER_MODE_FILL_EDGE];
    [self startLoadingAnimation];
    int ret = [_player startPlay:self.playUrl type:_playType];
    if (ret != 0) {
        NSLog(@"播放器启动失败");
        return NO;
    }
    return YES;
}

- (void)stopPlay {
    [self stopLoadingAnimation];
    if (_player) {
        [_player setDelegate:nil];
        [_player removeVideoWidget];
        [_player stopPlay];
    }
}

- (void)startLoadingAnimation {
    self.loadingImageView.hidden = NO;
    [self.loadingImageView startAnimating];
}

- (void)stopLoadingAnimation {
    self.loadingImageView.hidden = YES;
    [self.loadingImageView stopAnimating];
}

-(BOOL)checkPlayUrl:(NSString*)playUrl {
    if ([playUrl hasPrefix:@"rtmp:"]) {
        _playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && ([playUrl rangeOfString:@".flv"].length > 0)) {
        _playType = PLAY_TYPE_LIVE_FLV;
    } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".m3u8"].length > 0) {
        _playType = PLAY_TYPE_VOD_HLS;
    } else{
        return NO;
    }
    return YES;
}



#pragma mark - delegate

/**
 * 直播事件通知
 * @param EvtID 参见 TXLiveSDKEventDef.h
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            [self stopLoadingAnimation];
            
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            // 断开连接时，模拟点击一次关闭播放
            [self stopPlay];
            
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *msg = (NSString*)[dict valueForKey:EVT_MSG];
                NSLog(@"%@", msg);
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            [self startLoadingAnimation];
            
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                __weak __typeof(self) weakSelf = self;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.playUrl.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"您要切换到Wifi再观看吗?"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                            // 先停止，再重新播放
                            [weakSelf stopPlay];
                            [weakSelf startPlay];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
        else if (EvtID == PLAY_EVT_GET_MESSAGE) {
            NSData *msgData = param[@"EVT_GET_MSG"];
            NSString *msg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", msg);
        }
        /*
         7.2 新增
        else if (EvtID == PLAY_EVT_GET_FLVSESSIONKEY) {
            //NSString *Msg = (NSString*)[dict valueForKey:EVT_MSG];
            //[self toastTip:[NSString stringWithFormat:@"event PLAY_EVT_GET_FLVSESSIONKEY: %@", Msg]];
        }
         */
    });

}

/**
 * 网络状态通知
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onNetStatus:(NSDictionary *)param {
    
}

#pragma mark - lazy

-(UIView *)videoView {
    if(_videoView == nil) {
        _videoView = [[UIView alloc] init];
        _videoView.userInteractionEnabled = YES;
    }
    return _videoView;
}

-(TXLivePlayer *)player {
    if(_player == nil) {
        _player = [[TXLivePlayer alloc] init];
        TXLivePlayConfig* config = _player.config;
        // 开启 flvSessionKey 数据回调
        //config.flvSessionKey = @"X-Tlive-SpanId";
        // 允许接收消息
        config.enableMessage = YES;
        // 设置缓冲策略 minAutoAdjustCacheTime->maxAutoAdjustCacheTime 快速：1->1,流畅：5->5,自动：1->5
        config.bAutoAdjustCacheTime = YES;
        config.minAutoAdjustCacheTime = 1.;
        config.maxAutoAdjustCacheTime = 1.;
        [_player setConfig:config];
        [_player setDelegate:self];
    }
    return _player;
}

-(UIImageView *)loadingImageView {
    if(_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],[UIImage imageNamed:@"loading_image1.png"],[UIImage imageNamed:@"loading_image2.png"],[UIImage imageNamed:@"loading_image3.png"],[UIImage imageNamed:@"loading_image4.png"],[UIImage imageNamed:@"loading_image5.png"],[UIImage imageNamed:@"loading_image6.png"],[UIImage imageNamed:@"loading_image7.png"], nil];
        _loadingImageView.animationImages = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden = YES;
    }
    return _loadingImageView;
}

-(R_LBPCoverOperationView *)coverOperationView {
    if(_coverOperationView == nil) {
        _coverOperationView = [[R_LBPCoverOperationView alloc] init];
        __weak typeof(self) wkSelf = self;
        [_coverOperationView configClickBackAction:^{
            __strong typeof(wkSelf) sSelf = wkSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [sSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
    return _coverOperationView;
}

@end
