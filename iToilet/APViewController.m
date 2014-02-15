//
//  APViewController.m
//  iToilet
//
//  Created by Sergii Kryvoblotskyi on 2/15/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "APViewController.h"
#import "RequestsManager.h"

static NSString *kUpdateStausURL = @"http://test.mockup.io:88";
static CGFloat kRefreshInterval = 2.0f;

@interface APViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) RequestsManager *requestManager;
@end

@implementation APViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.requestManager = [RequestsManager new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshUIWithToiletStatus:ToiletStatusUndefined];
    [self refreshStatus];
}

- (void)refreshStatus {
    __weak __typeof (self) weakSelf = self;
    [self.requestManager sendGetRequestWithURL:kUpdateStausURL completion:^(id object, NSError *error) {
        [weakSelf startTimedUpdated];
        
        //Off or error
        BOOL sensorStatus = [object[@"sensor_status"] boolValue];
        if (object == nil || sensorStatus == NO || error != nil) {
            [weakSelf refreshUIWithToiletStatus:ToiletStatusUndefined];
        } else {
            
            BOOL value = [object[@"light_status"] boolValue];
            
            //Free
            if (value) {
                [self refreshUIWithToiletStatus:ToiletStatusBusy];
            //Busy
            } else {
                [self refreshUIWithToiletStatus:ToiletStatusFree];
            }
        }
    }];
}

- (void)startTimedUpdated {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kRefreshInterval
                                                  target:self
                                                selector:@selector(refreshStatus)
                                                userInfo:nil
                                                 repeats:NO];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)refreshUIWithToiletStatus:(ToiletStatus)status {
    if (status == ToiletStatusFree) {
        self.imageView.image = [self greenIcon];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } else if (status == ToiletStatusBusy) {
        self.imageView.image = [self redIcon];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    } else {
        self.imageView.image = [self grayIcon];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

#pragma mark - Images
- (UIImage *)greenIcon {
    static UIImage *greenIcon;
    if (!greenIcon) {
        greenIcon = [UIImage imageNamed:@"appGreenBackground"];
    }
    return greenIcon;
}

- (UIImage *)redIcon {
    static UIImage *redIcon;
    if (!redIcon) {
        redIcon = [UIImage imageNamed:@"appRedBackground"];
    }
    return redIcon;
}

- (UIImage *)grayIcon {
    static UIImage *grayIcon;
    if (!grayIcon) {
        grayIcon = [UIImage imageNamed:@"appGrayImage"];
    }
    return grayIcon;
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
