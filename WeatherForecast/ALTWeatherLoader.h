//
//  ALTWeatherLoader.h
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ALTResponseBlock)(NSArray *forecasts);
typedef void(^ALTErrorBlock)(NSError *error);

@interface ALTWeatherLoader : NSObject

- (instancetype)initWithURLString:(NSString *)urlString;
- (void)loadWithSuccessBlock:(ALTResponseBlock)successBlock failureBlock:(ALTErrorBlock)failureBlock;

@end
