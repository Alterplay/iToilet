//
//  RequestsManager.h
//  APSocketChat
//
//  Created by Sergii Kryvoblotskyi on 1/8/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SessionRequestCompletionBlock)(id object, NSError *error);
@interface RequestsManager : NSObject
- (void)sendGetRequestWithURL:(NSString *)urlString completion:(SessionRequestCompletionBlock)completion;
- (void)sendPostRequestWithURL:(NSString *)urlString
                        params:(NSDictionary *)params
                    completion:(SessionRequestCompletionBlock)completion;
@end
