//
//  ALTWeatherParser.h
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ALTWeatherParserCompletionHandler)(NSArray *forecasts);

@interface ALTWeatherParser : NSObject <NSXMLParserDelegate>

- (void)parseWithData:(NSData *)data completion:(ALTWeatherParserCompletionHandler)completion;

@end
