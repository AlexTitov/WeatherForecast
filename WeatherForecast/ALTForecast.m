//
//  ALTForecast.m
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import "ALTForecast.h"

@implementation ALTForecast

- (instancetype)initWithDay:(NSString *)day date:(NSString *)date low:(NSString *)low high:(NSString *)high text:(NSString *)text code:(NSString *)code
{
    self = [super init];
    if (self) {
        _day = day;
        _date = date;
        _low = low;
        _high = high;
        _text = text;
        _code = code;
    }
    return self;
}

@end
