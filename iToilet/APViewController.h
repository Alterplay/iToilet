//
//  APViewController.h
//  iToilet
//
//  Created by Sergii Kryvoblotskyi on 2/15/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>

enum  {
    ToiletStatusFree = 0,
    ToiletStatusBusy = 1,
    ToiletStatusUndefined = 999
    };
typedef NSUInteger ToiletStatus;

@interface APViewController : UIViewController

@end
