//
//  RequestsManager.m
//  APSocketChat
//
//  Created by Sergii Kryvoblotskyi on 1/8/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "RequestsManager.h"

static NSString *kBackgroundSessionIdentidier = @"kBackgroundSessionIdentidier";

typedef void(^SessionRequestCompletionBlock)(id object, NSError *error);

@interface RequestsManager ()
@property (nonatomic, strong) NSURLSessionConfiguration *config;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation RequestsManager

- (id)init {
    self = [super init];
    if (self) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:_config];
    }
    return self;
}

#pragma mark - Public
//GET
- (void)sendGetRequestWithURL:(NSString *)urlString completion:(SessionRequestCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self sendRequest:request withCompletion:completion];
}

//POST
- (void)sendPostRequestWithURL:(NSString *)urlString
                        params:(NSDictionary *)params
                    completion:(SessionRequestCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //Add post data
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [request setHTTPBody:postData];
    
    //Send request
    [self sendRequest:request withCompletion:completion];
}

#pragma mark - Private
- (void)sendRequest:(NSURLRequest *)request withCompletion:(SessionRequestCompletionBlock)completion {
    
    [[_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion) {
            //Don't care about JSON error.
            id object = [self JSONObjectFromData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(object, error);
            });
        }
    }] resume];
}

- (id)JSONObjectFromData:(NSData *)data {
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

@end
