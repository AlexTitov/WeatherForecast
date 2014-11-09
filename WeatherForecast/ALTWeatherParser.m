//
//  ALTWeatherParser.m
//  WeatherForecast
//
//  Created by Alexey Titov on 08/11/14.
//  Copyright (c) 2014 Alexey Titov. All rights reserved.
//

#import "ALTWeatherParser.h"
#import "ALTForecast.h"

@interface ALTWeatherParser()

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *forecasts;
@property (nonatomic, strong) ALTForecast *forecast;
@property (nonatomic, assign) int limit;

@end

@implementation ALTWeatherParser

- (id)init
{
    self = [super init];
    if (self) {
        _forecasts = [NSMutableArray new];
        _limit = 2;
    }
    return self;
}

- (void)parseWithData:(NSData *)data completion:(ALTWeatherParserCompletionHandler)completion
{
    _parser = [[NSXMLParser alloc] initWithData:data];
    _parser.delegate = self;
    [_parser parse];
//    sleep(3);
    if (completion) {
        completion(self.forecasts);
    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"yweather:forecast"] && self.limit > 0) {
        self.forecast = [[ALTForecast alloc] initWithDay:attributeDict[@"day"] date:attributeDict[@"date"] low:attributeDict[@"low"] high:attributeDict[@"high"] text:attributeDict[@"text"] code:attributeDict[@"code"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"yweather:forecast"] && self.limit > 0) {
        [self.forecasts addObject:self.forecast];
        self.limit--;
    }
}

@end
