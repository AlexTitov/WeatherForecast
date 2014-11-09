//
//  ALTForecast.h
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTForecast : NSObject

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *low;
@property (nonatomic, strong) NSString *high;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *code;

- (instancetype)initWithDay:(NSString *)day date:(NSString *)date low:(NSString *)low high:(NSString *)high text:(NSString *)text code:(NSString *)code;

@end
