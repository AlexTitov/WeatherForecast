//
//  ALTWeatherLoader.m
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import "ALTWeatherLoader.h"
#import "ALTWeatherParser.h"

@interface ALTWeatherLoader ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) ALTWeatherParser *parser;

@end

@implementation ALTWeatherLoader

- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _url = [NSURL URLWithString:urlString];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.URLCache = nil;
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        _parser = [ALTWeatherParser new];
    }
    return self;
}

- (void)loadWithSuccessBlock:(ALTResponseBlock)successBlock failureBlock:(ALTErrorBlock)failureBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self.parser parseWithData:data completion:^(NSArray *forecasts) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                if (successBlock) {
                    successBlock(forecasts);
                }
            }];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (failureBlock) {
                failureBlock(error);
            }
        }
    }];
    [dataTask resume];
}

@end
